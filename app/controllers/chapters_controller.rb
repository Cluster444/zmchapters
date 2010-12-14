class ChaptersController < ApplicationController
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to Chapter, :alert => "There was a problem with the request."
  end

  def index
    @chapters = Chapter.index(index_params)
    @map = GeographicLocation.map_hash
  end
  
  def show
    @location = @chapter.location
    @map = @location.map_hash
    @subchapters = Chapter.find_all_by_location(@location)
    @links = @chapter.links
    @events = @chapter.events
  end
  
  def select_country_for_new
  end

  def select_territory_for_new
    @parent = GeographicLocation.find(params[:parent_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to Chapter, :notice => "Could not find the parent country."
  end

  def new
    @location = GeographicLocation.find_by_id params[:location_id]
    if @location.nil?
      redirect_to Chapter, :alert => "Invalid location for new chapter."
    else
      @map = @location.map_hash.merge(:events => true)
      @chapter.geographic_location = @location
      @chapter.name = @location.name
      if @location.is_country?
        @chapter.category = 'country'
      elsif @location.is_territory?
        if params[:category] == "subchapter"
          store_location(new_chapter_path)
          redirect_to new_geo_url(:parent_id => @location.id)
        end
      end
    end
  end

  def create
    @location = GeographicLocation.find params[:location_id]
    unless params[:location].nil?
      @location.update_attributes params[:location]
    end 
    @chapter.geographic_location = @location
    @chapter.save!
    redirect_to @chapter, :notice => "Chapter created successfully"
  rescue ActiveRecord::RecordInvalid
    @map = @location.map_hash.merge(:events => true)
    render :new
  end

  def create_link
    @link = Link.new params[:link]
    @link.linkable = @chapter
    @link.save!
    redirect_to @chapter, :notice => "Link added successfully"
  rescue ActiveRecord::RecordInvalid
    load_edit_models
    render :edit
  end

  def edit
    load_edit_models
  end
  
  def update
    if params[:location]
      @chapter.location.update_attributes params[:location]
    end
    @chapter.update_attributes! params[:chapter]
    redirect_to @chapter, :notice => "Chapter updated successfully"
  rescue ActiveRecord::RecordInvalid
    load_edit_models
    render :edit
  end

  def update_link
    @link = Link.find params[:link_id]
    @link.update_attributes! params[:link]
    redirect_to @chapter, :notice => "Link updated successfully"
  rescue ActiveRecord::RecordInvalid
    load_edit_models
    render :edit
  end

private
  
  def load_edit_models
    @location = @chapter.location
    @map = @location.map_hash.merge(:events => true)
    @links = @chapter.links
    @coordinators = @chapter.coordinators
  end

  def sort_column
    Chapter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
