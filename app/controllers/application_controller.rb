class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :set_user_with_http_auth, if: :is_json_request?
  protected
  
  def ensure_logged_in
    if request.format === :json
      user = authenticate_or_request_with_http_basic{ |u, p| User.authenticate(u, p) }
      if user.nil?
        render nothing: true, status: :unauthorized       
      else
        @current_user = user
      end
    else
      unless session[:user_id]
        flash[:notice] = "You need to log in first."
        redirect_back_or_default
        return false
      else
        return true
      end
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
  
  # return the current user object if someone is authenticated properly otherwise return false
  def current_user
    if request.format === :json
      return @current_user
    else    
     return @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  
  def ensure_owner obj
    unless current_user and obj.owner == current_user
      if request.format === :json
        render nothing: true, status: :unauthorized
      else
        flash[:notice] = "You do not have access rights to this project."
        redirect_back_or_default
        return false
      end
    else
      return true
    end      
  end
  
  def ensure_public_or_authorized obj
    p obj
    unless obj.public or (current_user and obj.is_accessible_by? current_user)      
      if request.format === :json
        render nothing: true, status: :unauthorized
      else  
        flash[:notice] = "This project is not authorized for public access and you are not its owner."
        redirect_back_or_default
        return false
      end
    else
      return true
    end      
  end    
  
  def ensure_authorized obj
    unless current_user and obj.is_accessible_by? current_user
      if request.format === :json
        render nothing: true, status: :unauthorized
      else      
        flash[:notice] = "You do not have access rights to this project."
        redirect_back_or_default
        return false
      end
    else
      return true
    end      
  end
  
  def set_user_with_http_auth
    if user = authenticate_or_request_with_http_basic{ |u, p| User.authenticate(u, p) }
      @current_user = user
    else
      render nothing: true, status: :unauthorized   
    end
  end  
  
  private
  
  def is_json_request?
    request.format === :json
  end
end





