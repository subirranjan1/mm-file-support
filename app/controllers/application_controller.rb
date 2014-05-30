class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  
  protected
  
  def logged_in?
    unless session[:user_id]
      flash[:notice] = "You need to log in first."
      redirect_back_or_default
      return false
    else
      return true
    end
  end
  
  def redirect_back_or_default
    begin
      redirect_to :back #if request.env["HTTP_REFERER"].nil? then it raises an exception which I rescue to go to the base url
    rescue
      redirect_to root_url
    end
  end
  
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end





