require 'zip'
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :export, :make_public]
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
      param :sensor_type_ids, Array, "Foreign key IDs of the associated sensor types"            
      param :license, String, "Relevant licensing information including a link if possible"     
    end
  end

  # GET /projects
  # GET /projects.json
  api :GET, "/projects.json", "List projects that are accessible by the current user or are marked public"
  param :search, String, "A search parameter to refine terms"  
  error 401, "The user you attempted authentication with cannot be authenticated"      
  def index
    @projects = Project.includes(:owner, :sensor_types).search(params[:search]).order(:name)
    if current_user
      @projects = @projects.select { |project| project.is_accessible_by?(@current_user) or project.public?}
    else
      @projects = @projects.select { |project| project.public? }
    end    
  end

  api :GET, "/myprojects.json", "List projects that belong to the current user"
  error 401, "The user you attempted authentication with cannot be authenticated"    
  def mine
    @projects = current_user.owned_projects
    render :index
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
    @sensor_types = SensorType.all      
  end

  # GET /projects/1/edit
  def edit
    @sensor_types = SensorType.all      
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
    @sensor_types = SensorType.all      
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
    @sensor_types = SensorType.all      
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
  
  api :POST, "/projects/make_public/:id.json", "Switch an entire project and its subsidiary components to public access mode."
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the project"  
  error 404, "A project could not be found with the requested id."  
  def make_public
    # if @project.is_accessible_by current_user
    @project.make_public
    respond_to do |format|
      format.html { redirect_to({action: 'show', id: @project.id}, notice: 'Project was successfully set public.') }
      format.json { head :no_content }
    end    
  end

  api :GET, "/projects/export/:id.json", "Retrieve a zip of indicated projects with all associated groups, takes, and data tracks, with attached files (public only)"
  param :id, String, "Primary key ID of the project in question", :required => true
  error 404, "A project could not be found with the requested id."
  def export
    t = Tempfile.new("temp-project-package-#{Time.now}")
    project_dir = sanitize_filename("project-#{@project.name}")          
    Zip::OutputStream.open(t.path) do |z|
      #TODO: add license and readme with some meta info
      license = Tempfile.new("license-#{Time.now}")
      preamble = "Thanks for downloading from the m+m movement database at http://db.mplusm.ca. Here are the licensing terms.\n"
      license.write(preamble+"#{@project.license}")
      # include track back info and author info
      z.put_next_entry("#{project_dir}/license.txt")
      z.print IO.read(open(license))
      @project.movement_groups.where(public: true).each do |group|
        group_dir = sanitize_filename("group-#{group.name}")
        group.takes.where(public: true).each do |take|
          take_dir = sanitize_filename("take-#{take.name}")
          take.data_tracks.where(public: true).each do |track|
            title = track.asset.file_file_name
            temp_filename = sanitize_filename("#{project_dir}/#{group_dir}/#{take_dir}track-#{track.name}/#{title}")
            z.put_next_entry(temp_filename)
            url = track.asset.file.path
            url_data = open(url)
            z.print IO.read(url_data)
          end
        end
      end  
    end

    send_file t.path, :type => 'application/zip',
      :disposition => 'attachment',
      :filename => sanitize_filename("moda-#{project_dir}.zip")
      t.close
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id], :include => [:owner, :movement_groups])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :tag_list, :public, :license, :sensor_type_ids => [], :mover_ids => [])
    end
    
    def sanitize_filename(filename)
      return filename.strip do |name|
       # NOTE: File.basename doesn't work right with Windows paths on Unix
       # get only the filename, not the whole path
       name.gsub!(/^.*(\\|\/)/, '')

       # Strip out the non-ascii character
       name.gsub!(/[^0-9A-Za-z.\-]/, '_')
      end
    end
      
end
