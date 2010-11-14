class ChaptersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Chapter not found"
    redirect_to chapters_url
  end

  def index
    @chapters = Chapter.all
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
end
