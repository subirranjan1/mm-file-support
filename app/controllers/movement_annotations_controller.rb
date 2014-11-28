class MovementAnnotationsController < ApplicationController
  before_action :set_movement_annotation, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@movement_annotation) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@movement_annotation) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@movement_annotation) { ensure_public_or_authorized param }, only: %w{show}
  before_filter :process_attached_file, only: [:create, :update], if: Proc.new { |c| c.request.format.json? }
    
  def_param_group :movement_annotation do
    param :movement_annotation, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the annotation", :required => true
      param :attached_id, String, "Foreign key ID of the related DataTrack | MovementGroup | Project", :required => true      
      param :attached_type, String, "Type of the related DataTrack | MovementGroup | Project"
      param :description, String, "Description of the :name, :description, :format, :movement_annotation_id, :public, :tag_list, :user_id"
      param :public, ["0", "1"], "Should this annotation be accessible to the public? (Default: false)" 
      param :asset_file, Hash, "Remember to set your header to include 'Content-Type: multipart/form-data'", :required => true do
        param :original_filename, String, "filename", :required => true
        param :file, String, "Base64 encoded file", :required => true
      end       
    end
  end  
  
  # GET /movement_annotations
  # GET /movement_annotations.json
  api :GET, "/movement_annotations.json", "List movement annotations that are accessible by the current user or are marked public"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def index
    @movement_annotations = MovementAnnotation.all
  end

  # GET /movement_annotations/1
  # GET /movement_annotations/1.json
  api :GET, "/movement_annotations/:id.json", "Show a movement annotation that the user has access to or is marked public"
  param :id, String, "Primary key ID of the movement annotation in question", :required => true
  error 404, "A movement annotation could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the movement annotation and it is not public."  
  def show
  end

  # GET /movement_annotations/new
  def new
    @movement_annotation = MovementAnnotation.new
    @data_tracks = DataTrack.all
    @movement_annotation.attached_type = params[:annotated]
    @movement_annotation.attached_id = params[:attached_id]
  end

  # GET /movement_annotations/1/edit
  
  def edit
    @data_tracks = DataTrack.all
  end

  # POST /movement_annotations
  # POST /movement_annotations.json
  api :POST, "/movement_annotations.json", "Create a movement annotation"
  param_group :movement_annotation
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"  
  def create
    unless params[:movement_annotation][:asset_file].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:movement_annotation][:asset_file])
      asset.save!
    end        
    @movement_annotation = MovementAnnotation.new(movement_annotation_params)
    @movement_annotation.asset = asset    
    @movement_annotation.owner = current_user
    respond_to do |format|
      if @movement_annotation.save
        format.html { redirect_to @movement_annotation, notice: 'Movement annotation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @movement_annotation }
      else
        format.html { render action: 'new' }
        format.json { render json: @movement_annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movement_annotations/1
  # PATCH/PUT /movement_annotations/1.json
  api :PUT, "/movement_annotations/:id.json", "Update a movement annotations"
  param_group :movement_annotation
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the movement annotation"  
  error 404, "A movement annotation could not be found with the requested id."    
  def update
    @data_tracks = DataTrack.all  
    unless params[:movement_annotation][:asset_file].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:movement_annotation][:asset_file])
      asset.save!
      @movement_annotation.asset = asset
    end      
    respond_to do |format|
      if @movement_annotation.update(movement_annotation_params)
        format.html { redirect_to @movement_annotation, notice: 'Movement annotation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @movement_annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movement_annotations/1
  # DELETE /movement_annotations/1.json
  api :DELETE, "/movement_annotations/:id.json", "Destroy a movement annotation that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated or is not the owner of the movement annotation"  
  error 404, "A movement annotation  could not be found with the requested id."  
  def destroy
    @movement_annotation.destroy
    respond_to do |format|
      format.html { redirect_back_or_default }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement_annotation
      @movement_annotation = MovementAnnotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_annotation_params
      params.require(:movement_annotation).permit(:name, :description, :format, :attached_type, :attached_id, :public, :tag_list, :user_id)
    end
    
    def process_attached_file
      if params[:movement_annotation][:asset_file]
        # create a new tempfile named fileupload
        tempfile = Tempfile.new("fileupload")
        tempfile.binmode
        # get the file nad decode it with base64, then write it to the tempfile
        tempfile.write(Base64.decode64(params[:movement_annotation][:asset_file][:file]))
        # create a new uploaded file
        uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => params[:movement_annotation][:asset_file][:original_filename], :original_filename => params[:movement_annotation][:asset_file][:original_filename]) 
        #replace the exisiting params with the new uploaded file
        params[:movement_annotation][:asset_file] = uploaded_file
      end
    end    
end
