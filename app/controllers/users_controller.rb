class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, only: [:edit, :update, :destroy]
  before_filter :ensure_owner, only: [:edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless current_user == @user
      flash[:notice] = "You can only edit yourself!"
      redirect_back_or_default
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
        
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update    
    unless current_user == @user
      flash[:notice] = "You can only edit yourself!"
      redirect_back_or_default
    end    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
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
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
      
  # assign them a random one and mail it to them, asking them to change it
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
