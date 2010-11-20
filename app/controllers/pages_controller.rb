class PagesController < ApplicationController
  def show
    @page = Page.find_by_uri params[:uri]
    authorize! :read, @page
    render :text => "Page not found: #{params[:uri]}" if @page.nil?
  end

  def edit
    @page = Page.find_by_uri params[:uri]
    authorize! :update, @page
    render :text => "Page not found" if @page.nil?
  end

  def update
    @page = Page.find_by_uri params[:uri]
    authorize! :update, @page
    @page.update_attributes! params[:page]
    flash[:success] = "#{@page.title} updated successfully"
    redirect_to page_path
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

private
  
  def page_path
    send("#{@page.uri}_path")
  end
end
