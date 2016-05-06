class OperationsController < ApplicationController
################################  operations list   #################################
  # GET /operations/1
  # GET /1/operations.json
  def list
    @operations = Operation.where(:scenario_id => params[:id])
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(session[:field_id]).field_name
	@scenario_name = Scenario.find(session[:scenario_id]).name
		respond_to do |format|
		  format.html # list.html.erb
		  format.json { render json: @fields }
		end
  end
################################  INDEX  #################################
  # GET /operations
  # GET /operations.json
  def index
    @operations = Operation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operations }
    end
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operation }
    end
  end

################################  NEW  #################################
  # GET /operations/new
  # GET /operations/new.json
  def new
    @operation = Operation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @operation }
    end
  end

  # GET /operations/1/edit
  def edit
    @operation = Operation.find(params[:id])
  end

################################  CREATE  #################################
  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)
    @operation.scenario_id = session[:scenario_id]
    respond_to do |format|
      if @operation.save
		#operations should be created in soils too.
		add_soil_operation()
        format.html { redirect_to list_operation_path(session[:scenario_id]), notice: 'Operation was successfully created.' }
        format.json { render json: @operation, status: :created, location: @operation }
      else
        format.html { render action: "new" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    @operation = Operation.find(params[:id])

    respond_to do |format|
      if @operation.update_attributes(operation_params)
        format.html { redirect_to list_operation_path(session[:scenario_id]), notice: 'Operation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation = Operation.find(params[:id])
    @soil_operation = SoilOperation.find_by_operation_id(@operation.id)
    @operation.destroy
	@soil_operation.destroy

    respond_to do |format|
      format.html { redirect_to list_operation_path(session[:scenario_id]) }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def operation_params
      params.require(:operation).permit(:amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id)
    end

	def add_soil_operation()
		soils = 
		soil_operation = Operation.new(operation_params)
		soil_operation.scenario_id = session[:scenario_id]
		soil_operation.operation_id = @operation.id
		soil_operation.soil_id = Subarea.find_by_scenario_id(@operation.scenario_id).soil_id
		soil_operation.year = @operation.year
		soil_operation.month = @operation.month_id
		soil_operation.day = @operation.day
		soil_operation.tractor_id = 0
		soil_operation.crop_id = @operation.crop_id
		soil_operation.type_id = @operation.type_id
		soil_operation.opv1 = @operation.amount
		soil_operation.opv2 = @operation.depth
		soil_operation.opv3 = 0
		soil_operation.opv4 = 0
		soil_operation.opv5 = 0
		soil_operation.opv6 = 0
		soil_operation.opv7 = 0
	end

end
