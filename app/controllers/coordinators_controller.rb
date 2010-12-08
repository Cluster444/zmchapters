class CoordinatorsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator.save!
    redirect_to @coordinator.chapter, :notice => "Coordinator created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end
end
