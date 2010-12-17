class UsersController < ApplicationController
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to users_url
    flash[:error] = "User not found"
  end

  def index
    @users = User.search(index_params)
  end

  def show; end
  def new;  end
  def edit; end

  def create
    @user.save!
    flash[:notice] = "User created successfully"
    redirect_to (user_signed_in? ? @user : new_user_session_path)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @user.update_attributes! params[:user]
    flash[:notice] = "User updated successfully"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def join_chapter
    chapter = Chapter.find params[:chapter_id]
    @user.update_attribute :chapter, chapter
    redirect_to chapter, :notice => "You have joined the #{chapter.name} chapter"
  rescue ActiveRecord::RecordNotFound
    redirect_to Chapter, :alert => "Chapter does not exist"
  end

private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
