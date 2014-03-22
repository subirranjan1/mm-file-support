class MovementGroupsController < ApplicationController
  before_action :set_movement_group, only: [:show, :edit, :update, :destroy]

  # GET /movement_streams
  # GET /movement_streams.json
  def index
    @movement_groups = MovementGroup.all
  end

  # GET /movement_streams/1
  # GET /movement_streams/1.json
  def show
  end

  # GET /movement_streams/new
  def new
    @movement_group = MovementGroup.new
    @projects = Project.all
  end

  # GET /movement_streams/1/edit
  def edit
    @projects = Project.all
  end

  # POST /movement_streams
  # POST /movement_streams.json
  def create
    @movement_group = MovementGroup.new(movement_group_params)

    respond_to do |format|
      if @movement_group.save
        format.html { redirect_to @movement_group, notice: 'Movement group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @movement_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @movement_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movement_streams/1
  # PATCH/PUT /movement_streams/1.json
  def update
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

  # DELETE /movement_streams/1
  # DELETE /movement_streams/1.json
  def destroy
    @movement_stream.destroy
    respond_to do |format|
      format.html { redirect_to movement_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement_stream
      @movement_group = MovementGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_group_params
      params.require(:movement_group).permit(:name, :description, :project_id)
    end
end
