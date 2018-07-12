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
		apex_string += aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.adwgbc') + "\n"
		apex_string += aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.adwgbh') + "\n"
		apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += aplcat.prh.to_s + "\t" + "! " + t('aplcat.prh') + "\n"
		apex_string += aplcat.prb.to_s + "\t" + "! " + t('aplcat.prb') + "\n"
		apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.jdcc') + "\n"
		apex_string += aplcat.gpc.to_s + "\t" + "! " + t('aplcat.gpc') + "\n"
		apex_string += aplcat.tpwg.to_s + "\t" + "! " + t('aplcat.tpwg') + "\n"
		apex_string += aplcat.csefa.to_s + "\t" + "! " + t('aplcat.csefa') + "\n"
		apex_string += aplcat.srop.to_s.to_s + "\t" + "! " + t('aplcat.srop') + "\n"
		apex_string += aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.bwoc') + "\n"
		apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.jdbs') + "\n"
		apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
		apex_string += aplcat.fmbmm.to_s + "\t" + "! " + t('aplcat.fmbmm') + "\n"
		apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
		apex_string += aplcat.vsim.to_s + "\t" + "! " + t('aplcat.vsim') + "\n"
		apex_string += aplcat.foue.to_s + "\t" + "! " + t('aplcat.foue') + "\n"
		apex_string += aplcat.ash.to_s + "\t" + "! " + t('aplcat.ash') + "\n"
		apex_string += aplcat.mmppfm.to_s + "\t" + "! " + t('aplcat.mmppfm') + "\n"
		apex_string += aplcat.cfmms.to_s + "\t" + "! " + t('aplcat.cfmms') + "\n"
		apex_string += aplcat.fnemimms.to_s + "\t" + "! " + t('aplcat.fnemimms') + "\n"
		apex_string += aplcat.effn2ofmms.to_s + "\t" + "! " + t('aplcat.effn2ofmms') + "\n"
		apex_string += aplcat.ptdife.to_s + "\t" + "! " + t('aplcat.ptdife') + "\n"
    apex_string += aplcat.mdogfc.to_s + "\t" + "! " + t('aplcat.mdogfc') + "\n"
    apex_string += aplcat.mxdogfc.to_s + "\t" + "! " + t('aplcat.mxdogfc') + "\n"
    apex_string += aplcat.cwsoj.to_s + "\t" + "! " + t('aplcat.cwsoj') + "\n"
    apex_string += aplcat.cweoj.to_s + "\t" + "! " + t('aplcat.cweoj') + "\n"
    #apex_string += sprintf("%.2f", aplcat.ewc) + "\t" + "! " + t('aplcat.ewc') + "\n"
    apex_string += aplcat.nodew.to_s + "\t" + "! " + t('aplcat.nodew') + "\n"
    apex_string += aplcat.byosm.to_s + "\t" + "! " + t('aplcat.byosm') + "\n"
    apex_string += aplcat.mrgauh.to_s + "\t" + "! " + t('aplcat.mrgauh') + "\n"
    apex_string += aplcat.plac.to_s + "\t" + "! " + t('aplcat.plac') + "\n"
    apex_string += aplcat.pcbb.to_s + "\t" + "! " + t('aplcat.pcbb') + "\n"
    apex_string += aplcat.domd.to_s + "\t" + "! " + t('aplcat.domd') + "\n"
    apex_string += aplcat.faueea.to_s + "\t" + "! " + t('aplcat.faueea') + "\n"
    apex_string += aplcat.acim.to_s + "\t" + "! " + t('aplcat.acim') + "\n"
    apex_string += aplcat.mmppm.to_s + "\t" + "! " + t('aplcat.mmppm') + "\n"
    apex_string += aplcat.cffm.to_s + "\t" + "! " + t('aplcat.cffm') + "\n"
    apex_string += aplcat.fnemm.to_s + "\t" + "! " + t('aplcat.fnemm') + "\n"
    apex_string += aplcat.effd.to_s + "\t" + "! " + t('aplcat.effd') + "\n"
    apex_string += aplcat.ptbd.to_s + "\t" + "! " + t('aplcat.ptbd') + "\n"
    apex_string += aplcat.pocib.to_s + "\t" + "! " + t('aplcat.pocib') + "\n"
    apex_string += aplcat.bneap.to_s + "\t" + "! " + t('aplcat.bneap') + "\n"
    apex_string += aplcat.cneap.to_s + "\t" + "! " + t('aplcat.cneap') + "\n"
    apex_string += aplcat.hneap.to_s + "\t" + "! " + t('aplcat.hneap') + "\n"
    apex_string += aplcat.pobw.to_s + "\t" + "! " + t('aplcat.pobw') + "\n"
    apex_string += aplcat.posw.to_s + "\t" + "! " + t('aplcat.posw') + "\n"
    apex_string += aplcat.posb.to_s + "\t" + "! " + t('aplcat.posb') + "\n"
    apex_string += aplcat.poad.to_s + "\t" + "! " + t('aplcat.poad') + "\n"
    apex_string += aplcat.poada.to_s + "\t" + "! " + t('aplcat.poada') + "\n"
    apex_string += aplcat.cibo.to_s + "\t" + "! " + t('aplcat.cibo') + "\n"
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
		#for i in 0..grazing.count-1
			#apex_string += sprintf("%d", grazing[i].for_button) + "\t"
	#	end
		#apex_string += "| " + t('graze.dmi_code') + "\n"
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
		#for j in 0..supplement.count-1
			#apex_string += sprintf("%d", supplement[j].for_button) + "\t"
		#end
	#	apex_string += "| " + t('graze.dmi_code') + "\n"
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
		apex_string += aplcat.noc.to_s + "\t" + "! " + t('aplcat.noc') + "\n"
		apex_string += aplcat.abwc.to_s + "\t" + "! " + t('aplcat.abwc') + "\n"
		apex_string += aplcat.norh.to_s + "\t" + "! " + t('aplcat.norh') + "\n"
		apex_string += aplcat.abwh.to_s + "\t" + "! " + t('aplcat.abwh') + "\n"
		apex_string += aplcat.nomb.to_s + "\t" + "! " + t('aplcat.nomb') + "\n"
		apex_string += aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.abwmb') + "\n"
		apex_string += aplcat.dwawfga.to_s + "\t" + "! " + t('aplcat.dwawfga') + "\n"
		apex_string += aplcat.dwawflc.to_s + "\t" + "! " + t('aplcat.dwawflc') + "\n"
		apex_string += aplcat.dwawfmb.to_s + "\t" + "! " + t('aplcat.dwawfmb') + "\n"
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
		apex_string += aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.adwgbc') + "\n"
		apex_string += aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.adwgbh') + "\n"
		apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += aplcat.prh.to_s + "\t" + "! " + t('aplcat.prh') + "\n"
		apex_string += aplcat.prb.to_s + "\t" + "! " + t('aplcat.prb') + "\n"
		apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.jdcc') + "\n"
		apex_string += aplcat.gpc.to_s + "\t" + "! " + t('aplcat.gpc') + "\n"
		apex_string += aplcat.srop.to_s + "\t" + "! " + t('aplcat.srop') + "\n"
		apex_string += aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.bwoc') + "\n"
		apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.jdbs') + "\n"
		apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += aplcat.rhaeba.to_s + "\t" + "! " + t('aplcat.rhaeba') + "\n"
		apex_string += aplcat.toaboba.to_s + "\t" + "! " + t('aplcat.toaboba') + "\n"
		apex_string += aplcat.dmi.to_s + "\t" + "! " + t('aplcat.dmi') + "\n"
		apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
		apex_string += aplcat.mpsm.to_s + "\t" + "! " + t('aplcat.mpsm') + "\n"
		apex_string += aplcat.splm.to_s + "\t" + "! " + t('aplcat.splm') + "\n"
		apex_string += aplcat.pmme.to_s + "\t" + "! " + t('aplcat.pmme') + "\n"
		apex_string += aplcat.napanr.to_s + "\t" + "! " + t('aplcat.napanr') + "\n"
		apex_string += aplcat.napaip.to_s + "\t" + "! " + t('aplcat.napaip') + "\n"
		apex_string += aplcat.pgu.to_s + "\t" + "! " + t('aplcat.pgu') + "\n"
		apex_string += aplcat.ada.to_s + "\t" + "! " + t('aplcat.ada') + "\n"
		apex_string += aplcat.ape.to_s + "\t" + "! " + t('aplcat.ape') + "\n"
    apex_string += aplcat.drinkg.to_s + "\t" + "! " + t('aplcat.drinkg') + "\n"
    apex_string += aplcat.drinkl.to_s + "\t" + "! " + t('aplcat.drinkl') + "\n"
    apex_string += aplcat.drinkm.to_s + "\t" + "! " + t('aplcat.drinkm') + "\n"
    apex_string += aplcat.avghm.to_s + "\t" + "! " + t('aplcat.avghm') + "\n"
    apex_string += aplcat.avgtm.to_s + "\t" + "! " + t('aplcat.avgtm') + "\n"
    apex_string += aplcat.rhae.to_s + "\t" + "! " + t('aplcat.rhae') + "\n"
    apex_string += aplcat.tabo.to_s + "\t" + "! " + t('aplcat.tabo') + "\n"
    apex_string += aplcat.mpism.to_s + "\t" + "! " + t('aplcat.mpism') + "\n"
    apex_string += aplcat.spilm.to_s + "\t" + "! " + t('aplcat.spilm') + "\n"
    apex_string += aplcat.pom.to_s + "\t" + "! " + t('aplcat.pom') + "\n"
    #apex_string += sprintf("%.2f", aplcat.srinl) + "\t" + "! " + t('aplcat.srinl') + "\n"
    apex_string += aplcat.sriip.to_s + "\t" + "! " + t('aplcat.sriip') + "\n"
    apex_string += aplcat.pogu.to_s + "\t" + "! " + t('aplcat.pogu') + "\n"
    apex_string += aplcat.adoa.to_s + "\t" + "! " + t('aplcat.adoa') + "\n"
		msg = send_file_to_APEX(apex_string, "WaterEnergyInputCowCalf.txt")
    apex_string += "\n"
    apex_string = "Input file for estimating CO2 Balance Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.n_tfa.to_s + "\t" + "! " + t('aplcat.n_tfa') + "\n"
    apex_string += aplcat.n_sr.to_s + "\t" + "! " + t('aplcat.n_sr') + "\n"
    apex_string += aplcat.n_arnfa.to_s + "\t" + "! " + t('aplcat.n_arnfa') + "\n"
    apex_string += aplcat.n_arpfa.to_s + "\t" + "! " + t('aplcat.n_arpfa') + "\n"
    apex_string += aplcat.n_nfar.to_s + "\t" + "! " + t('aplcat.n_nfar') + "\n"
    apex_string += aplcat.n_npfar.to_s + "\t" + "! " + t('aplcat.n_npfar') + "\n"
    apex_string += aplcat.n_co2enfp.to_s + "\t" + "! " + t('aplcat.n_co2enfp') + "\n"
    apex_string += aplcat.n_co2enfa.to_s + "\t" + "! " + t('aplcat.n_co2enfa') + "\n"
    apex_string += aplcat.n_lamf.to_s + "\t" + "! " + t('aplcat.n_lamf') + "\n"
    apex_string += aplcat.n_lan2of.to_s + "\t" + "! " + t('aplcat.n_lan2of') + "\n"
    apex_string += aplcat.n_laco2f.to_s + "\t" + "! " + t('aplcat.n_laco2f') + "\n"
    apex_string += aplcat.n_socc.to_s + "\t" + "! " + t('aplcat.n_socc') + "\n"
    apex_string += aplcat.i_tfa.to_s + "\t" + "! " + t('aplcat.i_tfa') + "\n"
    apex_string += aplcat.i_sr.to_s + "\t" + "! " + t('aplcat.i_sr') + "\n"
    apex_string += aplcat.i_arnfa.to_s + "\t" + "! " + t('aplcat.i_arnfa') + "\n"
    apex_string += aplcat.i_arpfa.to_s + "\t" + "! " + t('aplcat.i_arpfa') + "\n"
    apex_string += aplcat.i_nfar.to_s + "\t" + "! " + t('aplcat.i_nfar') + "\n"
    apex_string += aplcat.i_npfar.to_s + "\t" + "! " + t('aplcat.i_npfar') + "\n"
    apex_string += aplcat.i_co2enfp.to_s + "\t" + "! " + t('aplcat.i_co2enfp') + "\n"
    apex_string += aplcat.i_co2enfa.to_s + "\t" + "! " + t('aplcat.i_co2enfa') + "\n"
    apex_string += aplcat.i_lamf.to_s + "\t" + "! " + t('aplcat.i_lamf') + "\n"
    apex_string += aplcat.i_lan2of.to_s + "\t" + "! " + t('aplcat.i_lan2of') + "\n"
    apex_string += aplcat.i_laco2f.to_s + "\t" + "! " + t('aplcat.i_laco2f') + "\n"
    apex_string += aplcat.i_socc.to_s + "\t" + "! " + t('aplcat.i_socc') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Forage Quantity Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.forage_id.to_s + "\t" + "! " + t('aplcat.forage_id') + "\n"
    apex_string += aplcat.jincrease.to_s + "\t" + "! " + t('aplcat.jincrease') + "\n"
    apex_string += aplcat.stabilization.to_s + "\t" + "! " + t('aplcat.stabilization') + "\n"
    apex_string += aplcat.decline.to_s + "\t" + "! " + t('aplcat.decline') + "\n"
    apex_string += aplcat.opt4.to_s + "\t" + "! " + t('aplcat.opt4') + "\n"
    apex_string += aplcat.cpl_lowest.to_s + "\t" + "! " + t('aplcat.cpl_lowest') + "\n"
    apex_string += aplcat.cpl_highest.to_s + "\t" + "! " + t('aplcat.cpl_highest') + "\n"
    apex_string += aplcat.tdn_lowest.to_s + "\t" + "! " + t('aplcat.tdn_lowest') + "\n"
    apex_string += aplcat.tdn_highest.to_s + "\t" + "! " + t('aplcat.tdn_highest') + "\n"
    apex_string += aplcat.ndf_lowest.to_s + "\t" + "! " + t('aplcat.ndf_lowest') + "\n"
    apex_string += aplcat.ndf_highest.to_s + "\t" + "! " + t('aplcat.ndf_highest') + "\n"
    apex_string += aplcat.adf_lowest.to_s + "\t" + "! " + t('aplcat.adf_lowest') + "\n"
    apex_string += aplcat.adf_highest.to_s + "\t" + "! " + t('aplcat.adf_highest') + "\n"
    apex_string += aplcat.fir_lowest.to_s + "\t" + "! " + t('aplcat.fir_lowest') + "\n"
    apex_string += aplcat.fir_highest.to_s + "\t" + "! " + t('aplcat.fir_highest') + "\n"
    apex_string += "\n"
    msg = send_file_to_APEX(apex_string, "Co2AndForageQuantityInputCowCalf.txt")
    apex_string = "Input file for estimating Secondary Emmission Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.theta.to_s + "\t" + "! " + t('aplcat.theta') + "\n"
    apex_string += aplcat.fge.to_s + "\t" + "! " + t('aplcat.fge') + "\n"
    apex_string += aplcat.fde.to_s + "\t" + "! " + t('aplcat.fde') + "\n"
    apex_string += aplcat.first_area.to_s + "\t" + "! " + t('aplcat.first_area') + "\n"
    apex_string += aplcat.first_fuel.to_s + "\t" + "! " + t('aplcat.first_fuel') + "\n"
    apex_string += aplcat.first_equip.to_s + "\t" + "! " + t('aplcat.first_equip') + "\n"
    apex_string += aplcat.second_area.to_s + "\t" + "! " + t('aplcat.second_area') + "\n"
    apex_string += aplcat.second_fuel.to_s + "\t" + "! " + t('aplcat.second_fuel') + "\n"
    apex_string += aplcat.second_equip.to_s + "\t" + "! " + t('aplcat.second_equip') + "\n"
    apex_string += aplcat.third_area.to_s + "\t" + "! " + t('aplcat.third_area') + "\n"
    apex_string += aplcat.third_fuel.to_s + "\t" + "! " + t('aplcat.third_fuel') + "\n"
    apex_string += aplcat.third_equip.to_s + "\t" + "! " + t('aplcat.third_equip') + "\n"
    apex_string += aplcat.fourth_area.to_s + "\t" + "! " + t('aplcat.fourth_area') + "\n"
    apex_string += aplcat.fourth_fuel.to_s + "\t" + "! " + t('aplcat.fourth_fuel') + "\n"
    apex_string += aplcat.fourth_equip.to_s + "\t" + "! " + t('aplcat.fourth_equip') + "\n"
    apex_string += aplcat.fifth_area.to_s + "\t" + "! " + t('aplcat.fifth_area') + "\n"
    apex_string += aplcat.fifth_fuel.to_s + "\t" + "! " + t('aplcat.fifth_fuel') + "\n"
    apex_string += aplcat.fifth_equip.to_s + "\t" + "! " + t('aplcat.fifth_equip') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Animal Transport Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.tripn.to_s + "\t" + "! " + t('aplcat.tripn') + "\n"
    apex_string += "\n"
    apex_string = "This is the First Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_1.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_1.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_1.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_1.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_1.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_1.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_1.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_1.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_1.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_1.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_1.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_1.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_1.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_1.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_1.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_1.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Second Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_2.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_2.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_2.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_2.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_2.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_2.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_2.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_2.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_2.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_2.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_2.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_2.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_2.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_2.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_2.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_2.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Third Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_3.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_3.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_3.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_3.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_3.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_3.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_3.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_3.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_3.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_3.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_3.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_3.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_3.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_3.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_3.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_3.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Fourth Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_4.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_4.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_4.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_4.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_4.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_4.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_4.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_4.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_4.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_4.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_4.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_4.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_4.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_4.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_4.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_4.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string += aplcat.freqtrip.to_s + "\t" + "! " + t('aplcat.freqtrip') + "\n"
    apex_string += aplcat.filedetails.to_s + "\t" + "! " + t('aplcat.filedetails') + "\n"
    apex_string += aplcat.cattlepro.to_s + "\t" + "! " + t('aplcat.cattlepro') + "\n"
    apex_string += aplcat.purpose.to_s + "\t" + "! " + t('aplcat.purpose') + "\n"
    apex_string += aplcat.codepurpose.to_s + "\t" + "! " + t('aplcat.codepurpose') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Simulation Methods" + "\n"
		apex_string += "\n"
    apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
    apex_string += aplcat.nit.to_s + "\t" + "! " + t('aplcat.nit') + "\n"
    apex_string += aplcat.fqd.to_s + "\t" + "! " + t('aplcat.fqd') + "\n"
    apex_string += aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.uovfi') + "\n"
    apex_string += aplcat.srwc.to_s + "\t" + "! " + t('aplcat.srwc') + "\n"
    apex_string += "\n"
    msg = send_file_to_APEX(apex_string, "EmmisionTransportAndSimulationCowCalf.txt")
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
