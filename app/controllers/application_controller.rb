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

  def store_location(uri=nil)
    session[:return_to] = uri || request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def index_params
    index_keys = [:search, :sort, :direction, :page, :per_page].collect{|k|k.to_s}
    params.select { |k,v| index_keys.include?(k) }
  end
  
  def instance_name
    instance_variable_get("@#{params[:controller].singularize}")
  end

  def index_url
    eval "#{params[:controller]}_url"
  end

  def load_polymorphic(type)
    raise NameError if params[type][:type].blank?
    poly_value =  eval "#{params[type][:type]}.find #{params[type][:id]}"
    instance_name.send("#{type}=", poly_value)
  rescue NameError
    redirect_to index_url, :alert => "#{params[:controller].singularize} needs to be created with a taskable type"
  rescue ActiveRecord::RecordNotFound
    redirect_to index_url, :alert => "No #{params[type][:type]} found."
  end
end
