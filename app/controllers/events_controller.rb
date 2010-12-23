class EventsController < ApplicationController
  load_and_authorize_resource

  before_filter :only => [:new, :create] do |controller|
    controller.load_polymorphic :plannable
  end

  respond_to :html, :xml, :only => :index

  def index
    respond_with(@events = @events.search(index_params))
  end

  def show; end
  
  def new; end

  def edit; end

  def create
    @event.save!
    redirect_to @event, :notice => "Event created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @event.update_attributes! params[:event]
    redirect_to @event, :notice => "Event updated successfully"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @event.destroy
    redirect_to Event, :notice => "Event removed successfully"
  end
end
