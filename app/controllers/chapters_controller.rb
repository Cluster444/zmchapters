class ChaptersController < ApplicationController
  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Chapter not found"
    redirect_to chapters_url
  end

  def index
    @chapters = Chapter.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @chapter = Chapter.find params[:id]
  end

  def search
    result = Chapter.search_name params[:search_name]
    if result.class == Chapter
      @chapter = result
      render :show
    else
      @chapters = result
      render :index
    end
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find params[:id]
  end
  
  def create
    @chapter = Chapter.new params[:chapter]
    location = GeographicLocation.find params[:geo][:id]
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
