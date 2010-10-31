class UsersController < ApplicationController
  load_and_authorize_resource :user
  
  def index
  end

  def show
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
    if params[:user][:password].blank?
      [:password, :password_confirmation].collect{|p| params[:user].delete(p)}
    else
      @user.errors[:base] << "The password you entered is incorrect" unless @user.valid_password?(params[:user][:current_password])
    end

    if @user.errors[:base].empty? and @user.update_attributes params[:user]
      flash[:notice] = "User profile udpated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
  end
end
