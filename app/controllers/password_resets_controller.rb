class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      note = "Email sent with password reset instructions."
      user.send_password_reset
    else
      note = "Email address not found in the database."
    end
    redirect_to root_url, :notice => note
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(reset_params)
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reset_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation)
    end
end