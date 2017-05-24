class WatershedsController < ApplicationController
  include SimulationsHelper
  before_filter :set_notifications

  def set_notifications
	@notice = nil
	@error = nil
  end
  ################################  watershed list   #################################
  # GET /watersheds/1
  # GET /1/watersheds.json
  def list
    @scenarios = Scenario.where(:field_id => 0) # make @scnearions empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.html notice: t('watershed.watershed') + " " + t('general.created') # list.html.erb
      format.json { render json: @watersheds }
    end
  end

  ################################  Index   #################################
  # GET /watersheds
  # GET /watersheds.json
  def index
    @scenarios = Scenario.where(:field_id => 0) # make @scnearions empty to start the list page in watershed
    @project = Project.find(params[:project_id])
    @watersheds = Watershed.where(:location_id => @project.location.id)
    session[:simulation] = 'watershed'

	add_breadcrumb 'Field Routing (Watershed)'
    respond_to do |format|
      format.html  # index.html.erb
      format.json { render json: @watersheds }
    end
  end

################################ NEW SCENARIO - ADD NEW FIELD/SCENARIO TO THE LIST OF THE SELECTED WATERSHED #################################
  def new_scenario()
    #find the name for the collection
	watersheds = Watershed.where(:location_id => Project.find(params[:project_id]).location)
	i = 1
	field_id = ""
	scenario_id = ""
	watersheds.each do |watershed|
		if watershed.name.eql? @watershed_name then
			field_id = params[("field" + i.to_s).to_sym][:id]
			scenario_id = params[("scenario" + i.to_s).to_sym][:id]
		end
		i +=1
	end

	if !(field_id == "" || scenario_id == "") then
		item = WatershedScenario.where(:field_id => field_id, :scenario_id => scenario_id, :watershed_id => @watershed.id).first
		respond_to do |format|
		  ## if item nil
		  if item == nil
			@new_watershed_scenario = WatershedScenario.new
			@new_watershed_scenario.field_id = field_id
			@new_watershed_scenario.scenario_id = scenario_id
			@new_watershed_scenario.watershed_id = @watershed.id
			#### Save new watershed
			if @new_watershed_scenario.save
			  return "saved"
			else
			  return "error"
			end
			#### Save new watershed
		  else
			return "exist"
		  end
		  ## if item nil
		end  #Respond to format
	else
		return "error"
	end  # if field or scenario <> ""

  end

  ################################  SHOW used for simulation   #################################
  # GET /watersheds/1
  # GET /watersheds/1.json
  def simulate
    @project = Project.find(params[:project_id])
	if !(params[:commit].include?("Simulate")) then
		#update watershed_scenarios
		@watershed_name = params[:commit]
		@watershed_name.slice! "Add to "
		@watershed = Watershed.find_by_name_and_location_id(@watershed_name, @project.location.id)
		status = new_scenario()
		@notice = nil
		case status
			when "saved"
				@notice = "Saved"
			when "exist"
				@error = "Already Exist"
			when "error"
				@error = "Error Adding field/scenario"
		end
	else
		#run simulations
		params[:select_watershed].each do |ws|
			session[:simulation] = 'watershed'
			@project = Project.find(params[:project_id])
			@watershed_id = ws
			@dtNow1 = Time.now.to_s
			dir_name = APEX + "/APEX" + session[:session_id]
			if !File.exists?(dir_name)
			  FileUtils.mkdir_p(dir_name)
			end
			watershed_scenarios = WatershedScenario.where(:watershed_id => @watershed_id)
			msg = send_file_to_APEX("APEX" + State.find(@project.location.state_id).state_abbreviation, session[:session_id]) #this operation will create APEX folder from APEX1 folder
			if msg.eql?("OK") then msg = create_control_file() else return msg end
			if msg.eql?("OK") then msg = create_parameter_file() else return msg end
			if msg.eql?("OK") then msg = create_site_file(Field.find_by_location_id(session[:location_id]).id) else return msg end
			@last_soil = 0
			@last_soil_sub = 0
			@last_subarea = 0
			@soil_list = Array.new
			@opcs_list_file = Array.new
			@opers = Array.new
			@depth_ant = Array.new
			@change_till_depth = Array.new
			@fem_list = Array.new
			@nutrients_structure = Struct.new(:code, :no3, :po4, :orgn, :orgp)
			@current_nutrients = Array.new
			@new_fert_line = Array.new
			@subarea_file = Array.new
			@soil_number = 0
			j=0
			watershed_scenarios.each do |p|
			  @scenario = Scenario.find(p.scenario_id)
			  @field = Field.find(p.field_id)
			  #params[:field_id] = p.field_id
			  if msg.eql?("OK") then msg = create_weather_file(dir_name, p.field_id) else return msg end
			  @soils = Soil.where(:field_id => p.field_id).where(:selected => true)
			  if msg.eql?("OK") then msg = create_soils() else return msg end
			  if msg.eql?("OK") then msg = send_file_to_APEX(@soil_list, "soil.dat") else return msg end
			  if msg.eql?("OK") then msg = create_subareas(j+1) else return msg end
			  if msg.eql?("OK") then msg = send_file_to_APEX(@opcs_list_file, "opcs.dat") else return msg end
			  j+=1
			end # end watershed_scenarios.each
			print_array_to_file(@soil_list, "soil.dat")
			print_array_to_file(@opcs_list_file, "OPCS.dat")
			if msg.eql?("OK") then msg = create_wind_wp1_files(dir_name) else return msg end
			if msg.eql?("OK") then msg = send_file_to_APEX("RUN", session[:session]) else return msg end #this operation will run a simulation
			msg = read_apex_results(msg)
			if @scenario != nil
			  @scenario.last_simulation = Time.now
			  @scenario.save
			end
			if msg == "OK"
				@notice = "Simulation ran succesfully"
			else
				@error = "Error running simulation"
			end
		end   # end params[:select_watershed].each
	end
	@scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
	@watersheds = Watershed.where(:location_id => @project.location.id)

    render "index"
  end

  ################################ NEW #################################
  # GET /watersheds/new
  # GET /watersheds/new.json
  def new
    @watershed = Watershed.new
	#@watershed.watershed_scenarios.build
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watershed }
    end
  end

  ################################ NEW #################################
  # GET /watersheds/1/edit
  def edit
    @watershed = Watershed.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  ################################ CREATE #################################
  # POST /watersheds
  # POST /watersheds.json
  def create
	if params[:commit] != nil then
		@watershed = Watershed.new(watershed_params)
		@watershed.location_id = session[:location_id]
    end
	@project = Project.find(params[:project_id])
    respond_to do |format|
      if @watershed.save
        format.html { redirect_to  project_watersheds_path(@project), notice: t('watershed.watershed') + " " + t('general.created') }
        format.json { render json: @watershed, status: :created, location: @watershed }
      else
        format.html { render action: "new" }
        format.json { render json: @watershed.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################ UPDATE #################################
  # PATCH/PUT /watersheds/1
  # PATCH/PUT /watersheds/1.json
  def update
    #find the number for the collection
	for i in 1..20
		field = "field" + i.to_s
		scenario = "scenario" + i.to_s
		if !(params[field] == nil) then
			break
		end
	end
	#status = new_scenario(field, scenario)
	@notice = nil
	case status
		when "saved"
			@notice = "Saved"
		when "exist"
			@error = "Already Exist"
		when "error"
			@error = "Error"
	end
	@project = Project.find(Location.find(Watershed.find(params[:id]).location_id).project_id)
    @scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => @project.location.id)
	params[:project_id] = @project.id
    render "index"
  end

  ################################ destroy #################################
  # DELETE /watersheds/1
  # DELETE /watersheds/1.json
  def destroy
    @watershed = Watershed.find(params[:id])
	@project = Project.find(Location.find(Watershed.find(params[:id]).location_id).project_id)

    if @watershed.destroy
        @notice = t('models.watershed') + " " + @watershed.name + t('notices.deleted')
	else
		@error = "Error deleting Field Routing"
    end

    @scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
	params[:project_id] = @project.id
    render "index"
  end

  ################################ destroy #################################
  # DELETE /watershed_scenario/1
  # DELETE /watershed_scenario/1.json
  def destroy_watershed_scenario
    @watershed_scenarios = WatershedScenario.find(params[:id])
    if @watershed_scenarios.destroy
		@project = Project.find(params[:project_id])
		@scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
		@watersheds = Watershed.where(:location_id => session[:location_id])
		params[:project_id] = @project.id
		@notice = t('models.watershed_scenario') + t('notices.deleted')
		render "index"
	else
		@error = "Error deleting Field/scenario"
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def watershed_params
    params.require(:watershed).permit(:field_id, :name, :scenario_id, :location_id, :id, :created_at, :updated_at)
  end

end
