class LinksController < ApplicationController
  load_and_authorize_resource

  def index
    @links = Link.search(index_params)
  end

  def show;end

  def new;end

  def edit;end
  
  def create
    @link.save!
    redirect_to @link, :notice => "Link created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @link.update_attributes! params[:link]
    redirect_to @link, :notice => "Link updated successfully"
  rescue
    render :edit
  end

  def destroy
    @link.destroy
    redirect_to Link, :notice => "Link removed successfully"
  end
end
