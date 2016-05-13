class IrrigationsController < ApplicationController
  # GET /irrigations
  # GET /irrigations.json
  def index
    @irrigations = Irrigation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @irrigations }
    end
  end

  # GET /irrigations/1
  # GET /irrigations/1.json
  def show
    @irrigation = Irrigation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @irrigation }
    end
  end

  # GET /irrigations/new
  # GET /irrigations/new.json
  def new
    @irrigation = Irrigation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @irrigation }
    end
  end

  # GET /irrigations/1/edit
  def edit
    @irrigation = Irrigation.find(params[:id])
  end

  # POST /irrigations
  # POST /irrigations.json
  def create
    @irrigation = Irrigation.new(irrigation_params)

    respond_to do |format|
      if @irrigation.save
        format.html { redirect_to @irrigation, notice: 'Irrigation was successfully created.' }
        format.json { render json: @irrigation, status: :created, location: @irrigation }
      else
        format.html { render action: "new" }
        format.json { render json: @irrigation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /irrigations/1
  # PATCH/PUT /irrigations/1.json
  def update
    @irrigation = Irrigation.find(params[:id])

    respond_to do |format|
      if @irrigation.update_attributes(irrigation_params)
        format.html { redirect_to @irrigation, notice: 'Irrigation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @irrigation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /irrigations/1
  # DELETE /irrigations/1.json
  def destroy
    @irrigation = Irrigation.find(params[:id])
    @irrigation.destroy

    respond_to do |format|
      format.html { redirect_to irrigations_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def irrigation_params
      params.require(:irrigation).permit(:name, :status, :code)
    end
end
