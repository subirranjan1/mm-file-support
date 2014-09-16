class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@project) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@project) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@project) { ensure_public_or_authorized param }, only: %w{show}
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.search(params[:search]).order(:name)
    if current_user
      @projects.select { |project| project.is_accessible_by?(current_user) }
    else
      @projects.select { |project| project.public? }
    end
  end

  def mine
    @projects = current_user.owned_projects.order(:name)
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
      params.require(:project).permit(:name, :description, :tag_list, :public, :mover_ids => [])
    end
      
end
