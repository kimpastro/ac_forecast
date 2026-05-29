class GeoService
  include HTTParty
  base_uri "https://geocode.maps.co"

  def self.get_zipcode_by_address(address)
    result = get(
      "/search",
      query: {
        q: address,
        api_key: ENV.fetch("GEOCODE_API_TOKEN")
      }
    )

    response = result.parsed_response
    return nil if response.blank?

    response.first["address"]["postcode"]
  end

  def self.geo_by_zipcode(zipcode)
    result = get(
      "/search",
      query: {
        postalcode: zipcode,
        country: "US",
        api_key: ENV.fetch("GEOCODE_API_TOKEN")
      }
    )

    response = result.parsed_response
    return nil if response.blank?

    response.first.slice("lat", "lon")
  end
end
