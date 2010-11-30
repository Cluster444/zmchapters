class FeedbackRequestsController < ApplicationController
  load_and_authorize_resource
  def index
  end

  def show
  end

  def new
    @feedback = FeedbackRequest.new
  end

  def create
    @feedback = FeedbackRequest.new params[:feedback_request]
    @feedback.save!
    flash[:notice] = "Feedback submitted successfully"
    redirect_to current_user
  rescue ActiveRecord::RecordInvalid
    render :new
  end

end
