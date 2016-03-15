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

################################  NEW  #################################
  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)
    @operation.scenario_id = session[:scenario_id]
    respond_to do |format|
      if @operation.save
        format.html { redirect_to @operation, notice: 'Operation was successfully created.' }
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
        format.html { redirect_to @operation, notice: 'Operation was successfully updated.' }
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
    @operation.destroy

    respond_to do |format|
      format.html { redirect_to operations_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def operation_params
      params.require(:operation).permit(:amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :operation_id, :org_n, :org_p, :po4_p, :type_id, :year)
    end
end
