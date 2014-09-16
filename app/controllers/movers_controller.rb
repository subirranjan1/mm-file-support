class MoversController < ApplicationController
  before_action :set_mover, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]

  def_param_group :mover do
    param :mover, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the mover", :required => true
      param :dob, Date, "YYYY-MM-DD"      
      param :gender, String, "Gender identity information"
      param :expertise, String, "Details of mover expertise"          
      param :cma_like_training, ["0", "1"], "Does the mover have CMA or CMA-like training? T/F"
      param :other_training, String, "Any other relevant training"
    end
  end

  # GET /movers
  # GET /movers.json
  api :GET, "/movers.json", "List all movers"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def index
    @movers = Mover.all
  end

  # GET /movers/1
  # GET /movers/1.json
  api :GET, "/movers/:id.json", "Show details on a mover"
  param :id, String, "Primary key ID of the mover in question", :required => true
  error 404, "A mover could not be found with the requested id."  
  error 401, "The user you attempted authentication with cannot be authenticated"  
  def show
  end

  # GET /movers/new
  def new
    @mover = Mover.new
  end

  # GET /movers/1/edit
  def edit
  end

  # POST /movers
  # POST /movers.json
  api :POST, "/movers.json", "Create a mover"
  param_group :mover
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 422, "The parameters you passed were invalid and rendered the create attempt unprocessable"  
  def create
    @mover = Mover.new(mover_params)

    respond_to do |format|
      if @mover.save
        format.html { redirect_to @mover, notice: 'Mover was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mover }
      else
        format.html { render action: 'new' }
        format.json { render json: @mover.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movers/1
  # PATCH/PUT /movers/1.json
  api :PUT, "/movers/:id.json", "Update a mover"
  param_group :mover
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 404, "A mover could not be found with the requested id."  
  def update
    respond_to do |format|
      if @mover.update(mover_params)
        format.html { redirect_to @mover, notice: 'Mover was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mover.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movers/1
  # DELETE /movers/1.json
  api :DELETE, "/movers/:id.json", "Destroy a mover record that you are the owner of"
  error 401, "The user you attempted authentication with cannot be authenticated"  
  error 404, "A mover could not be found with the requested id."
  def destroy
    @mover.destroy
    respond_to do |format|
      format.html { redirect_to movers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mover
      @mover = Mover.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mover_params
      params.require(:mover).permit(:name, :dob, :gender, :expertise, :cma_like_training, :other_training)
    end
end
