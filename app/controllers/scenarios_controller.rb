class ScenariosController < ApplicationController
  load_and_authorize_resource :field
  load_and_authorize_resource :scenario, :through => :field
	
  include ScenariosHelper
  include SimulationsHelper
################################  scenario bmps #################################
# GET /scenarios/1
# GET /1/scenarios.json
  def scenario_bmps
    redirect_to bmps_path()
  end
################################  list of operations   #################################
# GET /scenarios/1
# GET /1/scenarios.json
  def scenario_operations
    params[:scenario_id] = params[:id]
    redirect_to list_operation_path(params[:id])
  end
################################  scenarios list  #################################
# GET /scenarios/1
# GET /1/scenarios.json
  def list
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => session[:field_id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    #@field = Field.find(session[:field_id])
    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @scenarios }
    end
  end
################################  index  #################################
# GET /scenarios
# GET /scenarios.json
  def index
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => @field.id)
    respond_to do |format|
      format.html { render action: "list" }
      format.json { render json: @scenarios }
    end
  end

  def simulate
	case params[:commit]
		when "Simulate NTT", "Simular NTT"
			msg = simulate_ntt
		when "Simulate Aplcat", "Simular Aplcat"
			msg = simulate_aplcat
	end
	@project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])

    @scenarios = Scenario.where(:field_id => params[:field_id])
    if msg.eql?("OK") then
      flash[:notice] = @scenarios.count.to_s + " scenarios simulated successfully" if @scenarios.count > 0
      render "list", notice: "Simulation process end succesfully"
    else
      render "list", error: msg
    end # end if msg
  end 

################################  Simulate NTT for selected scenarios  #################################
  def simulate_ntt
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @errors = Array.new
    #@scenarios = Scenario.where(:field_id => session[:field_id])
    msg = "OK"
    ActiveRecord::Base.transaction do
	  params[:select_scenario].each do |scenario_id|
		  @scenario = Scenario.find(scenario_id)
		  msg = run_scenario
		  unless msg.eql?("OK")
          @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
          raise ActiveRecord::Rollback
	      end # end if msg
      end # end each do params loop
    end
	return msg
  end
################################  NEW   #################################
# GET /scenarios/new
# GET /scenarios/new.json
  def new
    @errors = Array.new
    @scenario = Scenario.new
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scenario }
    end
  end

################################  EDIT   #################################
# GET /scenarios/1/edit
  def edit
    #@errors = Array.new
    @scenario = Scenario.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
  end

################################  CREATE  #################################
# POST /scenarios
# POST /scenarios.json
  def create
    @errors = Array.new
    @scenario = Scenario.new(scenario_params)
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario.field_id = @field.id
    @watershed = Watershed.new(scenario_params)
    @watershed.save
    respond_to do |format|
      if @scenario.save
        @scenarios = Scenario.where(:field_id => session[:field_id])
        #add new scenario to soils
        flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.created')
        add_scenario_to_soils(@scenario)
        format.html { redirect_to list_project_field_scenario_operations_path(@project, @field, @scenario), notice: t('models.scenario') + " " + t('general.success') }
      else
        format.html { render action: "list" }
        format.json { render json: scenario.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
# PATCH/PUT /scenarios/1
# PATCH/PUT /scenarios/1.json
  def update
    @errors = Array.new
    @scenario = Scenario.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])

    respond_to do |format|
      if @scenario.update_attributes(scenario_params)
        format.html { redirect_to project_field_scenarios_path(@project, @field), notice: t('models.scenario') + " " + @scenario.name + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

################################  DESTROY  #################################
# DELETE /scenarios/1
# DELETE /scenarios/1.json
  def destroy
    @errors = Array.new
    @scenario = Scenario.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    Subarea.where(:scenario_id => @scenario.id).delete_all
    if @scenario.destroy
      flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to project_field_scenarios_path(@project, @field) }
      format.json { head :no_content }
    end
  end

################################  SHOW - simulate the selected scenario  #################################
# GET /scenarios/1
# GET /scenarios/1.json
  def show()
  	@project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @errors = Array.new
    ActiveRecord::Base.transaction do
		msg = run_scenario
		@scenarios = Scenario.where(:field_id => params[:field_id])
		@project_name = Project.find(session[:project_id]).name
		@field_name = Field.find(session[:field_id]).field_name
		respond_to do |format|
		  if msg.eql?("OK") then
			flash[:notice] = t('scenario.scenario') + " " + t('general.success')
			format.html { redirect_to project_field_scenarios_path(@project, @field) }
		  else
			flash[:error] = "Error simulating scenario - " + msg
			format.html { render action: "list" }
		  end # end if msg
		end
	end
  end

