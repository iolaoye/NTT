class ScenariosController < ApplicationController
  include ScenariosHelper	
  include SimulationsHelper
################################  list of bmps #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_bmps

    session[:scenario_id] = params[:id]
    redirect_to list_bmp_path(params[:id])	
  end
################################  list of operations   #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_operations
    session[:scenario_id] = params[:id]
    redirect_to list_operation_path(params[:id])	
  end
################################  scenarios list  #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def list
    @scenarios = Scenario.where(:field_id => params[:id])
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(params[:id]).field_name
	respond_to do |format|
		format.html # list.html.erb
		format.json { render json: @scenarios }
	end
  end
################################  index  #################################
  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.where(:field_id => session[:field_id])
	@scenarios.each do |scenario|
		session[:scenario_id] = scenario.id
		show()
	end #end each scenario loop
    render "list"
  end

################################  NEW   #################################
  # GET /scenarios/new
  # GET /scenarios/new.json
  def new
     @scenario = Scenario.new
	 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scenario }
    end
  end

################################  EDIT   #################################
  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

################################  CREATE  #################################
  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
	@scenario.field_id = session[:field_id]
	respond_to do |format|
      if @scenario.save
		@scenarios = Scenario.where(:field_id => session[:field_id])
		#add new scenario to soils
        flash[:notice] = t('scenario.scenario') + " " + t('general.success')
		add_scenario_to_soils(@scenario)
		format.html { render action: "list" }
      else
        format.html { render action: "new" }
        format.json { render json: scenario.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      if @scenario.update_attributes(scenario_params)
        format.html { redirect_to list_scenario_path(session[:field_id]), notice: "Scenario was successfully updated." }
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
    @scenario = Scenario.find(params[:id])
	Subarea.where(:scenario_id => @scenario.id).delete_all
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to scenarios_url }
      format.json { head :no_content }
    end
  end

################################  SHOW - simulate the selected scenario  #################################
  # GET /scenarios/1
  # GET /scenarios/1.json
  def show()
	if @scenarios == nil then
		session[:scenario_id] = params[:id]
	end
	@scenario = Scenario.find(session[:scenario_id])
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
	if msg.eql?("OK") then msg = create_control_file() end
	if msg.eql?("OK") then msg = create_parameter_file() end
	if msg.eql?("OK") then msg = create_site_file(@scenario.field_id) end
	if msg.eql?("OK") then msg = create_weather_file(dir_name, @scenario.field_id) end
	if msg.eql?("OK") then msg = create_wind_wp1_files(dir_name) end
	@last_soil = 0
	@soils = Soil.where(:field_id => @scenario.field_id).where(:selected => true)
	@soil_list = Array.new
	if msg.eql?("OK") then msg = create_soils() end
	if msg.eql?("OK") then msg = send_file_to_APEX(@soil_list, "soil.dat") end
	#print_array_to_file(@soil_list, "soil.dat")
	@subarea_file = Array.new
	@soil_number = 0
	if msg.eql?("OK") then msg = create_subareas(1) end
	if msg.eql?("OK") then msg = send_file_to_APEX(@opcs_list_file, "opcs.dat") end
	#print_array_to_file(@opcs_list_file, "OPCS.dat")	
	if msg.eql?("OK") then msg = send_file_to_APEX("RUN", session[:session]) end  #this operation will run a simulation and return ntt file.
	if msg.eql?("OK") then read_apex_results(msg) end
	@scenario.last_simulation = Time.now
	@scenario.save
	@scenarios = Scenario.where(:field_id => session[:field_id])
	if msg.include?("NTT OUTPUT INFORMATION") then
	#if params[:id] == nil then
		render "list", notice: "Simulation process end succesfully"
	else
		render "list", notice: msg
	end # end if msg 
  end # end show method

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def scenario_params
      params.require(:scenario).permit(:name, :field_id)
    end
	
end  #end class
