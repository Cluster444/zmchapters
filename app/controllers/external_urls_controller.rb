class ExternalUrlsController < ApplicationController

  def index
    @external_urls = ExternalUrl.all
  end

  def new
    @external_url = ExternalUrl.new
  end

  def edit
    @chapter = Chapter.find params[:chapter_id]
    unless @chapter.nil?
      @external_urls = @chapter.external_urls
    else
      flash[:error] = "Chapter not found."
      redirect_to root_url
    end
  end

  def create
  end

  def update
    @external_url = ExternalUrl.find params[:id]
    logger.debug(params[:id] + ":" + @external_url.to_s)
    if @external_url.update_attributes! params[:external_url]
      flash[:notice] = "External URL updated."
      redirect_to @external_url.chapter
    else
      redirect_to edit_chapter_external_urls_path @external_url.chapter
    end
  end

  def destroy
  end

private
  
end
