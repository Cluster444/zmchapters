class GeographicTerritoriesController < ApplicationController
  def index
  end

  def show
    geo_territory = GeographicTerritory.find params[:id]
    if geo_territory.continent?
      @continent = geo_territory
      render :show_continent
    else
      if geo_territory.country?
        @country = geo_territory
        render :show_country
      else
        @territory = geo_territory
        render :show
      end
    end
  end

end
