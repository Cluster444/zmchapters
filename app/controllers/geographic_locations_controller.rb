class GeographicLocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @map = GeographicLocation.map_hash
  end

  def show
    @location = @geographic_location
    @map = @location.map_hash
  end

  def new
    @parent = GeographicLocation.find params[:parent_id]
    @location = @geographic_location
    @map = @parent.map_hash.merge(:events => true)
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
      @map = @location.map_hash.merge(:events => true)
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
