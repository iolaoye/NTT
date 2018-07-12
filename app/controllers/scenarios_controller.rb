class ScenariosController < ApplicationController
  load_and_authorize_resource :field
  load_and_authorize_resource :scenario, :through => :field

  include ScenariosHelper
  include SimulationsHelper
  include ProjectsHelper
  include ApplicationHelper
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
    @scenarios = Scenario.where(:field_id => params[:field_id])
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @scenarios }
    end
  end
################################  index  #################################
# GET /scenarios
# GET /scenarios.json
  def index
    @errors = Array.new
  	msg = "OK"
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @scenarios = Scenario.where(:field_id => @field.id)

    if (params[:scenario] != nil)
		msg = copy_other_scenario
		if msg != "OK" then
			@errors.push msg
		else
			flash[:notice] = "Scenario copied successfuly"
		end
	end
    add_breadcrumb t('menu.scenarios')

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @scenarios }
    end
  end

################################  simualte either NTT or APLCAT  #################################
  def simulate
	msg = "OK"
	time_begin = Time.now
	session[:simulation] = 'scenario'
	case params[:commit]
		when "Simulate Selected NTT", "Simular NTT", "Simulate Selected Scenario", "Simulate Scenarios", "Simular Seleccionado Escenario"
			msg = simulate_ntt
		when "Simulate Selected Aplcat", "Simular Aplcat"
			msg = simulate_aplcat
	end
	#@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    #@scenarios = Scenario.where(:field_id => params[:field_id])
    if msg.eql?("OK") then
	  @scenario = Scenario.find(params[:select_scenario])
      flash[:notice] = @scenario.count.to_s + " " + t('scenario.simulation_success') + " " + (@scenario.last.last_simulation - time_begin).round(2).to_s + " " + t('datetime.prompts.second').downcase if @scenarios.count > 0
	  redirect_to project_field_scenarios_path(@project, @field)
    else
      render "index", error: msg
    end # end if msg
  end

################################  Simulate NTT for selected scenarios  #################################
  def simulate_ntt
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @errors = Array.new
    msg = "OK"
	if params[:select_scenario] == nil then
		@errors.push("Select at least one scenario to simulate ")
		return "Select at least one scenario to simulate "
	end
    ActiveRecord::Base.transaction do
	  params[:select_scenario].each do |scenario_id|
		  @scenario = Scenario.find(scenario_id)
		  if @scenario.operations.count <= 0 then
		  	@errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
		  	return
		  end
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
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])

    add_breadcrumb t('general.scenarios')
    add_breadcrumb 'Add New Scenario'

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
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])


    add_breadcrumb t('menu.scenarios'), project_field_scenarios_path(@project, @field)
	add_breadcrumb t('general.editing') + " " +  t('scenario.scenario')
  end

