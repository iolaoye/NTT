class SoilOperationsController < ApplicationController
  # GET /soil_operations
  # GET /soil_operations.json
  def index
    @soil_operations = SoilOperation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soil_operations }
    end
  end

  # GET /soil_operations/1
  # GET /soil_operations/1.json
  def show
    @soil_operation = SoilOperation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @soil_operation }
    end
  end

  # GET /soil_operations/new
  # GET /soil_operations/new.json
  def new
    @soil_operation = SoilOperation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @soil_operation }
    end
  end

  # GET /soil_operations/1/edit
  def edit
    @soil_operation = SoilOperation.find(params[:id])
  end

  # POST /soil_operations
  # POST /soil_operations.json
  def create
    @soil_operation = SoilOperation.new(soil_operation_params)

    respond_to do |format|
      if @soil_operation.save
        format.html { redirect_to @soil_operation, notice: 'Soil operation was successfully created.' }
        format.json { render json: @soil_operation, status: :created, location: @soil_operation }
      else
        format.html { render action: "new" }
        format.json { render json: @soil_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soil_operations/1
  # PATCH/PUT /soil_operations/1.json
  def update
    @soil_operation = SoilOperation.find(params[:id])

    respond_to do |format|
      if @soil_operation.update_attributes(soil_operation_params)
        format.html { redirect_to @soil_operation, notice: 'Soil operation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @soil_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soil_operations/1
  # DELETE /soil_operations/1.json
  def destroy
    @soil_operation = SoilOperation.find(params[:id])
    @soil_operation.destroy

    respond_to do |format|
      format.html { redirect_to soil_operations_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def soil_operation_params
      params.require(:soil_operation).permit(:apex_crop, :opv1, :opv2, :opv3, :opv4, :opv5, :opv6, :opv7, :activity_id, :id, :year, :month, :day, :operation_id, :type_id, :scenario_id, soil_id, :apex_operation, :tractor_id)
    end
end
