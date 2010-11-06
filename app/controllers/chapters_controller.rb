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

  #def new
  #end

  #def edit
  #end
  
  #def create
  #  if @chapter.save
  #    flash[:notice] = "Chapter created"
  #    redirect_to chapter_path @chapter
  #  else
  #    render :new
  #  end
  #end

  #def update
  #  if @chapter.update_attributes params[:chapter]
  #    flash[:notice] = "Chapter updated"
  #    redirect_to chapter_path @chapter
  #  else
  #    render :edit
  #  end
  #end
end
