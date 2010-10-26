class ExternalUrlsController < ApplicationController
  # Makes @chapter and @external_url(s) available after authorization
  load_and_authorize_resource :chapter
  load_and_authorize_resource :external_url, :through => :project

  before_filter :load_chapter

  def index
    #noop
  end

  def show
    #noop
  end

  def new
    #noop
  end

  def edit
    #noop
  end

  def create
    if @external_url.save
      flash[:notice] = "External URL added"
      redirect_to chapter_external_urls_path @chapter
    else
      render :new
    end
  end

  def update
    if @external_url.update_attributes! params[:external_url]
      flash[:notice] = "External URL updated."
      redirect_to chapter_external_urls_path @chapter
    else
      render :edit
    end
  end

  def destroy
    #noop
  end
end
