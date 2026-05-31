require 'rails_helper'

RSpec.describe ForecastService do
  context '#forecast' do
    let(:zipcode) { "10017" }
    let(:address) { "1600 Pennsylvania Ave NW, Washington, DC" }
    let(:forecast) do
      {
        current: 20.4,
        max: 12.9,
        min: 10.0
      }
    end
    let(:lat_long) do
      {
        "lat" => "40.7558017",
        "lon" => "-73.9787414"
      }
    end

    subject { described_class.new(address:, zipcode:).forecast }

    before do
      geo_mock_response = instance_double(
        HTTParty::Response,
        parsed_response: [
          {
            "address" => {
              "postcode" => zipcode
            },
            "lat" => "40.7558017",
            "lon" => "-73.9787414"
          }
        ],
        success?: true
      )

      weather_mock_response = instance_double(
        HTTParty::Response,
        parsed_response: {
          "current"  => { "temperature_2m" => 20.4 },
          "hourly" => {
            "temperature_2m" => [ 12.9, 10.3, 10.0, 10.4, 12.2 ]
          }
        },
        success?: true,
      )

      allow(GeoService).to receive(:get)
        .with("/search", { query: { api_key: ENV.fetch("GEOCODE_API_TOKEN"), country: "US", postalcode: "10017" } })
        .and_return(geo_mock_response)

      allow(GeoService).to receive(:get)
        .with("/search", { query: { api_key: ENV.fetch("GEOCODE_API_TOKEN"), q: "1600 Pennsylvania Ave NW, Washington, DC" } })
        .and_return(geo_mock_response)

      allow(WeatherService)
        .to receive(:get)
        .and_return(weather_mock_response)
    end

    it "should cache" do
      expect(Rails.cache)
        .to receive(:write)
        .with(
          "forecast:#{zipcode}",
          forecast,
          expires_in: 30.minutes
        )
        .once
        .and_call_original

      subject
    end

    context "when searching with address" do
      let(:zipcode) { nil }

      it "should return the weather" do
        expect(subject).to eq(
          {
            current: 20.4,
            max: 12.9,
            min: 10.0,
            from_cache: false
          }
        )
      end
    end

    context "when searching with zipcode" do
      let(:address) { nil }

      it "should return the weather" do
        expect(subject).to eq(
          {
            current: 20.4,
            max: 12.9,
            min: 10.0,
            from_cache: false
          }
        )
      end
    end
  end
end
