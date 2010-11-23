class GeographicLocationsController < ApplicationController
  def index
  end

  def show
    @location = GeographicLocation.find params[:id]
  end

  def territory_options
    @location = GeographicLocation.find params[:id]
    unless @location.is_country?
      render :text => "<option>Invalid Request</option>" and return
    end
    render :layout => false
  end
end
