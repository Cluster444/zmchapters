class ChaptersController < ApplicationController
  load_and_authorize_resource :except => [:show]

  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to Chapter, :alert => "There was a problem with the request."
  end

  def index
    @chapters = @chapters.search(index_params)
    @map = Location.map_hash
  end
  
  def show
    @chapter = Chapter.find_by_name(params[:chapter_name]) || Chapter.find(params[:id])
    authorize! :read, @chapter
    @location = @chapter.location
    @map = @location.map_hash
    @subchapters = Chapter.find_all_by_location(@location)
    @links = @chapter.links
    @events = @chapter.events
    @coordinators = @chapter.coordinators
  end
  
  def new; end

  def create
    @chapter.save!
    redirect_to new_location_url(:locateable_type => 'Chapter', :locateable_id => @chapter.id, :return_to => "Chapter##{@chapter.id}")
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    load_edit_models
  end
  
  def update
    @chapter.update_attributes! params[:chapter]
    redirect_to chapter_path(@chapter.name), :notice => "Chapter updated successfully"
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
    #Chapter.sortable_columns.include?(params[:sort]) ? params[:sort] : "name"
    Chapter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
