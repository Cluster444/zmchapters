class ChaptersController < ApplicationController
  def index
    unless params[:search].blank?
      @chapters = Chapter.where(["region LIKE ?", "%#{params[:search]}%"])
    else
      params[:like] = 'A' if params[:like].blank?
      @chapters = Chapter.where(["region LIKE ?", "#{params[:like]}%"])
    end
  end

  def show
    @chapter = Chapter.find params[:id]
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find params[:id]
  end

end
