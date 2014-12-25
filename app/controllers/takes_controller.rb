require 'zip'
class TakesController < ApplicationController
  before_action :set_take, only: [:show, :edit, :update, :destroy, :export]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@take) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@take) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@take) { ensure_public_or_authorized param }, only: %w{show}
  
  def_param_group :take do
    param :take, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the take", :required => true
      param :project_id, String, "Foreign key ID of the containing MovementGroup", :required => true      
      param :description, String, "Description of the take"
      param :mover_ids, Array, "Foreign key IDs of related Movers"                
      param :sensor_type_ids, Array, "Foreign key IDs of the associated sensor types"            
      param :public, ["0", "1"], "Should this data track be accessible to the public? (Default: false)"  
    end
  end
    
  # GET /takes
  # GET /takes.json
  api :GET, "/takes.json", "List takes that are accessible by the current user or are marked public"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def index
    if current_user
      @takes = Take.select { |take| take.is_accessible_by?(@current_user) or take.public? }
    else
      @takes =Take.select { |take| take.public? }
    end    
  end

  # GET /takes/1
  # GET /takes/1.json
  api :GET, "/takes/:id.json", "Show a take that the user has access to or is marked public"
  param :id, String, "Primary key ID of the take in question", :required => true
  error 404, "A take could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the take and it is not public."  
  def show
  end

  # GET /takes/new
  def new
    @take = Take.new
    @take.movement_group_id = params[:movement_group_id]
    @take.movers = @take.movement_group.movers
    @movement_groups = MovementGroup.all   
    @sensor_types = SensorType.all       
  end

  # GET /takes/1/edit
  def edit
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all      
  end

  # POST /takes
  # POST /takes.json
  api :POST, "/takes.json", "Create a take"
  param_group :take
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the creation attempt unprocessable"  
  def create
    @take = Take.new(take_params)
    @take.owner = current_user
    @sensor_types = SensorType.all      
    respond_to do |format|
      if @take.save
        format.html { redirect_to @take, notice: 'Take was successfully created.' }
        format.json { render action: 'show', status: :created, location: @take }
      else
        format.html { render action: 'new' }
        format.json { render json: @take.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /takes/1
  # PATCH/PUT /takes/1.json
  api :PUT, "/takes/:id.json", "Update a take"
  param_group :take
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the take."  
  error 404, "A take could not be found with the requested id."  
  def update
    @sensor_types = SensorType.all      
    respond_to do |format|
      if @take.update(take_params)
        format.html { redirect_to @take, notice: 'Take was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @take.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # api :GET, "/takes/export/:id", "Retrieve a zip of all associated files"
  def export
    t = Tempfile.new("temp-take-package-#{Time.now}")
    Zip::OutputStream.open(t.path) do |z|
      #TODO: add license and readme with some meta info
      license = Tempfile.new("license-#{Time.now}")
      preamble = "Thanks for downloading from the m+m movement database at http://db.mplusm.ca. Here are the licensing terms.\n"
      license.write(preamble+@take.project.license)
      take_dir = sanitize_filename("take-#{take.name}")
      z.put_next_entry("#{take_dir}/license.txt")      
      z.print IO.read(open(license))
      take.data_tracks.where(public: true).each do |track|
        title = track.asset.file_file_name
        temp_filename = sanitize_filename("#{take_dir}/track-#{track.name}/#{title}")
        z.put_next_entry(temp_filename)
        url = track.asset.file.path
        url_data = open(url)
        z.print IO.read(url_data)
      end
    end
  end
  # DELETE /takes/1
  # DELETE /takes/1.json
  api :DELETE, "/takes/:id.json", "Destroy a take that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated or is not the owner of the take"  
  error 404, "A take could not be found with the requested id."  
  def destroy
    @take.destroy
    respond_to do |format|
      format.html { redirect_to takes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_take
      @take = Take.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def take_params
      params.require(:take).permit(:name, :description, :movement_group_id, :public, :user_id, :sensor_type_ids => [], :mover_ids => [])
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
