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
      @chapters = @country.chapters
    end
  end

  def show
    @chapter = Chapter.find params[:id]
    @country = @chapter.country.first
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find params[:id]
  end

end
