class ChaptersController < ApplicationController
  #load_and_authorize_resource :chapter
  
  def index
    @chapters = Chapter.paginate :page => params[:page]
  end
  #def index
  #  unless params[:search].blank?
  #    @chapters = Chapter.search "%#{params[:search]}%", params[:page]
  #  else
  #    params[:like] = '%' if params[:like].blank?
  #    @chapters = Chapter.search "#{params[:like]}%", params[:page]
  #  end
  #end

  def show
    @chapter = Chapter.find params[:id]
    render :status => :not_found if @chapter.nil?
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find params[:id]
    render :status => :not_found if @chapter.nil?
  end
  
  def create
    @chapter = Chapter.new params[:chapter]
    @chapter.save!
    flash[:notice] = "Chapter created successfully"
    redirect_to chapters_url
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
  
  end
end
