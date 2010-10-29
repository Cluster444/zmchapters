class ChaptersController < ApplicationController
  # Makes @chapter available after authorization runs
  load_and_authorize_resource :chapter

  def index
    unless params[:search].blank?
      @chapters = Chapter.search "%#{params[:search]}%", params[:page]
    else
      params[:like] = '%' if params[:like].blank?
      @chapters = Chapter.search "#{params[:like]}%", params[:page]
    end
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def create
    if @chapter.save
      flash[:notice] = "Chapter created"
      redirect_to chapter_path @chapter
    else
      render :new
    end
  end

  def update
    if @chapter.update_attributes params[:chapter]
      flash[:notice] = "Chapter updated"
      redirect_to chapter_path @chapter
    else
      render :edit
    end
  end
end
