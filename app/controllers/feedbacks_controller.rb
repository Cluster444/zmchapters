class FeedbacksController < ApplicationController
  load_and_authorize_resource
  
  helper_method :sort_column, :sort_direction

  def index
    @feedbacks = @feedbacks.search(index_params)
  end

  def show; end

  def new; end

  def edit; end

  def create
    @feedback = (user_signed_in? ? @feedback : Feedback.new)
    @feedback.user = current_user if user_signed_in?
    @feedback.save!
    redirect_to (user_signed_in? ? @feedback : home_url), :notice => "Feedback submitted successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @feedback.update_attributes! params[:feedback]
    redirect_to @feedback, :notice => "Feedback updated successfully"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

private
  
  def sort_column
    params[:sort] ||= "created_at"
    Feedback.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    params[:direction] ||= "desc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
