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
      allow(GeoService)
        .to receive(:get_zipcode_by_address)
        .with(address)
        .and_return("10017")

      allow(GeoService)
        .to receive(:geo_by_zipcode)
        .and_return(lat_long)

      allow(WeatherService)
        .to receive(:by_coordinates)
        .and_return(forecast)
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
