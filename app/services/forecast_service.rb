class ForecastService
  EXPIRE_TIME = 30.minutes
  CACHE_NAMESPACE = "forecast".freeze

  attr_reader :address, :zipcode

  def initialize(address: nil, zipcode: nil)
    raise ArgumentError, "address or zipcode must be provided" if address.blank? && zipcode.blank?

    @zipcode = Zipcode.normalize(zipcode)
    @address = address
  end

  def forecast
    if Zipcode.valid?(zipcode)
      cached = read_cache
      return cached if cached.present?

      geo = GeoService.by_zipcode(zipcode)
    else
      geo = GeoService.by_address(address)
    end
    return nil if geo.blank?

    cached = read_cache
    return cached if cached.present?

    forecast = WeatherService.by_coordinates(
      latitude: geo[:lat],
      longitude: geo[:lon],
    )
    return nil if forecast.blank?

    write_cache(forecast)
    forecast.merge(from_cache: false)
  end

  private

  def read_cache
    Rails.cache.read(cache_key)&.merge(from_cache: true)
  end

  def write_cache(data)
    Rails.cache.write(cache_key, data, expires_in: EXPIRE_TIME)
  end

  def cache_key
    "#{CACHE_NAMESPACE}:#{zipcode}"
  end
end
