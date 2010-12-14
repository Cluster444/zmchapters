class CoordinatorsController < ApplicationController
  load_and_authorize_resource
  
  def new; end

  def create
    @coordinator.user    = User.find_by_id params[:coordinator][:user_id]
    @coordinator.chapter = Chapter.find_by_id params[:coordinator][:chapter_id]
    @coordinator.save!
    redirect_to @coordinator.chapter, :notice => "Coordinator created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end
end
