class SupplementParametersController < ApplicationController
  before_filter :set_params

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Projects', :root_path

  def set_params
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  end

  # GET /supplement_parameters
  # GET /supplement_parameters.json
  def index
    @supplement_parameters = SupplementParameter.where(:scenario_id => params[:scenario_id])
	add_breadcrumb @project.name, project_path(@project)
	add_breadcrumb @field.field_name, project_fields_path(@project)
	add_breadcrumb @scenario.name, project_field_scenarios_path(@project, @field)
	add_breadcrumb 'Aplcat'
	add_breadcrumb 'Supplement Parameters'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supplement_parameters }
    end
  end

  # GET /supplement_parameters/1
  # GET /supplement_parameters/1.json
  def show
    @supplement_parameter = SupplementParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @supplement_parameter }
    end
  end

  # GET /supplement_parameters/new
  # GET /supplement_parameters/new.json
  def new
    @supplement_parameter = SupplementParameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supplement_parameter }
    end
  end

  # GET /supplement_parameters/1/edit
  def edit
    @supplement_parameter = SupplementParameter.find(params[:id])
  end

  # POST /supplement_parameters
  # POST /supplement_parameters.json
  def create
    @supplement_parameter = SupplementParameter.new(supplement_parameter_params)
	@supplement_parameter.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @supplement_parameter.save
        format.html { redirect_to project_field_scenario_supplement_parameters_path(@project, @field, @scenario), notice: 'supplement parameter was successfully created.' }
        format.json { render json: @supplement_parameter, status: :created, location: @supplement_parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @supplement_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplement_parameters/1
  # PATCH/PUT /supplement_parameters/1.json
  def update
    @supplement_parameter = SupplementParameter.find(params[:id])

    respond_to do |format|
      if @supplement_parameter.update_attributes(supplement_parameter_params)
        format.html { redirect_to project_field_scenario_supplement_parameters_path(@project, @field, @scenario), notice: 'Supplement parameter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @supplement_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplement_parameters/1
  # DELETE /supplement_parameters/1.json
  def destroy
    @supplement_parameter = SupplementParameter.find(params[:id])
    @supplement_parameter.destroy

    respond_to do |format|
      format.html { redirect_to project_field_scenario_supplement_parameters_path(@project, @field, @scenario), notice: 'Supplement parameter was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def supplement_parameter_params
      params.require(:supplement_parameter).permit(:code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :green_water_footprint, :scenario_id)
    end
end
