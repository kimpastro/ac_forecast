class ForecastService
  EXPIRE_TIME = 30.minutes

  attr_reader :address, :zipcode

  def initialize(address: nil, zipcode: nil)
    @address    = address
    @zipcode    = Zipcode.normalize(zipcode)
  end

  def forecast
    resolved_zipcode = zipcode.presence || GeoService.get_zipcode_by_address(address)
    return nil unless Zipcode.valid?(resolved_zipcode)

    cache_key = "forecast:#{resolved_zipcode}"
    cached = Rails.cache.read(cache_key)

    if cached.present?
      return cached.merge(from_cache: true)
    end

    geo = GeoService.geo_by_zipcode(resolved_zipcode)
    return nil if geo.blank?

    forecast = WeatherService.by_coordinates(
      latitude: geo["lat"],
      longitude: geo["lon"],
    )

    Rails.cache.write(cache_key, forecast, expires_in: EXPIRE_TIME)
    forecast.merge(from_cache: false)
  end
end
