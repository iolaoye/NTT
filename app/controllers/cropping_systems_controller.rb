class CroppingSystemsController < ApplicationController
  # GET /cropping_systems
  # GET /cropping_systems.json
  def index
    @cropping_systems = CroppingSystem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cropping_systems }
    end
  end

  # GET /cropping_systems/1
  # GET /cropping_systems/1.json
  def show
    @cropping_system = CroppingSystem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cropping_system }
    end
  end

  # GET /cropping_systems/new
  # GET /cropping_systems/new.json
  def new
    @cropping_system = CroppingSystem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cropping_system }
    end
  end

  # GET /cropping_systems/1/edit
  def edit
    @cropping_system = CroppingSystem.find(params[:id])
  end

  # POST /cropping_systems
  # POST /cropping_systems.json
  def create
    @cropping_system = CroppingSystem.new(cropping_system_params)

    respond_to do |format|
      if @cropping_system.save
        format.html { redirect_to @cropping_system, notice: 'Cropping system was successfully created.' }
        format.json { render json: @cropping_system, status: :created, location: @cropping_system }
      else
        format.html { render action: "new" }
        format.json { render json: @cropping_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cropping_systems/1
  # PATCH/PUT /cropping_systems/1.json
  def update
    @cropping_system = CroppingSystem.find(params[:id])

    respond_to do |format|
      if @cropping_system.update_attributes(cropping_system_params)
        format.html { redirect_to @cropping_system, notice: 'Cropping system was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cropping_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cropping_systems/1
  # DELETE /cropping_systems/1.json
  def destroy
    @cropping_system = CroppingSystem.find(params[:id])
    @cropping_system.destroy

    respond_to do |format|
      format.html { redirect_to cropping_systems_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def cropping_system_params
      params.require(:cropping_system).permit(:crop, :grazing, :name, :state_id, :status, :tillage, :var12)
    end
end
