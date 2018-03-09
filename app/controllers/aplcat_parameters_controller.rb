class AplcatParametersController < ApplicationController
  # GET /aplcat_parameters
  # GET /aplcat_parameters.json

  def index
    @aplcat_parameters = AplcatParameter.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @aplcat_parameters }
    end
  end

  # GET /aplcat_parameters/1
  # GET /aplcat_parameters/1.json
  def show
    @aplcat_parameter = AplcatParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @aplcat_parameter }
    end
  end

  # GET /aplcat_parameters/new
  # GET /aplcat_parameters/new.json
  def new
    @aplcat_parameter = AplcatParameter.new
	@aplcat_parameter.scenario_id = params[:scenario_id]
	@aplcat_parameter.save
    #respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @aplcat_parameter }
    #end
  end

  # GET /aplcat_parameters/1/edit
  def edit
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
	@aplcat = Hash.new
	@aplcat[t('aplcat.animal_parameters')] = 1
	@aplcat[t('aplcat.animal_growth_parameters')] = 2
	@aplcat[t('aplcat.animal_manure_parameters')] = 3
	@aplcat[t('aplcat.environmental_parameters')] = 4
	@aplcat[t('aplcat.greenhouse_parameters')] = 5
	@aplcat[t('aplcat.water_use_pumping_parameters')] = 6
	@aplcat[t('aplcat.other_parameters')] = 7
  @aplcat[t('aplcat.simulation_parameters')] = 8
  @aplcat[t('aplcat.simulation_methods')] = 9

	add_breadcrumb 'Aplcat'
  	if params[:id] == nil then
		@type = 1
	else
		@type = params[:id].to_i
	end

	case @type
	when 2
      add_breadcrumb 'Animal Growth and Nutrition Parameters'
	when 3
	  add_breadcrumb 'Animal Manure Parameters'
	when 4
	  add_breadcrumb 'Environmental Parameters'
	when 5
	  add_breadcrumb 'Greenhouse Parameters'
	when 6
	  add_breadcrumb 'Water use and Pumping Parameters'
	when 7
	  add_breadcrumb 'Other Parameters'
  when 8
    add_breadcrumb 'Simulation Parameters'
  when 9
    add_breadcrumb 'Simulation Methods'
	else
	  add_breadcrumb 'Animal Parameters'
	end

    @aplcat_parameter = AplcatParameter.find_by_scenario_id(params[:scenario_id])
	if @aplcat_parameter == nil then
		new()
	end
  end

  # POST /aplcat_parameters
  # POST /aplcat_parameters.json
  def create
    @aplcat_parameter = AplcatParameter.new(aplcat_parameter_params)
	@aplcat_parameter.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @aplcat_parameter.save
        format.html { redirect_to edit_aplcat_parameter_path(params[:scenario_id]), notice: 'Aplcat parameter was successfully created.' }
        format.json { render json: @aplcat_parameter, status: :created, location: @aplcat_parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @aplcat_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aplcat_parameters/1
  # PATCH/PUT /aplcat_parameters/1.json
  def update
    saved = false
    #@type = params[:type]
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
	@aplcat_parameter = AplcatParameter.find_by_id(params[:id])
	if @aplcat_parameter == nil then
		@aplcat_parameter = AplcatParameter.new(aplcat_parameter_params)
		@aplcat_parameter.scenario_id = params[:scenario_id]
		if @aplcat_parameter.save then saved = true end
	else
		if @aplcat_parameter.update_attributes(aplcat_parameter_params) then saved = true end
	end

    if saved
        redirect_to edit_project_field_scenario_aplcat_parameter_path(@project, @field, @scenario, @aplcat_parameter), notice: 'Aplcat parameter was successfully updated.', :method => 'GET'
    else
        format.html { render action: "edit" }
	end
  end

  # DELETE /aplcat_parameters/1
  # DELETE /aplcat_parameters/1.json
  def destroy
    @aplcat_parameter = AplcatParameter.find(params[:id])
    @aplcat_parameter.destroy

    respond_to do |format|
      format.html { redirect_to aplcat_parameters_url }
      format.json { head :no_content }
    end
  end

  def download
	  download_aplcat_files()
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def aplcat_parameter_params
      params.require(:aplcat_parameter).permit(:abwc, :abwh, :abwmb, :adwgbc, :noc, :nomb, :norh, :prh, :adwgbh, :mrga, :jdcc, :gpc,
				 :tpwg, :csefa , :srop, :bwoc, :jdbs, :dmd, :dmi, :napanr, :napaip, :mpsm, :splm, :pmme, :rhaeba, :toaboba,
				 :vsim, :foue, :ash, :mmppfm, :cfmms, :fnemimms, :effn2ofmms, :dwawfga, :dwawflc, :dwawfmb, :pgu, :ada, :ape,
				 :platc, :pctbb, :ptdife, :tnggbc, :prb, :mrgauh, :plac, :pcbb, :fmbmm, :domd, :vsim, :faueea, :acim, :mmppm, :cffm, :fnemm, :effd, :ptbd, :pocib, :bneap,
         :cneap, :hneap, :pobw, :posw, :posb, :poad, :poada, :cibo, :abwrh, :nocrh, :abc, :mm_type, :nit, :fqd, :uovfi, :srwc)
    end
end
