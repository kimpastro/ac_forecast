class ForecastsController < ApplicationController
  def new; end

  def create
    @forecast = ForecastService.new(
      address: forecast_params[:address],
      zipcode: forecast_params[:zipcode]
    ).forecast

    respond_to do |format|
      format.turbo_stream
    end
  rescue ArgumentError => e
    Rails.logger.error("Forecast error: #{e.message}")
  end

  private

  def forecast_params
    params.permit(:address, :zipcode)
  end
end
