class SessionsController < ApplicationController

  def new
  end

  def create
    if User.authenticate(params[:email], params[:password])
      session[:user_id] = User.find_by_email(params[:email]).id  
      redirect_to root_url, :notice => "Logged in!"      
    else
      flash[:alert] = "There was a problem logging you in."
      redirect_to root_url #, :notice => "Invalid email or password"
    end
  end
    
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
  
end

