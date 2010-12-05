class CoordinatorsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new params[:coordinator]
    @coordinator.save!
    flash[:notice] = "Coordinator created successfully"
    redirect_to users_url(@coordinator.user)
  rescue ActiveRecord::RecordInvalid
    render :new
  end
end
