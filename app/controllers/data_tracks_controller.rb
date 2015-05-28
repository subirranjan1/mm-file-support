class DataTracksController < ApplicationController
  before_action :set_data_track, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show, :index_data_tables]
  before_filter ->(param=@data_track) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@data_track) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@data_track) { ensure_public_or_authorized param }, only: %w{show}
  before_filter :process_attached_file, only: [:create, :update], if: Proc.new { |c| c.request.format.json? }

  def_param_group :data_track do
    param :data_track, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the Data Track", :required => true
      param :description, String, "Description of the Data Track", :required => true      
      param :movement_group_id, String, "Foreign key ID of the containing Movement Group", :required => true
      param :sensor_type_ids, Array, "Foreign key IDs of the associated sensor types"      
      param :technician, String, "Description of the Technician or associated technical support"
      param :public, ["0", "1"], "Should this data track be accessible to the public? (Default: false)"
      param :recorded_on, String, "Date the data track was recorded (yyyy-mm-dd)"
      param :mover_ids, Array, "Foreign key IDs of related Movers"    
      param :asset_file, Hash, "Remember to set your header to include 'Content-Type: multipart/form-data'", :required => true do
        param :original_filename, String, "filename", :required => true
        param :file, String, "Base64 encoded file", :required => true
      end     
    end
  end

  # GET /data_tracks
  # GET /data_tracks.json
  api :GET, "/data_tracks.json", "List data tracks that are accessible by the current user or are marked public"
  param :search, String, "A search parameter to refine terms"
  error 401, "The user you attempted authentication with cannot be authenticated"    
  def index
    @data_tracks = DataTrack.includes(:take, :owner, :sensor_types, :movers).search(params[:search]).order(:name)
    if current_user
      @data_tracks.select! { |data_track| data_track.public? or data_track.is_accessible_by?(@current_user)  }
    else
      @data_tracks.select! { |data_track| data_track.public? }
    end    
  end
  
  def index_data_tables
    # @data_tracks = DataTrack.includes(:take, :owner, :sensor_types, :movers)
    # if @current_user
    #   @data_tracks.select! { |data_track| data_track.public? or data_track.is_accessible_by?(@current_user)  }
    # else
    #   @data_tracks.select! { |data_track| data_track.public? }
    # end    
    # respond_to do |format|
    #   format.json { render json: { :data => @data_tracks.map(&:attributes) }}
    # end
    respond_to do |format|
      format.json { render json: DataTrackDatatable.new(view_context)}
    end    
  end

  # GET /data_tracks/1
  # GET /data_tracks/1.json
  api :GET, "/data_tracks/:id.json", "Show a Data Track that the user has access to or is marked public"
  param :id, String, "Primary key ID of the data_track in question", :required => true
  error 404, "A data track could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the data track and it is not public."  
  def show
  end

  # GET /data_tracks/new
  def new
    @data_track = DataTrack.new  
    @data_track.take_id = params[:take_id]  
    @data_track.movers = @data_track.take.movers
    @takes = Take.all
    @sensor_types = SensorType.all  
  end

  # GET /data_tracks/1/edit
  def edit
    @takes = Take.all
    @sensor_types = SensorType.all    
  end

  # POST /data_tracks
  # POST /data_tracks.json
  api :POST, "/data_tracks.json", "Create a data track"
  param_group :data_track
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"
  def create
    unless params[:data_track][:asset_file].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:data_track][:asset_file])
      asset.save!
    end    
    @data_track = DataTrack.new(data_track_params)
    @data_track.owner = current_user   
    @data_track.asset = asset   
    @sensor_types = SensorType.all
    @takes = Take.all    
    respond_to do |format|
      if @data_track.save
        # format.html { redirect_to @data_track, notice: 'Data track was successfully created.' }
        format.html { redirect_to(take_path(@data_track.take), notice: 'Data track was successfully created.') }                
        format.json { render action: 'show', status: :created, location: @data_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_tracks/1
  # PATCH/PUT /data_tracks/1.json
  api :PUT, "/data_tracks/:id.json", "Update a data track"
  param_group :data_track
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the data track"  
  error 404, "A data track could not be found with the requested id."      
  def update
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all        
    unless params[:data_track][:asset_file].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:data_track][:asset_file])
      asset.save!
      @data_track.asset = asset
    end
    respond_to do |format|
      if @data_track.update(data_track_params)
        format.html { redirect_to @data_track, notice: 'Data track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_tracks/1
  # DELETE /data_tracks/1.json
  api :DELETE, "/data_tracks/:id.json", "Destroy a data track that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated or is not the owner of the data track"  
  error 404, "A data track could not be found with the requested id."    
  def destroy
    @data_track.destroy
    respond_to do |format|
      format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Data track was successfully deleted.') }        
      format.json { head :no_content }
    end
  end
  
  # def provide
  #   
  # end
  # def import
  #   DataTrack.import(params[:file])
  #   redirect_to myprojects_path, notice: "Tracks imported."
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_track
      @data_track = DataTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_track_params
      params.require(:data_track).permit(:name, :description, :format, :take_id, :tag_list, :technician, :recorded_on, :public, :user_id, :sensor_type_ids => [], :mover_ids => [])
    end
    
    def process_attached_file
      if params[:data_track][:asset_file]
        # create a new tempfile named fileupload
        tempfile = Tempfile.new("fileupload")
        tempfile.binmode
        # get the file nad decode it with base64, then write it to the tempfile
        tempfile.write(Base64.decode64(params[:data_track][:asset_file][:file]))
        tempfile.close        
        # create a new uploaded file
        uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :type => params[:data_track][:asset_file][:content_type], :content_type => params[:data_track][:asset_file][:content_type], :filename => params[:data_track][:asset_file][:original_filename], :original_filename => params[:data_track][:asset_file][:original_filename]) 
        #replace the exisiting params with the new uploaded file
        params[:data_track][:asset_file] = uploaded_file
      
      end
    end
end
