class UsersController < ApplicationController
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to users_url
    flash[:error] = "User not found"
  end

  def index
    @users = User.index(index_params)
  end

  def show; end
  def new;  end
  def edit; end

  def create
    unless params[:location_id].blank?
      @user.geographic_location = GeographicLocation.find_by_id(params[:location_id])
    end
    @user.save!
    flash[:notice] = "User created successfully"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    unless params[:chapter_id].blank?
      begin
        chapter = Chapter.find(params[:chapter_id])
        @user.update_attribute :chapter, chapter
        @user.update_attribute :geographic_location, chapter.geographic_location
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordInvalid.new(@user)
      end
    end
    @user.update_attributes! params[:user]
    flash[:notice] = "User updated successfully"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
