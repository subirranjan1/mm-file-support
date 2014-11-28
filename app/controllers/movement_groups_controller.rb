require 'rubygems'
require 'zip'
class MovementGroupsController < ApplicationController
  before_action :set_movement_group, only: [:show, :edit, :update, :destroy, :export]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@movement_group) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@movement_group) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@movement_group) { ensure_public_or_authorized param }, only: %w{show}
  # require 'rubyzip'
  # require 'zip'
  # require "open-uri"
  
  def_param_group :movement_group do
    param :movement_group, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the movement group (take)", :required => true
      param :project_id, String, "Foreign key ID of the containing Project", :required => true      
      param :description, String, "Description of the movement group (take)"
      param :public, ["0", "1"], "Should this data track be accessible to the public? (Default: false)"  
      param :mover_ids, Array, "Foreign key IDs of related Movers"          
    end
  end
  # GET /movement_groups
  # GET /movement_groups.json
  api :GET, "/movement_groups.json", "List movement groups that are accessible by the current user or are marked public"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def index
    if @current_user
      @movement_groups = MovementGroup.select { |group| group.is_accessible_by?(current_user) }
    else
      @movement_groups = MovementGroup.select { |group| group.public? }
    end    
  end

  # GET /movement_groups/1
  # GET /movement_groups/1.json
  api :GET, "/movement_groups/:id.json", "Show a movement group that the user has access to or is marked public"
  param :id, String, "Primary key ID of the movement group in question", :required => true
  error 404, "A movement group could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the movement group and it is not public."  
  def show
  end

  # GET /movement_groups/new
  def new
    @movement_group = MovementGroup.new
    @movement_group.project_id = params[:project_id]
    @movement_group.movers = @movement_group.project.movers
    @projects = Project.all
  end

  # GET /movement_groups/1/edit
  def edit
    @projects = Project.all
  end

  # POST /movement_groups
  # POST /movement_groups.json
  api :POST, "/movement_groups.json", "Create a movement group"
  param_group :movement_group
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"  
  def create
    @movement_group = MovementGroup.new(movement_group_params)
    @movement_group.owner = current_user
    respond_to do |format|
      if @movement_group.save
        # format.html { redirect_to @movement_group, notice: 'Movement group was successfully created.' }
        format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Movement take was successfully created.') }        
        format.json { render action: 'show', status: :created, location: @movement_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @movement_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movement_groups/1
  # PATCH/PUT /movement_groups/1.json
  api :PUT, "/movement_groups/:id.json", "Update a movement group"
  param_group :movement_group
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the movement group"  
  error 404, "A movement group could not be found with the requested id."  
  def update
    @projects = Project.all
    respond_to do |format|
      if @movement_group.update(movement_group_params)
        format.html { redirect_to @movement_group, notice: 'Movement group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @movement_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movement_groups/1
  # DELETE /movement_groups/1.json
  api :DELETE, "/movement_groups/:id.json", "Destroy a movement group that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated or is not the owner of the movement group"  
  error 404, "A movement group could not be found with the requested id."  
  def destroy
    @movement_group.destroy
    respond_to do |format|
      format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Movement take was successfully destroyed.') }        
      format.json { head :no_content }
    end
  end
    
  def export
    t = Tempfile.new("temp-group-package-#{Time.now}")
    Zip::OutputStream.open(t.path) do |z|
      #TODO: add license and readme with some meta info
      license = Tempfile.new("license-#{Time.now}")
      preamble = "Thanks for downloading from the m+m movement database at http://db.mplusm.ca. Here are the licensing terms.\n"
      license.write(preamble+@movement_group.project.license)
      z.put_next_entry("/take-#{@movement_group.name}/license.txt")
      z.print IO.read(open(license))
      @movement_group.data_tracks.where(public: true).each do |track|
        title = track.asset.file_file_name
        z.put_next_entry("/take-#{@movement_group.name}/#{title}")
        url = track.asset.file.path
        url_data = open(url)
        z.print IO.read(url_data)
      end
    end

    send_file t.path, :type => 'application/zip',
      :disposition => 'attachment',
      :filename => "mnm-db-movement-group-#{@movement_group.name}.zip"
      t.close
  end
  
  def tagged
    if params[:tag].present? 
      @movement_groups = MovementGroup.tagged_with(params[:tag])
    else 
      @movement_groups = MovementGroup.all
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement_group
      @movement_group = MovementGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_group_params
      params.require(:movement_group).permit(:name, :description, :project_id, :tag_list, :public, :user_id, :mover_ids => [])
    end
      
end
