class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to users_url
    flash[:error] = "User not found"
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]
    @user.save!
    flash[:success] = "User created successfully"
    redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @user = User.find params[:id]
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
end
