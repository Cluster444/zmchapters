class UsersController < ApplicationController
  load_and_authorize_resource :user

  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to users_url
    flash[:error] = "User not found"
  end

  before_filter :load_chapter_or_location, :only => [:create,:update]

  def index
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @user = User.find params[:id]
    unless @user.chapter.nil?
      @chapter = @user.chapter
      @country = @user.geographic_location.parent
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]
    @user.chapter = @chapter unless @chapter.nil?
    @user.geographic_location = @location unless @location.nil?
    @user.save!
    flash[:success] = "Account created successfully"
    redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @user = User.find params[:id]
    @user.chapter = @chapter unless @chapter.nil?
    @user.geographic_location = @location unless @location.nil?
    @user.update_attributes! params[:user]
    flash[:success] = "User updated succesfully"
    redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    flash[:success] = "User removed"
    redirect_to users_url
  end

private
  def load_chapter_or_location
    if params[:chapter] and params[:chapter][:id]
      @chapter = Chapter.find params[:chapter][:id]
      @location = @chapter.geographic_location
    elsif params[:geo] and params[:geo][:id]
      @location = GeographicLocation.find params[:geo][:id]
    end
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
