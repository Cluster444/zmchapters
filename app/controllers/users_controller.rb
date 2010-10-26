class UsersController < ApplicationController
  before_filter :load_user, :only => [:show,:edit,:update]

  def show
    @chapter = @user.chapter
    @country = @chapter.country.first
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new params[:user]
    @user.skip_confirmation!
    if @user.save
      flash[:notice] = "User registered."
      redirect_to user_path @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes
      flash[:notice] = "User profile udpated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
  end

private
  
  def load_user
    @user = User.find params[:id]
  end
end