################################  CREATE  #################################
# POST /scenarios
# POST /scenarios.json
  def create
    @errors = Array.new
    @scenario = Scenario.new(scenario_params)
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @scenario.field_id = @field.id
    @watershed = Watershed.new(scenario_params)
    @watershed.save
    respond_to do |format|
      if @scenario.save
        @scenarios = Scenario.where(:field_id => params[:field_id])
        #add new scenario to soils
        flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.created')
        add_scenario_to_soils(@scenario)
        format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('models.scenario') + " " + t('general.success') }
      else
	    flash[:info] = t('scenario.scenario_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
        format.html { redirect_to project_field_scenarios_path(@project, @field) }
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
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])

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
    #@scenario = Scenario.find(params[:id])
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    #msg = @scenario.delete_files
    #@scenario.subareas.delete_all
    #Subarea.where(:scenario_id => @scenario.id).delete_all
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
  	#@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @errors = Array.new
    ActiveRecord::Base.transaction do
		msg = run_scenario
		@scenarios = Scenario.where(:field_id => params[:field_id])
		@project_name = Project.find(params[:project_id]).name
		@field_name = Field.find(params[:field_id]).field_name
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
    @errors = Array.new
	if params[:select_scenario] == nil then
		@errors.push("Select at least one Aplcat to simulate ")
		return "Select at least one Aplcat to simulate "
	end
    ActiveRecord::Base.transaction do
	  params[:select_scenario].each do |scenario_id|
		  @scenario = Scenario.find(scenario_id)
		  msg = run_aplcat
		  unless msg.eql?("OK")
			if msg.include?('cannot be null')
		  	  @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
		  	else
			  @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
			end
			raise ActiveRecord::Rollback
	      end # end if msg
      end # end each do params loop
	end
  end  # end method simulate_aplcat

  	def run_aplcat
	    msg = "OK"
	    #find the aplcat parameters for the sceanrio selected
		aplcat = AplcatParameter.find_by_scenario_id(@scenario.id)
		grazing = GrazingParameter.where(:scenario_id => @scenario.id)
		supplement = SupplementParameter.where(:scenario_id => @scenario.id)
		if aplcat == nil then
			aplcat = AplcatParameter.new
			aplcat.scenario_id = params[:select_scenario][0]
			aplcat.save
		end
	    msg = send_file_to_APEX("APLCAT", session[:session_id])  #this operation will create APLCAT+session folder from APLCAT folder
		# create string for the Cow_Calf_EME_final.txt file
		apex_string = "This is the input file containing nutritional information for cattle in the cow-calf system" + "\n"
		apex_string += "\n"
		apex_string += "General data on cow-calf system" + "\n"
		apex_string += "\n"
		apex_string += aplcat.noc.to_s + "\t" + "! " + t('aplcat.noc') + "\n"
		apex_string += aplcat.abwc.to_s + "\t" + "! " + t('aplcat.abwc') + "\n"
		apex_string += aplcat.norh.to_s + "\t" + "! " + t('aplcat.norh') + "\n"
		apex_string += aplcat.abwh.to_s + "\t" + "! " + t('aplcat.abwh') + "\n"
		apex_string += aplcat.nomb.to_s + "\t" + "! " + t('aplcat.nomb') + "\n"
    apex_string += aplcat.nocrh.to_s + "\t" + "! " + t('aplcat.nocrh') + "\n"
    apex_string += aplcat.abwrh.to_s + "\t" + "! " + t('aplcat.abwrh') + "\n"
    apex_string += aplcat.abc.to_s + "\t" + "! " + t('aplcat.abc') + "\n"
		apex_string += aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.abwmb') + "\n"   #average body weight of mature cows
		apex_string += sprintf("%.2f", aplcat.adwgbc) + "\t" + "! " + t('aplcat.adwgbc') + "\n"
		apex_string += sprintf("%.2f", aplcat.adwgbh) + "\t" + "! " + t('aplcat.adwgbh') + "\n"
		apex_string += sprintf("%.2f", aplcat.mrga) + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += sprintf("%.2f", aplcat.prh) + "\t" + "! " + t('aplcat.prh') + "\n"
		apex_string += sprintf("%.2f", aplcat.prb) + "\t" + "! " + t('aplcat.prb') + "\n"
		apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.jdcc') + "\n"
		apex_string += sprintf("%.2f", aplcat.gpc) + "\t" + "! " + t('aplcat.gpc') + "\n"
		apex_string += sprintf("%.2f", aplcat.tpwg) + "\t" + "! " + t('aplcat.tpwg') + "\n"
		apex_string += sprintf("%.2f", aplcat.csefa) + "\t" + "! " + t('aplcat.csefa') + "\n"
		apex_string += sprintf("%.2f", aplcat.srop) + "\t" + "! " + t('aplcat.srop') + "\n"
		apex_string += sprintf("%.2f", aplcat.bwoc) + "\t" + "! " + t('aplcat.bwoc') + "\n"
		apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.jdbs') + "\n"
		apex_string += sprintf("%.2f", aplcat.platc) + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += sprintf("%.2f", aplcat.pctbb) + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
		apex_string += sprintf("%.2f", aplcat.fmbmm) + "\t" + "! " + t('aplcat.fmbmm') + "\n"
		apex_string += sprintf("%.2f", aplcat.dmd) + "\t" + "! " + t('aplcat.dmd') + "\n"
		apex_string += sprintf("%.2f", aplcat.vsim) + "\t" + "! " + t('aplcat.vsim') + "\n"
		apex_string += sprintf("%.2f", aplcat.foue) + "\t" + "! " + t('aplcat.foue') + "\n"
		apex_string += sprintf("%.2f", aplcat.ash) + "\t" + "! " + t('aplcat.ash') + "\n"
		apex_string += sprintf("%.2f", aplcat.mmppfm) + "\t" + "! " + t('aplcat.mmppfm') + "\n"
		apex_string += sprintf("%.2f", aplcat.cfmms) + "\t" + "! " + t('aplcat.cfmms') + "\n"
		apex_string += sprintf("%.2f", aplcat.fnemimms) + "\t" + "! " + t('aplcat.fnemimms') + "\n"
		apex_string += sprintf("%.2f", aplcat.effn2ofmms) + "\t" + "! " + t('aplcat.effn2ofmms') + "\n"
		apex_string += sprintf("%.2f", aplcat.ptdife) + "\t" + "! " + t('aplcat.ptdife') + "\n"
    apex_string += sprintf("%.2f", aplcat.mdogfc) + "\t" + "! " + t('aplcat.mdogfc') + "\n"
    apex_string += sprintf("%.2f", aplcat.mxdogfc) + "\t" + "! " + t('aplcat.mxdogfc') + "\n"
    apex_string += sprintf("%.2f", aplcat.cwsoj) + "\t" + "! " + t('aplcat.cwsoj') + "\n"
    apex_string += sprintf("%.2f", aplcat.cweoj) + "\t" + "! " + t('aplcat.cweoj') + "\n"
    apex_string += sprintf("%.2f", aplcat.ewc) + "\t" + "! " + t('aplcat.ewc') + "\n"
    apex_string += sprintf("%.2f", aplcat.nodew) + "\t" + "! " + t('aplcat.nodew') + "\n"
    apex_string += sprintf("%.2f", aplcat.byosm) + "\t" + "! " + t('aplcat.byosm') + "\n"
    apex_string += sprintf("%.2f", aplcat.mrgauh) + "\t" + "! " + t('aplcat.mrgauh') + "\n"
    apex_string += sprintf("%.2f", aplcat.plac) + "\t" + "! " + t('aplcat.plac') + "\n"
    apex_string += sprintf("%.2f", aplcat.pcbb) + "\t" + "! " + t('aplcat.pcbb') + "\n"
    apex_string += sprintf("%.2f", aplcat.domd) + "\t" + "! " + t('aplcat.domd') + "\n"
    apex_string += sprintf("%.2f", aplcat.faueea) + "\t" + "! " + t('aplcat.faueea') + "\n"
    apex_string += sprintf("%.2f", aplcat.acim) + "\t" + "! " + t('aplcat.acim') + "\n"
    apex_string += sprintf("%.2f", aplcat.mmppm) + "\t" + "! " + t('aplcat.mmppm') + "\n"
    apex_string += sprintf("%.2f", aplcat.cffm) + "\t" + "! " + t('aplcat.cffm') + "\n"
    apex_string += sprintf("%.2f", aplcat.fnemm) + "\t" + "! " + t('aplcat.fnemm') + "\n"
    apex_string += sprintf("%.2f", aplcat.effd) + "\t" + "! " + t('aplcat.effd') + "\n"
    apex_string += sprintf("%.2f", aplcat.ptbd) + "\t" + "! " + t('aplcat.ptbd') + "\n"
    apex_string += sprintf("%.2f", aplcat.pocib) + "\t" + "! " + t('aplcat.pocib') + "\n"
    apex_string += sprintf("%.2f", aplcat.bneap) + "\t" + "! " + t('aplcat.bneap') + "\n"
    apex_string += sprintf("%.2f", aplcat.cneap) + "\t" + "! " + t('aplcat.cneap') + "\n"
    apex_string += sprintf("%.2f", aplcat.hneap) + "\t" + "! " + t('aplcat.hneap') + "\n"
    apex_string += sprintf("%.2f", aplcat.pobw) + "\t" + "! " + t('aplcat.pobw') + "\n"
    apex_string += sprintf("%.2f", aplcat.posw) + "\t" + "! " + t('aplcat.posw') + "\n"
    apex_string += sprintf("%.2f", aplcat.posb) + "\t" + "! " + t('aplcat.posb') + "\n"
    apex_string += sprintf("%.2f", aplcat.poad) + "\t" + "! " + t('aplcat.poad') + "\n"
    apex_string += sprintf("%.2f", aplcat.poada) + "\t" + "! " + t('aplcat.poada') + "\n"
    apex_string += sprintf("%.2f", aplcat.cibo) + "\t" + "! " + t('aplcat.cibo') + "\n"
		apex_string += "\n"
		apex_string += "Data on animalfeed (grasses, hay and concentrates)" + "\n"
		apex_string += "\n"
		apex_string += sprintf("%d", grazing.count)
		for i in 0..grazing.count-1
			apex_string += "\t"
		end
		apex_string += "| " + t('graze.total') + "\n\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].code) + "\t"
		end
		apex_string += "| " + t('graze.code_for') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].starting_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.sjd') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].ending_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.ejd') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].for_button) + "\t"
		end
		apex_string += "| " + t('graze.dmi_code') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].green_water_footprint) + "\t"
		end
		apex_string += "| " + t('graze.gwff') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_code) + "\t"
    end
    apex_string += "| " + t('graze.code_supp') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_rheifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].green_water_footprint_supplement) + "\t"
		end
		apex_string += "| " + t('graze.gwfs') + "\n"
    apex_string += "\n"
		apex_string += "Data on animalfeed (Supplement/Concentrate)" + "\n"
		apex_string += "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].code) + "\t"
		end
		apex_string += "| " + t('supplement.code') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].starting_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.sjd') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].ending_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.ejd') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].for_button) + "\t"
		end
		apex_string += "| " + t('graze.dmi_code') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for j in 0..supplement.count-1
      apex_string += sprintf("%.2f", supplement[j].for_dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].green_water_footprint) + "\t"
		end
		apex_string += "| " + t('graze.gwff') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].dmi_code) + "\t"
		end
		apex_string += "| " + t('graze.code_supp') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_rheifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].green_water_footprint_supplement) + "\t"
		end
		apex_string += "| " + t('graze.gwfs') + "\n"
		apex_string += "\n"
		apex_string += "IMPORTANT NOTE: Details of parameters defined in the above 11 lines:" + "\n"
		apex_string += "\n"
		apex_string += "Line 1: " + t('graze.total') + "\n"
		apex_string += "Line 2: " + t('graze.code_for') + "\n"
		apex_string += "Line 3: " + t('graze.sjd') + "\n"
		apex_string += "Line 4: " + t('graze.ejd') + "\n"
		apex_string += "Line 5: " + t('graze.ln5') + "\n"
		apex_string += "Line 6: " + t('graze.dmi_cows') + "\n"
		apex_string += "Line 7: " + t('graze.dmi_bulls') + "\n"
		apex_string += "Line 8: " + t('graze.dmi_heifers') + "\n"
		apex_string += "Line 9: " + t('graze.dmi_calves') + "\n"
    apex_string += "Line 10: " + t('graze.dmi_rheifers') + "\n"
    apex_string += "Line 11: " + t('graze.ln10') + "\n"
		apex_string += "\n"
		#***** send file to server "
		msg = send_file_to_APEX(apex_string, "EmissionInputCowCalf.txt")
		# create string for the DRINKIGWATER.txt file
		apex_string = "Input file for estimating drinking water requirement of cattle" + "\n"
		apex_string += "\n"
		apex_string += sprintf("%d", aplcat.noc) + "\t" + "! " + t('aplcat.noc') + "\n"
		apex_string += sprintf("%d", aplcat.abwc) + "\t" + "! " + t('aplcat.abwc') + "\n"
		apex_string += sprintf("%d", aplcat.norh) + "\t" + "! " + t('aplcat.norh') + "\n"
		apex_string += sprintf("%d", aplcat.abwh) + "\t" + "! " + t('aplcat.abwh') + "\n"
		apex_string += sprintf("%d", aplcat.nomb) + "\t" + "! " + t('aplcat.nomb') + "\n"
		apex_string += sprintf("%d", aplcat.abwmb) + "\t" + "! " + t('aplcat.abwmb') + "\n"
		apex_string += sprintf("%.4f", aplcat.dwawfga) + "\t" + "! " + t('aplcat.dwawfga') + "\n"
		apex_string += sprintf("%.3f", aplcat.dwawflc) + "\t" + "! " + t('aplcat.dwawflc') + "\n"
		apex_string += sprintf("%.3f", aplcat.dwawfmb) + "\t" + "! " + t('aplcat.dwawfmb') + "\n"
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
			rh[i] = 100 * (Math.exp((17.625 * rh[i].to_f) / (243.04 + rh[i].to_f)) / Math.exp((17.625 * min_temp[i].to_f) / (243.04 + min_temp[i].to_f)))
			apex_string += sprintf("%.1f", min_temp[i]) + "  "
		  end
		  apex_string += "\t" + "! " + t('aplcat.avg_temp') + "\n"
		  for i in 0..rh.count-1
			apex_string += sprintf("%.1f", rh[i]) + "  "
		  end
		  apex_string += "\t" + "! " + t('aplcat.avg_rh') + "\n"
		end
		apex_string += sprintf("%.2f", aplcat.adwgbc) + "\t" + "! " + t('aplcat.adwgbc') + "\n"
		apex_string += sprintf("%.2f", aplcat.adwgbh) + "\t" + "! " + t('aplcat.adwgbh') + "\n"
		apex_string += sprintf("%.2f", aplcat.mrga) + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += sprintf("%.2f", aplcat.prh) + "\t" + "! " + t('aplcat.prh') + "\n"
		apex_string += sprintf("%.2f", aplcat.prb) + "\t" + "! " + t('aplcat.prb') + "\n"
		apex_string += sprintf("%d", aplcat.jdcc) + "\t" + "! " + t('aplcat.jdcc') + "\n"
		apex_string += sprintf("%d", aplcat.gpc) + "\t" + "! " + t('aplcat.gpc') + "\n"
		apex_string += sprintf("%d", aplcat.srop) + "\t" + "! " + t('aplcat.srop') + "\n"
		apex_string += sprintf("%d", aplcat.bwoc) + "\t" + "! " + t('aplcat.bwoc') + "\n"
		apex_string += sprintf("%d", aplcat.jdbs) + "\t" + "! " + t('aplcat.jdbs') + "\n"
		apex_string += sprintf("%d", aplcat.platc) + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += sprintf("%d", aplcat.pctbb) + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += sprintf("%.1f", aplcat.rhaeba) + "\t" + "! " + t('aplcat.rhaeba') + "\n"
		apex_string += sprintf("%.1f", aplcat.toaboba) + "\t" + "! " + t('aplcat.toaboba') + "\n"
		apex_string += sprintf("%.1f", aplcat.dmi) + "\t" + "! " + t('aplcat.dmi') + "\n"
		apex_string += sprintf("%d", aplcat.dmd) + "\t" + "! " + t('aplcat.dmd') + "\n"
		apex_string += sprintf("%d", aplcat.mpsm) + "\t" + "! " + t('aplcat.mpsm') + "\n"
		apex_string += sprintf("%.1f", aplcat.splm) + "\t" + "! " + t('aplcat.splm') + "\n"
		apex_string += sprintf("%.1f", aplcat.pmme) + "\t" + "! " + t('aplcat.pmme') + "\n"
		apex_string += sprintf("%.2f", aplcat.napanr) + "\t" + "! " + t('aplcat.napanr') + "\n"
		apex_string += sprintf("%.3f", aplcat.napaip) + "\t" + "! " + t('aplcat.napaip') + "\n"
		apex_string += sprintf("%.1f", aplcat.pgu) + "\t" + "! " + t('aplcat.pgu') + "\n"
		apex_string += sprintf("%.1f", aplcat.ada) + "\t" + "! " + t('aplcat.ada') + "\n"
		apex_string += sprintf("%d", aplcat.ape) + "\t" + "! " + t('aplcat.ape') + "\n"
    apex_string += sprintf("%.2f", aplcat.drinkg) + "\t" + "! " + t('aplcat.drinkg') + "\n"
    apex_string += sprintf("%.2f", aplcat.drinkl) + "\t" + "! " + t('aplcat.drinkl') + "\n"
    apex_string += sprintf("%.2f", aplcat.drinkm) + "\t" + "! " + t('aplcat.drinkm') + "\n"
    apex_string += sprintf("%.2f", aplcat.avghm) + "\t" + "! " + t('aplcat.avghm') + "\n"
    apex_string += sprintf("%.2f", aplcat.avgtm) + "\t" + "! " + t('aplcat.avgtm') + "\n"
    apex_string += sprintf("%.2f", aplcat.rhae) + "\t" + "! " + t('aplcat.rhae') + "\n"
    apex_string += sprintf("%.2f", aplcat.tabo) + "\t" + "! " + t('aplcat.tabo') + "\n"
    apex_string += sprintf("%.2f", aplcat.mpism) + "\t" + "! " + t('aplcat.mpism') + "\n"
    apex_string += sprintf("%.2f", aplcat.spilm) + "\t" + "! " + t('aplcat.spilm') + "\n"
    apex_string += sprintf("%.2f", aplcat.pom) + "\t" + "! " + t('aplcat.pom') + "\n"
    apex_string += sprintf("%.2f", aplcat.srinl) + "\t" + "! " + t('aplcat.srinl') + "\n"
    apex_string += sprintf("%.2f", aplcat.sriip) + "\t" + "! " + t('aplcat.sriip') + "\n"
    apex_string += sprintf("%.2f", aplcat.pogu) + "\t" + "! " + t('aplcat.pogu') + "\n"
    apex_string += sprintf("%.2f", aplcat.adoa) + "\t" + "! " + t('aplcat.adoa') + "\n"
		msg = send_file_to_APEX(apex_string, "WaterEnergyInputCowCalf.txt")
    apex_string += "\n"
    apex_string = "Input file for estimating CO2 Balance Input" + "\n"
		apex_string += "\n"
    apex_string += sprintf("%.2f", aplcat.n_tfa) + "\t" + "! " + t('aplcat.n_tfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_sr) + "\t" + "! " + t('aplcat.n_sr') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_arnfa) + "\t" + "! " + t('aplcat.n_arnfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_arpfa) + "\t" + "! " + t('aplcat.n_arpfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_nfar) + "\t" + "! " + t('aplcat.n_nfar') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_npfar) + "\t" + "! " + t('aplcat.n_npfar') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_co2enfp) + "\t" + "! " + t('aplcat.n_co2enfp') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_co2enfa) + "\t" + "! " + t('aplcat.n_co2enfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_lamf) + "\t" + "! " + t('aplcat.n_lamf') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_lan2of) + "\t" + "! " + t('aplcat.n_lan2of') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_laco2f) + "\t" + "! " + t('aplcat.n_laco2f') + "\n"
    apex_string += sprintf("%.2f", aplcat.n_socc) + "\t" + "! " + t('aplcat.n_socc') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_tfa) + "\t" + "! " + t('aplcat.i_tfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_sr) + "\t" + "! " + t('aplcat.i_sr') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_arnfa) + "\t" + "! " + t('aplcat.i_arnfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_arpfa) + "\t" + "! " + t('aplcat.i_arpfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_nfar) + "\t" + "! " + t('aplcat.i_nfar') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_npfar) + "\t" + "! " + t('aplcat.i_npfar') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_co2enfp) + "\t" + "! " + t('aplcat.i_co2enfp') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_co2enfa) + "\t" + "! " + t('aplcat.i_co2enfa') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_lamf) + "\t" + "! " + t('aplcat.i_lamf') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_lan2of) + "\t" + "! " + t('aplcat.i_lan2of') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_laco2f) + "\t" + "! " + t('aplcat.i_laco2f') + "\n"
    apex_string += sprintf("%.2f", aplcat.i_socc) + "\t" + "! " + t('aplcat.i_socc') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Forage Quantity Input" + "\n"
		apex_string += "\n"
    apex_string += sprintf("%.2f", aplcat.forage_id) + "\t" + "! " + t('aplcat.forage_id') + "\n"
    apex_string += sprintf("%.2f", aplcat.jincrease) + "\t" + "! " + t('aplcat.jincrease') + "\n"
    apex_string += sprintf("%.2f", aplcat.stabilization) + "\t" + "! " + t('aplcat.stabilization') + "\n"
    apex_string += sprintf("%.2f", aplcat.decline) + "\t" + "! " + t('aplcat.decline') + "\n"
    apex_string += sprintf("%.2f", aplcat.opt4) + "\t" + "! " + t('aplcat.opt4') + "\n"
    apex_string += sprintf("%.2f", aplcat.cpl_lowest) + "\t" + "! " + t('aplcat.cpl_lowest') + "\n"
    apex_string += sprintf("%.2f", aplcat.cpl_highest) + "\t" + "! " + t('aplcat.cpl_highest') + "\n"
    apex_string += sprintf("%.2f", aplcat.tdn_lowest) + "\t" + "! " + t('aplcat.tdn_lowest') + "\n"
    apex_string += sprintf("%.2f", aplcat.tdn_highest) + "\t" + "! " + t('aplcat.tdn_highest') + "\n"
    apex_string += sprintf("%.2f", aplcat.ndf_lowest) + "\t" + "! " + t('aplcat.ndf_lowest') + "\n"
    apex_string += sprintf("%.2f", aplcat.ndf_highest) + "\t" + "! " + t('aplcat.ndf_highest') + "\n"
    apex_string += sprintf("%.2f", aplcat.adf_lowest) + "\t" + "! " + t('aplcat.adf_lowest') + "\n"
    apex_string += sprintf("%.2f", aplcat.adf_highest) + "\t" + "! " + t('aplcat.adf_highest') + "\n"
    apex_string += sprintf("%.2f", aplcat.fir_lowest) + "\t" + "! " + t('aplcat.fir_lowest') + "\n"
    apex_string += sprintf("%.2f", aplcat.fir_highest) + "\t" + "! " + t('aplcat.fir_highest') + "\n"
    apex_string += "\n"
    msg = send_file_to_APEX(apex_string, "Co2AndForageQuantityInputCowCalf.txt")
	    if msg.eql?("OK") then msg = send_file_to_APEX("RUNAPLCAT", session[:session_id]) else return msg  end  #this operation will run a simulation and return ntt file.
	    if msg.include?("Bull output file") then msg="OK" end
		return msg
  	end

  ################################  copy scenario selected  #################################
  def copy_scenario
	@use_old_soil = false
	msg = duplicate_scenario(params[:id], " copy", params[:field_id])
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @scenarios = Scenario.where(:field_id => @field.id)
    add_breadcrumb 'Scenarios'
	render "index"
  end

  def copy_other_scenario
  	name = " copy"
	scenario = Scenario.find(params[:scenario][:id])   #1. find scenario to copy
	#2. copy scenario to new scenario
  	new_scenario = scenario.dup
	new_scenario.name = scenario.name + name
	new_scenario.field_id = @field.id
	#new_scenario.last_simulation = ""
	if new_scenario.save
		#new_scenario_id = new_scenario.id
		#3. Copy subareas info by scenario
		add_scenario_to_soils(new_scenario)
		#4. Copy operations info
		scenario.operations.each do |operation|
  			new_op = operation.dup
			new_op.scenario_id = new_scenario.id
			new_op.save
			add_soil_operation(new_op)
		end   # end bmps.each
		#5. Copy bmps info
		@new_scenario_id = new_scenario.id
		scenario.bmps.each do |b|
			duplicate_bmp(b)
		end   # end bmps.each
	else
		return "Error Saving scenario"
	end   # end if scenario saved
  	return "OK"
  end


  def download
  	#@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    download_apex_files()
  end

  private
  	################################  run_scenario - run simulation called from show or index  #################################
  	def run_scenario()
	    @last_herd = 0
		@herd_list = Array.new
		msg = "OK"
	    dir_name = APEX + "/APEX" + session[:session_id]
	    if !File.exists?(dir_name)
	      FileUtils.mkdir_p(dir_name)
	    end
	    #FileUtils.cp_r(Dir[APEX_ORIGINAL + '/*'], Dir[dir_name])
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
		@last_herd = 0
	    @fert_code = 79
	    state_id = @project.location.state_id
	  	@state_abbreviation = "**"
	  	if state_id != 0 and state_id != nil then
	  		@state_abbreviation = State.find(state_id).state_abbreviation
	  	end
	    if msg.eql?("OK") then msg = create_control_file() else return msg end									#this prepares the apexcont.dat file
	    if msg.eql?("OK") then msg = create_parameter_file() else return msg  end								#this prepares the parms.dat file
	    if msg.eql?("OK") then msg = create_site_file(@scenario.field_id) else return msg  end					#this prepares the apex.sit file
	    if msg.eql?("OK") then msg = create_weather_file(dir_name, @scenario.field_id) else return msg  end		#this prepares the apex.wth file
	    if msg.eql?("OK") then msg = send_files_to_APEX("APEX" + State.find(@project.location.state_id).state_abbreviation) end  #this operation will create apexcont.dat, parms.dat, apex.sit, apex.wth files and the APEX folder from APEX1 folder
	    if msg.eql?("OK") then msg = create_wind_wp1_files() else return msg  end
	    @last_soil = 0
	    @grazing = @scenario.operations.find_by_activity_id([7, 9])
	    if @grazing == nil then
	    	@soils = @field.soils.where(:selected => true)
	    else
	    	@soils = @field.soils.where(:selected => true).limit(1)
		end
	    @soil_list = Array.new
	    if msg.eql?("OK") then msg = create_apex_soils() else return msg  end
	    @subarea_file = Array.new
	    @soil_number = 0
	    if msg.eql?("OK") then msg = create_subareas(1) else return msg  end
	    if msg.eql?("OK") then msg = send_files1_to_APEX("RUN") else return msg  end  #this operation will run a simulation and return ntt file.
	    if msg.include?("NTT OUTPUT INFORMATION") then msg = read_apex_results(msg) else return msg end   #send message as parm to read_apex_results because it is all of the results information
	    @scenario.last_simulation = Time.now
	    if @scenario.save then msg = "OK" else return "Unable to save Scenario " + @scenario.name end
	    return msg
  	end # end show method

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def scenario_params
    params.require(:scenario).permit(:name, :field_id, :scenario_select)
  end

end  #end class
