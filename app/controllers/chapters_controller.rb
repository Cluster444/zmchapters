class ChaptersController < ApplicationController
  def index
    @chapters = Chapter.all
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
