class ChaptersController < ApplicationController
  def index
    @countries = Country.all
    unless params[:search].blank?
      @chapters = Chapter.where(['region LIKE ?', "%#{params[:search]}%"])
    else
      params[:like] = 'A' if params[:like].blank?
      @chapters = Chapter.where(['region LIKE ?', "#{params[:like]}%"])
    end
  end

  def index_group
    if params[:type] == 'country'
      @country = Country.where ['name LIKE ?', "#{params[:value]}"]
      @chapters = @country.chapters
      render :index_country
    else
      @chapters = Chapters.where ['region LIKE ?', 'A%']
      render :index
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
