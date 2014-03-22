class DataTracksController < ApplicationController
  before_action :set_data_track, only: [:show, :edit, :update, :destroy]

  # GET /movement_data
  # GET /movement_data.json
  def index
    @data_tracks = DataTrack.all
  end

  # GET /movement_data/1
  # GET /movement_data/1.json
  def show
  end

  # GET /movement_data/new
  def new
    @data_track = DataTrack.new
    @movement_groups = MovementGroup.all
  end

  # GET /movement_data/1/edit
  def edit
    @movement_groups = MovementGroup.all
  end

  # POST /movement_data
  # POST /movement_data.json
  def create
    @data_track = DataTrack.new(data_track_params)
    unless params[:data_track]['asset_file'].nil? 
      #this params hash is actually an object of type Rack::Multipart::UploadedFile and this way it gets converted with name etc intact
      asset = Asset.new(:file => params[:data_track]['asset_file'])
      asset.save!
      @data_track.asset = asset
    end    
    @movement_groups = MovementGroup.all

    respond_to do |format|
      if @data_track.save
        format.html { redirect_to @data_track, notice: 'Data track was successfully created.' }
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
      format.html { redirect_to data_track_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_track
      @data_track = DataTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_track_params
      params.require(:data_track).permit(:name, :description, :format, :movement_group_id)
    end
end
