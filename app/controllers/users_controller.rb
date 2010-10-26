class UsersController < ApplicationController
  load_and_authorize_resource :user

  def show
    @chapter = @user.chapter
    @country = @chapter.country.first
  end

  def new
  end

  def edit
  end

  def create
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
end
