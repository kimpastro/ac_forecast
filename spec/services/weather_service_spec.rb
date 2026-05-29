require 'rails_helper'

RSpec.describe WeatherService do
  context '.by_coordinates' do
    let(:latitude)  { "52.52" }
    let(:longitude) { "13.419998" }

    before do
      mock_response = instance_double(
        HTTParty::Response,
        parsed_response: {
          "current"  => { "temperature_2m" => 20.4 },
          "hourly" => {
            "temperature_2m" => [ 12.9, 10.3, 10.0, 10.4, 12.2 ]
          }
        },
        success?: true,
      )

      allow(described_class).to receive(:get).and_return(mock_response)
    end

    it "should return lat and lon hash" do
      expect(described_class.by_coordinates(latitude:, longitude:)).to eq(
        {
          current: 20.4,
          max: 12.9,
          min: 10.0
        }
      )
    end
  end
end
