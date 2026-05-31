class WeatherService
  include HTTParty
  base_uri "https://api.open-meteo.com/v1"

  def self.by_coordinates(latitude: nil, longitude: nil)
    result = get(
      "/forecast",
      query: {
        latitude:,
        longitude:,
        current: "temperature_2m",
        hourly: "temperature_2m"
      }
    )
    return nil unless result.success?

    response = result.parsed_response
    return nil if response.blank?

    {
      current: response["current"]["temperature_2m"],
      max: response["hourly"]["temperature_2m"].max,
      min: response["hourly"]["temperature_2m"].min
    }
  end
end
