class GeographicLocationsController < ApplicationController
  def index
  end

  def show
    location = GeographicLocation.find params[:id]
    if location.is_continent?
      @continent = location
      render :show_continent
    else
      if location.is_country?
        @country = location
        render :show_country
      else
        @territory = location
        render :show
      end
    end
  end

  def territory_options
    @location = GeographicLocation.find params[:id]
    unless @location.is_country?
      render :text => "<option>Invalid Request</option>" and return
    end
    render :layout => false
  end
end
