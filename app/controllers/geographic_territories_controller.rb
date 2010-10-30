class GeographicTerritoriesController < ApplicationController
  def index
  end

  def show
    location = GeographicTerritory.find params[:id]
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

end
