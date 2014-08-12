class DataTracksController < ApplicationController
  before_action :set_data_track, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter :ensure_owner, only: [:destroy]
  before_filter :ensure_authorized, only: [:edit, :update]
  before_filter :ensure_public_or_authorized, only: [:show]
  # GET /movement_data
  # GET /movement_data.json
  def index
    @data_tracks = DataTrack.where(["public = ?", true])
  end

  # GET /movement_data/1
  # GET /movement_data/1.json
  def show
  end

  # GET /movement_data/new
  def new
    @data_track = DataTrack.new  
    @data_track.movement_group_id = params[:movement_group_id]  
    @data_track.movers = @data_track.movement_group.movers
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all  
  end

  # GET /movement_data/1/edit
  def edit
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all    
  end

  # POST /movement_data
  # POST /movement_data.json
  def create
    @data_track = DataTrack.new(data_track_params)
    @data_track.owner = current_user    
    unless params[:data_track]['asset_file'].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:data_track]['asset_file'])
      asset.save!
      @data_track.asset = asset
    end    
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all
    respond_to do |format|
      if @data_track.save
        # format.html { redirect_to @data_track, notice: 'Data track was successfully created.' }
        format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Data track was successfully created.') }                
        format.json { render action: 'show', status: :created, location: @data_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movement_data/1
  # PATCH/PUT /movement_data/1.json
  def update
    @movement_groups = MovementGroup.all
    @sensor_types = SensorType.all    
    unless params[:data_track]['asset_file'].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:data_track]['asset_file'])
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

  # DELETE /movement_data/1
  # DELETE /movement_data/1.json
  def destroy
    @data_track.destroy
    respond_to do |format|
      format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Data track was successfully created.') }        
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
      params.require(:data_track).permit(:name, :description, :format, :movement_group_id, :tag_list, :technician, :recorded_on, :sensor_type_id, :public, :user_id, :mover_ids => [])
    end
    
    def ensure_owner
      unless current_user and @data_track.owner == current_user
         flash[:notice] = "You do not have access rights to this data track."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end
    
    def ensure_authorized
      unless current_user and @data_track.is_accessible_by? current_user
         flash[:notice] = "You do not have access rights to this data track."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end
        
    def ensure_public_or_authorized
      unless @data_track.public or (current_user and @data_track.is_accessible_by? current_user)
         flash[:notice] = "This data track is not authorized for public access and you are not its owner."
         redirect_back_or_default
         return false
       else
         return true
       end      
    end
end
