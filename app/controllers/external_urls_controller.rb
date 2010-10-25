class ExternalUrlsController < ApplicationController
  before_filter :load_chapter

  def index
    @external_urls = @chapter.external_urls
  end

  def new
    @external_url = @chapter.external_urls.new
  end

  def edit
    @external_url = ExternalUrl.find params[:id]
  end

  def create
    @external_url = @chapter.external_urls.new params[:external_url]
    if @external_url.save
      flash[:notice] = "External URL added"
      redirect_to chapter_external_urls_path @chapter
    else
      render :new
    end
  end

  def update
    @external_url = ExternalUrl.find params[:id]
    if @external_url.update_attributes! params[:external_url]
      flash[:notice] = "External URL updated."
      redirect_to chapter_external_urls_path @chapter
    else
      render :edit
    end
  end

  def destroy
  end

private
  
  def load_chapter
    @chapter = Chapter.find params[:chapter_id]
  end
  
end