################################  aplcat - simulate the selected scenario for aplcat #################################
  def simulate_aplcat
	msg = "OK"
    #find the aplcat parameters for the sceanrio selected
	aplcat = AplcatParameter.find_by_scenario_id(params[:id])
	grazing = GrazingParameter.where(:scenario_id => params[:id])
	if aplcat == nil then
		aplcat = AplcatParameter.new
		aplcat.scenario_id = params[:id]
		aplcat.save
	end
    msg = send_file_to_APEX("APLCAT", session[:session_id])  #this operation will create APLCAT+session folder from APLCAT folder
	# create string for the Cow_Calf_EME_final.txt file
	apex_string = "This is the input file containing nutritional information for cattle in the cow-calf system" + "\n"
	apex_string += "\n"
	apex_string += "General data on cow-calf system" + "\n"
	apex_string += "\n"
	apex_string += sprintf("%8.2f", aplcat.noc) + "\t" + "! " + t('aplcat.noc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwc) + "\t" + "! " + t('aplcat.abwc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.norh) + "\t" + "! " + t('aplcat.norh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwh) + "\t" + "! " + t('aplcat.abwh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.nomb) + "\t" + "! " + t('aplcat.nomb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwmb) + "\t" + "! " + t('aplcat.abwmb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.adwgbc) + "\t" + "! " + t('aplcat.adwgbc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.adwgbh) + "\t" + "! " + t('aplcat.adwgbh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.mrga) + "\t" + "! " + t('aplcat.mrga') + "\n"	
	apex_string += sprintf("%8.2f", aplcat.prh) + "\t" + "! " + t('aplcat.prh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.prb) + "\t" + "! " + t('aplcat.prb') + "\n"	
	apex_string += sprintf("%8.2f", aplcat.jdcc) + "\t" + "! " + t('aplcat.jdcc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.gpc) + "\t" + "! " + t('aplcat.gpc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.tpwg) + "\t" + "! " + t('aplcat.tpwg') + "\n"
	apex_string += sprintf("%8.2f", aplcat.csefa) + "\t" + "! " + t('aplcat.csefa') + "\n"
	apex_string += sprintf("%8.2f", aplcat.srop) + "\t" + "! " + t('aplcat.srop') + "\n"
	apex_string += sprintf("%8.2f", aplcat.bwoc) + "\t" + "! " + t('aplcat.bwoc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.jdbs) + "\t" + "! " + t('aplcat.jdbs') + "\n"
	apex_string += sprintf("%8.2f", aplcat.platc) + "\t" + "! " + t('aplcat.platc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.pctbb) + "\t" + "! " + t('aplcat.pctbb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dmd) + "\t" + "! " + t('aplcat.dmd') + "\n"
	apex_string += sprintf("%8.2f", aplcat.vsim) + "\t" + "! " + t('aplcat.vsim') + "\n"
	apex_string += sprintf("%8.2f", aplcat.foue) + "\t" + "! " + t('aplcat.foue') + "\n"
	apex_string += sprintf("%8.2f", aplcat.ash) + "\t" + "! " + t('aplcat.ash') + "\n"
	apex_string += sprintf("%8.2f", aplcat.mmppfm) + "\t" + "! " + t('aplcat.mmppfm') + "\n"
	apex_string += sprintf("%8.2f", aplcat.cfmms) + "\t" + "! " + t('aplcat.cfmms') + "\n"
	apex_string += sprintf("%8.2f", aplcat.fnemimms) + "\t" + "! " + t('aplcat.fnemimms') + "\n"
	apex_string += sprintf("%8.2f", aplcat.effn2ofmms) + "\t" + "! " + t('aplcat.effn2ofmms') + "\n"
	apex_string += sprintf("%8.2f", aplcat.ptdife) + "\t" + "! " + t('aplcat.ptdife') + "\n"
	apex_string += "\n"
	apex_string += "Data on animalfeed (grasses, hay and concentrates)" + "\n"
	apex_string += "\n"
	apex_string += sprintf("%.f", grazing.count) 
	for i in 0..grazing.count-1
		apex_string += "\t" 
	end
	apex_string += "| " + t('graze.total') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%.f", grazing[i].code) + "\t"
	end 
	apex_string += "| " + t('graze.code') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%.f", grazing[i].starting_julian_day) + "\t"
	end
	apex_string += "| " + t('graze.sjd') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%.f", grazing[i].ending_julian_day) + "\t"
	end
	apex_string += "| " + t('graze.ejd') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%.f", grazing[i].dmi_code) + "\t"
	end
	apex_string += "| " + t('graze.dmi_code') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%8.2f", grazing[i].dmi_cows) + "\t"
	end
	apex_string += "| " + t('graze.dmi_cows') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%8.2f", grazing[i].dmi_bulls) + "\t"
	end
	apex_string += "| " + t('graze.dmi_bulls') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%8.2f", grazing[i].dmi_heifers) + "\t"
	end
	apex_string += "| " + t('graze.dmi_heifers') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%8.2f", grazing[i].dmi_calves) + "\t"
	end
	apex_string += "| " + t('graze.dmi_calves') + "\n"
	for i in 0..grazing.count-1
		apex_string += sprintf("%.f", grazing[i].green_water_footprint) + "\t"
	end
	apex_string += "| " + t('graze.gwf') + "\n"
	apex_string += "\n"
	apex_string += "IMPORTANT NOTE: Details of parameters defined in the above 8 lines:" + "\n"
	apex_string += "\n"
	apex_string += t('graze.ln1') + "\n"
	apex_string += t('graze.ln2') + "\n"
	apex_string += "Line 3: " + t('graze.sjd') + "\n"
	apex_string += "Line 4: " + t('graze.ejd') + "\n"
	apex_string += t('graze.ln5') + "\n"
	apex_string += "Line 6: " + t('graze.dmi_cows') + "\n"
	apex_string += "Line 7: " + t('graze.dmi_bulls') + "\n"
	apex_string += "Line 8: " + t('graze.dmi_heifers') + "\n"
	apex_string += "Line 9: " + t('graze.dmi_calves') + "\n"
	apex_string += t('graze.ln10') + "\n"
	apex_string += "\n"
	#***** send file to server "
	msg = send_file_to_APEX(apex_string, "EmissionInputCowCalf.txt")
	# create string for the DRINKIGWATER.txt file
	apex_string = "Input file for estimating drinking water requirement of cattle" + "\n"
	apex_string += "\n"
	apex_string += sprintf("%8.2f", aplcat.noc) + "\t" + "! " + t('aplcat.noc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwc) + "\t" + "! " + t('aplcat.abwc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.norh) + "\t" + "! " + t('aplcat.norh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwh) + "\t" + "! " + t('aplcat.abwh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.nomb) + "\t" + "! " + t('aplcat.nomb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.abwmb) + "\t" + "! " + t('aplcat.abwmb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dwawfga) + "\t" + "! " + t('aplcat.dwawfga') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dwawflc) + "\t" + "! " + t('aplcat.dwawflc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dwawfmb) + "\t" + "! " + t('aplcat.dwawfmb') + "\n"
	# take monthly avg max and min temp and get an average of those two
	# take monthly rh to add to dringking water.
	county = County.find(Location.find(session[:location_id]).county_id)
    if county != nil then
      client = Savon.client(wsdl: URL_Weather)
      response = client.call(:create_wp1_from_weather, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => county.wind_wp1_name, "controlvalue5" => ApexControl.find_by_control_description_id(6).value.to_i.to_s})
      #response = client.call(:get_weather, message: {"path" => WP1 + "/" + county.wind_wp1_name + ".wp1"})
      weather_data = response.body[:create_wp1_from_weather_response][:create_wp1_from_weather_result][:string]
	  max_temp = weather_data[2].split
	  min_temp = weather_data[3].split
	  rh = weather_data[14].split
	  for i in 0..max_temp.count-1
		min_temp[i] = sprintf("%5.1f",((max_temp[i].to_f + min_temp[i].to_f) / 2) * 9/5 + 32)
		session[:depth] = rh[i]
		rh[i] = 100 * (Math.exp((17.625 * rh[i].to_f) / (243.04 + rh[i].to_f)) / Math.exp((17.625 * min_temp[i].to_f) / (243.04 + min_temp[i].to_f)))
		apex_string += sprintf("%5.1f", min_temp[i]) + "  "
	  end
	  apex_string += "\t" + "! " + t('aplcat.avg_temp') + "\n"
	  for i in 0..rh.count-1
		apex_string += sprintf("%5.1f", rh[i]) + "  "
	  end
	  apex_string += "\t" + "! " + t('aplcat.avg_rh') + "\n"
	end
	apex_string += sprintf("%8.2f", aplcat.adwgbc) + "\t" + "! " + t('aplcat.adwgbc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.adwgbh) + "\t" + "! " + t('aplcat.adwgbh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.mrga) + "\t" + "! " + t('aplcat.mrga') + "\n"	
	apex_string += sprintf("%8.2f", aplcat.prh) + "\t" + "! " + t('aplcat.prh') + "\n"
	apex_string += sprintf("%8.2f", aplcat.prb) + "\t" + "! " + t('aplcat.prb') + "\n"	
	apex_string += sprintf("%8.2f", aplcat.jdcc) + "\t" + "! " + t('aplcat.jdcc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.gpc) + "\t" + "! " + t('aplcat.gpc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.srop) + "\t" + "! " + t('aplcat.srop') + "\n"
	apex_string += sprintf("%8.2f", aplcat.bwoc) + "\t" + "! " + t('aplcat.bwoc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.jdbs) + "\t" + "! " + t('aplcat.jdbs') + "\n"
	apex_string += sprintf("%8.2f", aplcat.platc) + "\t" + "! " + t('aplcat.platc') + "\n"
	apex_string += sprintf("%8.2f", aplcat.pctbb) + "\t" + "! " + t('aplcat.pctbb') + "\n"
	apex_string += sprintf("%8.2f", aplcat.rhaeba) + "\t" + "! " + t('aplcat.rhaeba') + "\n"
	apex_string += sprintf("%8.2f", aplcat.toaboba) + "\t" + "! " + t('aplcat.toaboba') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dmi) + "\t" + "! " + t('aplcat.dmi') + "\n"
	apex_string += sprintf("%8.2f", aplcat.dmd) + "\t" + "! " + t('aplcat.dmd') + "\n"
	apex_string += sprintf("%8.2f", aplcat.mpsm) + "\t" + "! " + t('aplcat.mpsm') + "\n"
	apex_string += sprintf("%8.2f", aplcat.splm) + "\t" + "! " + t('aplcat.splm') + "\n"
	apex_string += sprintf("%8.2f", aplcat.pmme) + "\t" + "! " + t('aplcat.pmme') + "\n"
	apex_string += sprintf("%8.2f", aplcat.pgu) + "\t" + "! " + t('aplcat.pgu') + "\n"
	apex_string += sprintf("%8.2f", aplcat.ada) + "\t" + "! " + t('aplcat.ada') + "\n"
	apex_string += sprintf("%8.2f", aplcat.ape) + "\t" + "! " + t('aplcat.ape') + "\n"
	apex_string += sprintf("%8.2f", aplcat.napanr) + "\t" + "! " + t('aplcat.napanr') + "\n"
	apex_string += sprintf("%8.2f", aplcat.napaip) + "\t" + "! " + t('aplcat.napaip') + "\n"
	msg = send_file_to_APEX(apex_string, "WaterEnergyInputCowCalf.txt")
	return msg
  end	
  
  private
  ################################  run_scenario - run simulation called from show or index  #################################
  def run_scenario()
    @last_herd = 0
	@herd_list = Array.new
	msg = "OK"
    dir_name = APEX + "/APEX" + session[:session_id]
    #dir_name2 = "#{Rails.root}/data/#{session[:session_id]}"
    if !File.exists?(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
    #FileUtils.cp_r(Dir[APEX_ORIGINAL + '/*'], Dir[dir_name])
    msg = send_file_to_APEX("APEX", session[:session_id])  #this operation will create APEX folder from APEX1 folder
    #CREATE structure for nutrients that go with fert file
    @nutrients_structure = Struct.new(:code, :no3, :po4, :orgn, :orgp)
    @current_nutrients = Array.new
    @new_fert_line = Array.new
    @change_fert_for_grazing_line = Array.new
    @fem_list = Array.new
    @dtNow1  = Time.now.to_s
    @opcs_list_file = Array.new
    @depth_ant = Array.new
    @opers = Array.new
    @change_till_depth = Array.new
    @last_soil_sub = 0
    @last_subarea = 0
    if msg.eql?("OK") then msg = create_control_file() else return msg end
    if msg.eql?("OK") then msg = create_parameter_file() else return msg  end
    if msg.eql?("OK") then msg = create_site_file(@scenario.field_id) else return msg  end
    if msg.eql?("OK") then msg = create_weather_file(dir_name, @scenario.field_id) else return msg  end
    if msg.eql?("OK") then msg = create_wind_wp1_files(dir_name) else return msg  end
    @last_soil = 0
    @soils = Soil.where(:field_id => @scenario.field_id).where(:selected => true)
    @soil_list = Array.new
    if msg.eql?("OK") then msg = create_soils() else return msg  end
    if msg.eql?("OK") then msg = send_file_to_APEX(@soil_list, "soil.dat") else return msg  end
    #print_array_to_file(@soil_list, "soil.dat")
    @subarea_file = Array.new
    @soil_number = 0
    if msg.eql?("OK") then msg = create_subareas(1) else return msg  end
    if msg.eql?("OK") then msg = send_file_to_APEX(@opcs_list_file, "opcs.dat") else return msg  end
    if msg.eql?("OK") then msg = send_file_to_APEX("RUN", session[:session_id]) else return msg  end  #this operation will run a simulation and return ntt file.
    if msg.include?("NTT OUTPUT INFORMATION") then msg = read_apex_results(msg) else return msg end   #send message as parm to read_apex_results because it is all of the results information 
    @scenario.last_simulation = Time.now
    if @scenario.save then msg = "OK" else return "Unable to save Scenario " + @scenario.name end
    @scenarios = Scenario.where(:field_id => params[:field_id])
    return msg
  end # end show method

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def scenario_params
    params.require(:scenario).permit(:name, :field_id, :scenario_select)
  end

end  #end class