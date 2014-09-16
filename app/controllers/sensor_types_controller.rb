class SensorTypesController < ApplicationController
  before_action :set_sensor_type, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]

  def_param_group :sensor_type do
    param :sensor_type, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the sensor type", :required => true
      param :description, String, "Description of the sensor type"
    end
  end

  # GET /sensor_types
  # GET /sensor_types.json
  api :GET, "/sensor_types.json", "List all types of sensors"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def index
    @sensor_types = SensorType.all
  end

  # GET /sensor_types/1
  # GET /sensor_types/1.json
  api :GET, "/sensor_types/:id.json", "Show details on a type of sensor"
  param :id, String, "Primary key ID of the sensor type in question", :required => true
  error 404, "A sensor type could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def show
  end

  # GET /sensor_types/new
  def new
    @sensor_type = SensorType.new
  end

  # GET /sensor_types/1/edit
  def edit
  end

  # POST /sensor_types
  # POST /sensor_types.json
  api :POST, "/sensor_types.json", "Create a type of sensor"
  param_group :sensor_type
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"  
  def create
    @sensor_type = SensorType.new(sensor_type_params)

    respond_to do |format|
      if @sensor_type.save
        format.html { redirect_to @sensor_type, notice: 'Sensor type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sensor_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @sensor_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensor_types/1
  # PATCH/PUT /sensor_types/1.json
  api :PUT, "/sensor_types/:id.json", "Update a type of sensor"
  param_group :sensor_type
  error 401, "The user you attempted authentication with cannot be authenticated or is not set to have access to the project"  
  error 404, "A type of sensor could not be found with the requested id."  
  def update
    respond_to do |format|
      if @sensor_type.update(sensor_type_params)
        format.html { redirect_to @sensor_type, notice: 'Sensor type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sensor_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensor_types/1
  # DELETE /sensor_types/1.json
  api :DELETE, "/sensor_types/:id.json", "Destroy a sensor type"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 404, "A sensor type could not be found with the requested id."  
  def destroy
    @sensor_type.destroy
    respond_to do |format|
      format.html { redirect_to sensor_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor_type
      @sensor_type = SensorType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_type_params
      params.require(:sensor_type).permit(:name, :description)
    end
end
