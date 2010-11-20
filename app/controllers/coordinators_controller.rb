class CoordinatorsController < ApplicationController
  load_and_authorize_resource :coordinator

  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new params[:coordinator]
    if @coordinator.save
      redirect_to Chapter.find(@coordinator.chapter_id), :notice => 'Coordinator was created successfully.'
    else
      render :new
    end
  end
end
