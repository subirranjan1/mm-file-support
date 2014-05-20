class MovementAnnotationsController < ApplicationController
  before_action :set_movement_annotation, only: [:show, :edit, :update, :destroy]

  # GET /movement_annotations
  # GET /movement_annotations.json
  def index
    @movement_annotations = MovementAnnotation.all
  end

  # GET /movement_annotations/1
  # GET /movement_annotations/1.json
  def show
  end

  # GET /movement_annotations/new
  def new
    @movement_annotation = MovementAnnotation.new
    @data_tracks = DataTrack.all
  end

  # GET /movement_annotations/1/edit
  def edit
    @data_tracks = DataTrack.all
  end

  # POST /movement_annotations
  # POST /movement_annotations.json
  def create
    @movement_annotation = MovementAnnotation.new(movement_annotation_params)
    @data_tracks = DataTrack.all
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
  def update
    @data_tracks = DataTrack.all    
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
  def destroy
    @movement_annotation.destroy
    respond_to do |format|
      format.html { redirect_to movement_annotations_url }
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
      params.require(:movement_annotation).permit(:name, :description, :format, :data_track_id, :public, :tag_list, :user_id)
    end
end
