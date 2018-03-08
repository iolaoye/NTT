class GrazingParametersController < ApplicationController
  before_filter :set_params




  def set_params
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  end

  # GET /grazing_parameters
  # GET /grazing_parameters.json
  def index
    @grazing_parameters = GrazingParameter.where(:scenario_id => params[:scenario_id])

	add_breadcrumb 'Aplcat'
	add_breadcrumb 'Animal Feed Parameters'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grazing_parameters }
    end
  end

  # GET /grazing_parameters/1
  # GET /grazing_parameters/1.json
  def show
    @grazing_parameter = GrazingParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grazing_parameter }
    end
  end

  # GET /grazing_parameters/new
  # GET /grazing_parameters/new.json
  def new
    @grazing_parameter = GrazingParameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grazing_parameter }
    end
  end

  # GET /grazing_parameters/1/edit
  def edit
    @grazing_parameter = GrazingParameter.find(params[:id])
  end

  # POST /grazing_parameters
  # POST /grazing_parameters.json
  def create
    @grazing_parameter = GrazingParameter.new(grazing_parameter_params)
	@grazing_parameter.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @grazing_parameter.save
        format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: 'Grazing parameter was successfully created.' }
        format.json { render json: @grazing_parameter, status: :created, location: @grazing_parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @grazing_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grazing_parameters/1
  # PATCH/PUT /grazing_parameters/1.json
  def update
    @grazing_parameter = GrazingParameter.find(params[:id])

    respond_to do |format|
      if @grazing_parameter.update_attributes(grazing_parameter_params)
        format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: 'Grazing parameter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @grazing_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grazing_parameters/1
  # DELETE /grazing_parameters/1.json
  def destroy
    @grazing_parameter = GrazingParameter.find(params[:id])
    @grazing_parameter.destroy

    respond_to do |format|
      format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: 'Grazing parameter was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def grazing_parameter_params
      params.require(:grazing_parameter).permit(:code, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint, :starting_julian_day, :forage, :dmi_rheifers)
    end
end
