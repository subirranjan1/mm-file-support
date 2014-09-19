class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@project) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@project) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@project) { ensure_public_or_authorized param }, only: %w{show}

  def_param_group :project do
    param :project, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the Data Track", :required => true
      param :description, String, "Description of the Data Track", :required => true      
      param :public, ["0", "1"], "Should this project be accessible to the public? (Default: false)"
      param :mover_ids, Array, "Foreign key IDs of related Movers"     
      param :license, String, "Relevant licensing information including a link if possible"     
    end
  end

  # GET /projects
  # GET /projects.json
  api :GET, "/projects.json", "List projects that are accessible by the current user or are marked public"
  param :search, String, "A search parameter to refine terms"  
  error 401, "The user you attempted authentication with cannot be authenticated"      
  def index
    @projects = Project.search(params[:search]).order(:name)
    if current_user
      @projects.select { |project| project.is_accessible_by?(current_user) }
    else
      @projects.select { |project| project.public? }
    end
  end

  api :GET, "/myprojects.json", "List projects that belong to the current user"
  error 401, "The user you attempted authentication with cannot be authenticated"    
  def mine
    @projects = current_user.owned_projects.order(:name)
  end
  
  # GET /projects/1
  # GET /projects/1.json
  api :GET, "/projects/:id.json", "Show a project that the user has access to or is marked public"
  param :id, String, "Primary key ID of the project in question", :required => true
  error 404, "A project could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the project and it is not public."  
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
  api :POST, "/projects.json", "Create a data track"
  param_group :project
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"  
  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    respond_to do |format|
      if @project.save
        format.html { redirect_to({action: 'mine'}, notice: 'Project was successfully created.') }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  api :PUT, "/projects/:id.json", "Update a project"
  param_group :project
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the project"  
  error 404, "A project could not be found with the requested id."    
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to({action: 'mine'}, notice: 'Project was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  api :DELETE, "/projects/:id.json", "Destroy a project that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated or is not the owner of the project"  
  error 404, "A project could not be found with the requested id."    
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to({action: 'mine'}, notice: 'Project was successfully deleted.') }
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
      params.require(:project).permit(:name, :description, :tag_list, :public, :license, :mover_ids => [])
    end
      
end
