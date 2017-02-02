class ScenariosController < ApplicationController
  include ScenariosHelper
  include SimulationsHelper
################################  list of bmps #################################
# GET /scenarios/1
# GET /1/scenarios.json
  def scenario_bmps
    session[:scenario_id] = params[:id]
    redirect_to bmps_path()
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
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => session[:field_id])
    #@field = Field.find(session[:field_id])
    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @scenarios }
    end
  end
################################  index - respond to the button simulate all  #################################
# GET /scenarios
# GET /scenarios.json
  def index
    @project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(session[:field_id]).field_name
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => session[:field_id])
    respond_to do |format|
      format.html { render action: "list" }
      format.json { render json: @scenarios }
    end
  end
################################  Simulate  #################################
  def simulate_all
    @project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(session[:field_id]).field_name
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => session[:field_id])
    msg = "OK"
    ActiveRecord::Base.transaction do
      @scenarios.each do |scenario|
        session[:scenario_id] = scenario.id
        msg = run_scenario
        unless msg.eql?("OK")
          @errors.push("Error simulating scenario " + scenario.name + " (" + msg + ")")
          raise ActiveRecord::Rollback
        end # end if msg
      end # end each do scenario loop
    end
    if msg.eql?("OK") then
      flash[:notice] = @scenarios.count.to_s + " scenarios simulated successfully" if @scenarios.count > 0
      @scenarios = Scenario.where(:field_id => session[:field_id])
      render "list", notice: "Simulation process end succesfully"
    else
      render "list", error: msg
    end # end if msg
  end

################################  NEW   #################################
# GET /scenarios/new
# GET /scenarios/new.json
  def new
    @errors = Array.new
    @scenario = Scenario.new
    @field = Field.find(session[:field_id])

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
  end

################################  CREATE  #################################
# POST /scenarios
# POST /scenarios.json
  def create
    @errors = Array.new
    @scenario = Scenario.new(scenario_params)
    @scenario.field_id = session[:field_id]
    @watershed = Watershed.new(scenario_params)
    @watershed.save
    respond_to do |format|
      if @scenario.save
        @scenarios = Scenario.where(:field_id => session[:field_id])
        #add new scenario to soils
        flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.created')
        add_scenario_to_soils(@scenario)
        session[:scenario_id] = @scenario.id
        format.html { redirect_to list_operation_path(session[:scenario_id]), notice: t('models.scenario') + " " + t('general.success') }
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

    respond_to do |format|
      if @scenario.update_attributes(scenario_params)
        session[:scenario_id] = @scenario.id
        format.html { redirect_to field_scenarios_field_path(session[:field_id]), notice: t('models.scenario') + " " + @scenario.name + t('notices.updated') }
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
    Subarea.where(:scenario_id => @scenario.id).delete_all
    if @scenario.destroy
      flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to scenarios_url }
      format.json { head :no_content }
    end
  end

################################  SHOW - simulate the selected scenario  #################################
# GET /scenarios/1
# GET /scenarios/1.json
  def show()
    @errors = Array.new
    ActiveRecord::Base.transaction do
		msg = run_scenario
		@scenarios = Scenario.where(:field_id => session[:field_id])
		@project_name = Project.find(session[:project_id]).name
		@field_name = Field.find(session[:field_id]).field_name
		respond_to do |format|
		  if msg.eql?("OK") then
			flash[:notice] = t('scenario.scenario') + " " + t('general.success')
			format.html { redirect_to field_scenarios_field_path(session[:field_id]) }
		  else
			flash[:error] = "Error simulating scenario - " + msg
			format.html { render action: "list" }
		  end # end if msg
		end
	end
  end

  private

################################  run_scenario - run simulation called from show or index  #################################
  def run_scenario()
    @last_herd = 0
	@herd_list = Array.new
	msg = "OK"
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
    if msg.eql?("OK") then msg = send_file_to_APEX("RUN", session[:session]) else return msg  end  #this operation will run a simulation and return ntt file.
    if msg.include?("NTT OUTPUT INFORMATION") then msg = read_apex_results(msg) else return msg  end
    @scenario.last_simulation = Time.now
    if @scenario.save then msg = "OK" else return "Unable to save Scenario " + @scenario.name end
    @scenarios = Scenario.where(:field_id => session[:field_id])
    return msg
  end # end show method

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def scenario_params
    params.require(:scenario).permit(:name, :field_id)
  end

end  #end class