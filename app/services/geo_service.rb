class GeoService
  include HTTParty
  base_uri "https://geocode.maps.co"

  def self.by_address(address)
    result = get(
      "/search",
      query: {
        q: address,
        api_key: ENV.fetch("GEOCODE_API_TOKEN")
      }
    )

    normalize_result(result)
  end

  def self.by_zipcode(zipcode)
    result = get(
      "/search",
      query: {
        postalcode: zipcode,
        country: "US",
        api_key: ENV.fetch("GEOCODE_API_TOKEN")
      }
    )

    normalize_result(result)
  end

  private_class_method def self.normalize_result(result)
    return nil unless result.success?

    response = result.parsed_response
    return nil if response.blank?

    {
      zipcode: response.first["address"]["postcode"],
      lat: response.first["lat"],
      lon: response.first["lon"]
    }
  end
end
