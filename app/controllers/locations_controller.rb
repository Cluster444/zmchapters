class LocationsController < ApplicationController
  load_and_authorize_resource :only => [:new, :create]

  before_filter :only => [:new, :create] do |controller|
    controller.load_polymorphic(:locateable)
  end

  def new
    @parent = Location.find params[:parent_id]
    @map = @parent.map_hash.merge(:events => true)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :alert => "Cannot create a location without a parent."
  end

  def create
    @parent = Location.find params[:parent_id]
    @location.save!
    @location.move_to_child_of @parent
    redirect_to @location.locateable, :notice => "Location created successfully" 
  rescue ActiveRecord::RecordInvalid
    @map = @location.map_hash.merge(:events => true)
    render :new
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :alert => "Cannot create a location without a parent."
  end
end
