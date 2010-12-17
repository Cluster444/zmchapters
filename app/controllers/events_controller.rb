class EventsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :xml, :only => :index

  def index
    respond_with(@events = Event.search(index_params))
  end

  def show
    @event = Event.find params[:id]
  end
  
  def new
    @event = Event.new :starts_at => DateTime.now, :ends_at => DateTime.now + 1.hour
    if params[:plannable_type] && params[:plannable_id]
      begin
        @plannable = instance_eval(params[:plannable_type]).find params[:plannable_id]
      rescue; end
    end
  end

  def edit
    @event = Event.find params[:id]
  end

  def create
    @event = Event.new params[:event]
    @event.save!
    redirect_to @event, :notice => "Event created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @event = Event.find params[:id]
    @event.update_attributes! params[:event]
    redirect_to @event, :notice => "Event updated successfully"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end
end
