class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter :ensure_owner, only: [:destroy]
  before_filter :ensure_authorized, only: [:edit, :update]
  before_filter :ensure_public_or_authorized, only: [:show]
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.search(params[:search]).order(:name)
  end

  def mine
    @projects = current_user.all_projects.order(:name)
    render :index
  end
  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :tag_list, :public)
    end
    
    def ensure_owner
      unless current_user and @project.owner == current_user
         flash[:notice] = "You do not have access rights to this project."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end
    
    def ensure_public_or_authorized
      unless @project.public or (current_user and @project.is_accessible_by? current_user)        
         flash[:notice] = "This project is not authorized for public access and you are not its owner."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end    
    
    def ensure_authorized
      unless current_user and @project.is_accessible_by? current_user
         flash[:notice] = "You do not have access rights to this project."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end    
end
