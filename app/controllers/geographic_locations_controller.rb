class GeographicLocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @map = {:lat => 0, :lng => 0, :zoom => 2, :markers => GeographicLocation.markers}
  end

  def show
    @location = @geographic_location
    @map = @location.coordinates_hash.merge(:markers => GeographicLocation.markers)
  end

  def new
    @parent = GeographicLocation.find params[:parent_id]
    @location = @geographic_location
    @map = @parent.coordinates_hash.merge(:markers => GeographicLocation.markers)
  end

  def create
    @parent = GeographicLocation.find params[:parent_id]
    @location = @geographic_location
    if @location.save
      @location.move_to_child_of @parent
      flash[:success] = "Location created successfully"
      unless session[:return_to].nil?
        redirect_to(session[:return_to] + "?location_id=#{@location.id}")
      else
        redirect_to(geo_url(@location))
      end
    else
      render :new
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
