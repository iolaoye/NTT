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
  @aplcat[t('aplcat.scenario_file')] = 10
  @aplcat[t('aplcat.divv_11')] = 11
  @aplcat[t('aplcat.forage_quantity_input')] = 12
  @aplcat[t('aplcat.animal_transport_input')] = 13
  @aplcat[t('aplcat.co2_balance_input')] = 14
  @aplcat[t('aplcat.secondary_emissions_input')] = 15

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
  when 10
    add_breadcrumb 'Scenario File'
  when 11
    add_breadcrumb 'Water Estimation Parameters'
  when 12
    add_breadcrumb 'Forage Quantity Input'
  when 13
    add_breadcrumb 'Animal Transport Input'
  when 14
    add_breadcrumb 'CO2 Balance Input'
  when 15
    add_breadcrumb 'Secondary Emissions Input'
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
				 :platc, :pctbb, :ptdife, :tnggbc, :prb, :abwrh, :nocrh, :abc, :forage_id, :jincrease, :stabilization, :decline, :opt4,
         :crude_low, :crude_high, :tdn_low, :tdn_high, :ndf_low, :ndf_high, :adf_low, :adf_high, :feed_low, :feed_high, :tripn, :freqtrip, :filedetails,
         :cattlepro, :purpose, :codepurpose, :mdogfc, :mxdogfc, :cwsoj, :cweoj, :ewc, :nodew, :byosm, :eyosm, :mrgauh, :plac, :pcbb, :fmbmm, :domd,
         :faueea, :acim, :mmppm, :cffm, :fnemm, :effd, :ptbd, :pocib, :bneap, :cneap, :hneap, :pobw, :posw, :posb, :poad, :poada, :cibo, :drinkg,
         :drinkl, :drinkm, :avgtm, :avghm, :rhae, :tabo, :mpism, :spilm, :pom, :srinr, :sriip, :pogu, :adoa, :ape, :n_tfa, :n_sr, :n_arnfa, :n_arpfa,
         :n_npfar, :n_pfar, :n_co2enfa, :n_co2epfp, :n_co2enfp, :n_lamf, :n_lan2of, :n_laco2f, :n_socc, :i_tfa, :i_sr, :i_arnfa, :i_arpfa,
         :i_npfar, :i_pfar, :i_co2enfa, :i_co2epfp, :i_co2enfp, :i_lamf, :i_lan2of, :i_laco2f, :i_socc, :cpl_lowest, :cpl_highest, :tdn_lowest,
         :tdn_highest, :ndf_lowest, :ndf_highest, :adf_lowest, :adf_highest, :fir_lowest, :fir_highest, :theta, :fge, :fde, :first_area, :second_area,
         :third_area, :fourth_area, :fifth_area, :first_equip, :second_equip, :third_equip, :fourth_equip, :fifth_equip, :first_fuel, :second_fuel,
         :third_fuel, :fourth_fuel, :fifth_fuel, :trans_1, :categories_trans_1, :categories_slaug_1, :avg_marweight_1, :num_animal_1, :mortality_rate_1,
         :distance_1, :trailer_1, :trucks_1, :fuel_type_1, :same_vehicle_1, :loading_1, :carcass_1, :boneless_beef_1, :trans_2, :categories_trans_2,
         :categories_slaug_2, :avg_marweight_2, :num_animal_2, :mortality_rate_2, :distance_2, :trailer_2, :trucks_2, :fuel_type_2, :same_vehicle_2, :loading_2,
         :carcass_2, :boneless_beef_2, :trans_3, :categories_trans_3, :categories_slaug_3, :avg_marweight_3, :num_animal_3, :mortality_rate_3, :distance_3,
         :trailer_3, :trucks_3, :fuel_type_3, :same_vehicle_3, :loading_3, :carcass_3, :boneless_beef_3, :trans_4, :categories_trans_4, :categories_slaug_4,
         :avg_marweight_4, :num_animal_4, :mortality_rate_4, :distance_4, :trailer_4, :trucks_4, :fuel_type_4, :same_vehicle_4, :loading_4, :carcass_4, :boneless_beef_4,
         :second_avg_marweight_1, :second_num_animal_1, :second_avg_marweight_2, :second_num_animal_2, :second_avg_marweight_3, :second_num_animal_3, :second_avg_marweight_4, :second_num_animal_4)
    end
end
