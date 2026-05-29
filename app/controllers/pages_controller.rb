class PagesController < ApplicationController
  def index; end

  def forecast
    @forecast = ForecastService.new(
      address: forecast_params[:address],
      zipcode: forecast_params[:zipcode]
    ).forecast

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def forecast_params
    params.permit(:address, :zipcode)
  end
end
