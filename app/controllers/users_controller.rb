class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in#, only: [:edit, :update, :destroy]
  before_filter :ensure_owner, only: [:edit, :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
        
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: 'User was successfully created and emailed their password.' }
        format.json { head :created, location: edit_user_path(@user) }
        Mailer.forgot_password(@user, @user.password).deliver        
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update        
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user), notice: 'User was successfully updated.' }
        format.json { head :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
      
  # assign them a random one and mail it to them, asking them to change it -- only used by rake service - others use password_resets_controller
   def forgot_password
     @user = User.find_by_email(params[:email])
     random_password = Array.new(10).map { (65 + rand(58)).chr }.join
     random_password += "1$" # stupid kludge to make it accepted by the acceptable password regex
     @user.password = @user.password_confirmation = random_password
     @user.save!
     Mailer.forgot_password(@user, random_password).deliver
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :alias, :password_confirmation)
    end
    
    def ensure_owner
      unless current_user and @user == current_user
         flash[:notice] = "You do not have access rights to the specified user."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end
end
