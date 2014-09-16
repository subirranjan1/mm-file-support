class MovementGroupsController < ApplicationController
  before_action :set_movement_group, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in, except: [:index, :show]
  before_filter ->(param=@movement_group) { ensure_owner param }, only: %w{destroy}
  before_filter ->(param=@movement_group) { ensure_authorized param }, only: %w{edit update}
  before_filter ->(param=@movement_group) { ensure_public_or_authorized param }, only: %w{show}
  # GET /movement_streams
  # GET /movement_streams.json
  def index
    @movement_groups = MovementGroup.select { |group| group.is_accessible_by?(current_user) }
  end

  # GET /movement_streams/1
  # GET /movement_streams/1.json
  def show
  end

  # GET /movement_streams/new
  def new
    @movement_group = MovementGroup.new
    @movement_group.project_id = params[:project_id]
    @movement_group.movers = @movement_group.project.movers
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
    @movement_group.owner = current_user
    respond_to do |format|
      if @movement_group.save
        # format.html { redirect_to @movement_group, notice: 'Movement group was successfully created.' }
        format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Movement take was successfully created.') }        
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
    @projects = Project.all
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
    @movement_group.destroy
    respond_to do |format|
      format.html { redirect_to({controller: 'projects', action: 'mine'}, notice: 'Movement take was successfully destroyed.') }        
      format.json { head :no_content }
    end
  end
  
  def tagged
    if params[:tag].present? 
      @movement_groups = MovementGroup.tagged_with(params[:tag])
    else 
      @movement_groups = MovementGroup.all
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement_group
      @movement_group = MovementGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_group_params
      params.require(:movement_group).permit(:name, :description, :project_id, :tag_list, :public, :user_id, :mover_ids => [])
    end
      
end
