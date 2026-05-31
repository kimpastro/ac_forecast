require 'rails_helper'

RSpec.describe GeoService do
  let(:address) { "1600 Pennsylvania Ave NW, Washington, DC" }
  let(:zipcode) { "10017" }
  let(:parsed_response) { [ { "address" => { "postcode" => zipcode }, "lat" => "40.7558017", "lon" => "-73.9787414" } ] }

  before do
    mock_response = instance_double(HTTParty::Response, parsed_response:, success?: true)
    allow(described_class).to receive(:get).and_return(mock_response)
  end

  context '.by_address' do
    subject { described_class.by_address(address) }
    it { is_expected.to eq({ zipcode: "10017", lat: "40.7558017", lon: "-73.9787414" }) }
  end

  context '.by_zipcode' do
    subject { described_class.by_address(zipcode) }
    it { is_expected.to eq({ zipcode: "10017", lat: "40.7558017", lon: "-73.9787414" }) }
  end
end
