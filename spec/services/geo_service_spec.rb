require 'rails_helper'

RSpec.describe GeoService do
  context '.geo_by_zipcode' do
    let(:zipcode) { "10017" }

    before do
      mock_response = instance_double(
        HTTParty::Response,
        parsed_response: [ { "lat" => "40.7558017", "lon" => "-73.9787414", "type" => "house", "place_rank" => 30 } ],
        success?: true,
      )

      allow(described_class).to receive(:get).and_return(mock_response)
    end

    it "should return lat and lon hash" do
      expect(described_class.geo_by_zipcode(zipcode)).to eq(
        {
          "lat" => "40.7558017",
          "lon" => "-73.9787414"
        }
      )
    end
  end
end
