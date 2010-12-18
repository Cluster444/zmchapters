class FeedbackRequestsController < ApplicationController
  load_and_authorize_resource
  
  helper_method :sort_column, :sort_direction

  def index
    @feedbacks = FeedbackRequest.search(index_params)
  end

  def show; @feedback = @feedback_request; end

  def new; @feedback = @feedback_request; end

  def edit; @feedback = @feedback_request; end

  def create
    @feedback = (user_signed_in? ? @feedback_request : FeedbackRequest.new)
    @feedback.user = current_user if user_signed_in?
    @feedback.save!
    redirect_to (user_signed_in? ? @feedback : home_url), :notice => "Feedback submitted successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @feedback = @feedback_request
    @feedback.update_attributes! params[:feedback_request]
    redirect_to @feedback, :notice => "Feedback updated successfully"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

private
  
  def sort_column
    params[:sort] ||= "created_at"
    FeedbackRequest.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    params[:direction] ||= "desc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
