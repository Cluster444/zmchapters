class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    if user_signed_in?
      redirect_to root_url
    else
      redirect_to new_user_session_path
    end
  end
end
