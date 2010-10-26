class ChaptersController < ApplicationController
  # Makes @chapter available after authorization runs
  load_and_authorize_resource :chapter

  def index
    @countries = Country.all
    unless params[:search].blank?
      @chapters = Chapter.search "%#{params[:search]}%", params[:page]
    else
      params[:like] = 'A' if params[:like].blank?
      @chapters = Chapter.search "#{params[:like]}%", params[:page]
    end
  end

  def index_country
    if params[:name].nil?
      @country = Country.find_by_id params[:id]
    else
      @country = Country.find_by_name params[:name]
    end
    
    if @country.nil?
      if params[:name].nil?
        flash[:notice] = "No country found by the id " + params[:id]
      else
        flash[:notice] = "No country found by the name " + params[:name]
      end
      redirect_to chapters_url
    else
      @chapters = @country.chapters.paginate(:per_page => 20, :page => params[:page])
    end
  end

  def show
    @country = @chapter.country.first
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
