class SiteOptionsController < ApplicationController
  load_and_authorize_resource :site_option

  def index
    @site_options = SiteOption.paginate(:page => params[:page])
  end

  def edit
  end

  def update
    if @site_option.update_attributes params[:site_option]
      redirect_to site_options_url, :notice => "#{@site_option.key.titleize} updated successfully"
    else
      render :edit
    end
  end
end
