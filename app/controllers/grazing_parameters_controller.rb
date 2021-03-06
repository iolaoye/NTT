class GrazingParametersController < ApplicationController
  before_action :set_params

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
    @forage = 0
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grazing_parameter }
    end
  end

  # GET /grazing_parameters/1/edit
  def edit
    @grazing_parameter = GrazingParameter.find(params[:id])
    @forage = AplcatParameter.find_by_scenario_id(@scenario.id).forage
  end

  # POST /grazing_parameters
  # POST /grazing_parameters.json
  def create
    @grazing_parameter = GrazingParameter.new(grazing_parameter_params)
    @grazing_parameter.scenario_id = params[:scenario_id]
    aplcat_parameter = AplcatParameter.find_by_scenario_id(@scenario.id)
    aplcat_parameter.forage = params[:forage]
    aplcat_parameter.save
    respond_to do |format|
      if @grazing_parameter.save
        format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: t('aplcat.animal_feed_parameters') + ' was successfully created.' }
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
    aplcat_parameter = AplcatParameter.find_by_scenario_id(@scenario.id)
    aplcat_parameter.forage = params[:forage]
    aplcat_parameter.save
    respond_to do |format|
      if @grazing_parameter.update_attributes(grazing_parameter_params)
        format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: t('aplcat.animal_feed_parameters') +  ' was successfully updated.' }
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
      format.html { redirect_to project_field_scenario_grazing_parameters_path(@project, @field, @scenario), notice: t('aplcat.animal_feed_parameters') + ' was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def grazing_parameter_params
      params.require(:grazing_parameter).permit(:code, :code_for, :dmi_bulls, :dmi_calves, :dmi_code, :dmi_cows, :dmi_heifers, :ending_julian_day, :green_water_footprint,
        :starting_julian_day, :dmi_rheifers, :for_dmi_cows, :for_dmi_bulls, :for_dmi_heifers, :for_dmi_calves, :for_dmi_rheifers, :green_water_footprint_supplement,
        :for_button, :supplement_button)
    end
end
