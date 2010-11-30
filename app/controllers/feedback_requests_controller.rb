class FeedbackRequestsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  def index
    @feedback = FeedbackRequest.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @feedback = FeedbackRequest.find params[:id]
  end

  def new
    @feedback = FeedbackRequest.new
  end

  def create
    @feedback = FeedbackRequest.new params[:feedback_request]
    @feedback.user = current_user if user_signed_in?
    @feedback.save!
    flash[:notice] = "Feedback submitted successfully"
    redirect_to current_user
  rescue ActiveRecord::RecordInvalid
    render :new
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
