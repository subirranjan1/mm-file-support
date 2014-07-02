class MoversController < ApplicationController
  before_action :set_mover, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  # GET /movers
  # GET /movers.json
  def index
    @movers = Mover.all
  end

  # GET /movers/1
  # GET /movers/1.json
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
      params.require(:mover).permit(:name, :dob, :gender, :expertise, :cma_like_training, :other_training, :data_track_id)
    end
end
