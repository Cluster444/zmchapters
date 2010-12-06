class ChaptersController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Chapter not found"
    redirect_to chapters_url
  end

  def index
    if params[:view] == 'map'
      @map = {:lat => 0, :lng => 0, :zoom => 2}
      @map[:markers] = GeographicLocation.markers
    end
    @chapters = Chapter.index(index_params)
  end
  
  def show
    @location = @chapter.location
    if params[:view] == 'map'
      @map = {:lat => @location.lat, :lng => @location.lng, :zoom => @location.zoom}
      @map[:markers] = GeographicLocation.markers
    end
    @subchapters = Chapter.find_all_by_location(@location)
  end

  def new
    @location = GeographicLocation.find(params[:location_id]) rescue nil
  
    if @location.nil?
      flash[:error] = "Please select a location before creating a chapter"
      redirect_to geo_index_path
    else
      if @location.need_coordinates?
        @map = {:lat => @location.lat, :lng => @location.lng, :zoom => @location.zoom}
      end
      @chapter.geographic_location = @location
      @chapter.name = @location.name
      if @location.is_country?
        @chapter.category = 'country'
      elsif @location.is_territory?
        if params[:category] == "subchapter"
          store_location(new_chapter_path)
          redirect_to new_geo_url(:parent_id => @location.id)
        else
          @chapter.category = params[:category]
        end
      end
    end
  end

  def edit
    @chapter = Chapter.find params[:id]
  end
  
  def create
    location = GeographicLocation.find params[:location_id]
    location.update_attributes! params[:geo] unless params[:geo].nil?
    @chapter = Chapter.new params[:chapter]
    @chapter.geographic_location = location
    @chapter.save!
    flash[:notice] = "Chapter created successfully"
    redirect_to chapter_url(@chapter)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @chapter = Chapter.find params[:id]
    @chapter.update_attributes! params[:chapter]
    flash[:notice] = "Chapter updated successfully"
    redirect_to chapter_url(@chapter)
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @chapter = Chapter.find params[:id]
    @chapter.destroy
    flash[:notice] = "Chapter has been removed"
    redirect_to chapters_url
  end

private
  
  def sort_column
    Chapter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
