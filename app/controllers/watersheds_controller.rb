
class WatershedsController < ApplicationController
  include ProjectsHelper
  include SimulationsHelper
  include ApplicationHelper

  before_filter :set_notifications

  def run_fem
    drive = "D:"
    folder = drive + "\\NTT_FEM_Files\\FEM" + session[:session_id]
    #create NTT_FEMOptions.txt file
    ntt_fem_Options = "ManureRateCode|Manure" + "\n"
    ntt_fem_Options += "LatLongFile|" + drive + '\NTT_FEM\Long_Lat.txt' + "\n"
    ntt_fem_Options += "FileDir|" + drive + '\NTT_FEM' + "\n"
    ntt_fem_Options += "FEMPath|" + drive + '\NTT_FEM' + "\n"
    ntt_fem_Options += "FEMFilesPath|" + folder + '\\' + "\n"
    ntt_fem_Options += "MMSDir|" + drive + '\NTT_FEM' + "\n"
    ntt_fem_Options += "FEMProgPath|" + drive + '\NTT_FEM' + "\n"
    ntt_fem_Options += "OperationsLibraryFile|" + folder + '\\Local.mdb' + "\n"
    ntt_fem_Options += "FEMOutputFile|" + folder + '\\NTTFEMOut.mdb' + "\n"
    ntt_fem_Options += "TimeHorizon|" + @project.apex_controls[0].value.to_s + "\n"
    ntt_fem_Options += "NTTPath|" + folder + "\n"
    ntt_fem_Options += "COUNTY|" + County.find(@project.location.county_id).county_state_code + "\n"
    ntt_fem_Options += "Scenario|" + @watershed.name + "\n"
    #find if there are bmps with area taken from the field
    bmps_area = @watershed.bmps.where("area>0").sum(:area)
    #find the crops in the scenario a take crop, yield, unit, field area, field area without bmps.
    crops = @watershed.crop_results.group(:name).average("yldf+yldg")
    crops.each do |c|
      crop = Crop.find_by_code(c[0])
      crop_yield = (crop.conversion_factor * AC_TO_HA) / (crop.dry_matter/100) * c[1]
      ntt_fem_Options +=  "CROP|" + c[0] + "|" + crop_yield.round(2).to_s + "|" + crop.yield_unit + "|" + @field.field_area.round(2).to_s + "|" + (@field.field_area-bmps_area).round(2).to_s + "\n"
    end
    #send the file to server
    msg = send_file_to_APEX(ntt_fem_Options, "NTT_FEMOptions.txt")
    #create fembat01.bat file
    ntt_fem_Options = drive + "\n"
    ntt_fem_Options += "cd " + folder + "\\" + "\n" 
    ntt_fem_Options += drive + "\\NTT_FEM\\new2.exe" + "\n"
    #send the file to server
    msg = send_file_to_APEX(ntt_fem_Options, "fembat01.bat")
    state = State.find(@project.location.state_id).state_abbreviation
    #@fem_list = Array.new

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.additions {
        xml.operations {
          @watershed.operations.each do |op|
            get_operations(op, state, xml)
          end
        }
        #todo add bmps 
        #xml.bmps {
          #@scenario.bmps.each do |bmp|
            #get_bmps(bmp, state, xml)
          #end
        #}
      }
    end
    fem_list = builder.to_xml  #convert the Nokogiti XML file to XML file text
    fem_list.gsub! "<", "["
    fem_list.gsub! ">", "]"
    fem_list.gsub! "\n", ""
    fem_list.gsub! "[?xml version=\"1.0\"?]", ""
    #populate local.mdb and run FEM
    
    msg = send_file_to_APEX(fem_list, "Operations")
    if !msg.include? "Error"
      if !(@scenario.fem_result == nil) then @scenario.fem_result.destroy end
      fem_result = FemResult.new
      fem_res = msg.split(",")
      fem_result.total_revenue = fem_res[0]
      fem_result.total_cost = fem_res[1]
      fem_result.net_return = fem_res[2]
      fem_result.net_cash_flow = fem_res[3]
      fem_result.scenario_id = @scenario.id
      fem_result.save
      return "OK"
    else
      return msg
    end
  end


  def simulate_fem
    @errors = Array.new
    msg = "OK"
    #msg = fem_tables()  
    if params[:select_watershed] == nil then
      @errors.push("Select at least one watershed to simulate ")
      return "Select at least one watershed to simulate "
    end
    ActiveRecord::Base.transaction do
      params[:select_watershed].each do |id|
        @watershed = Watershed.find(id)
        byebug
        # if @watershed.operations.count <= 0 then
        #   @errors.push(@watershed.name + " " + t('scenario.add_crop_rotation'))
        #   return
        # end
        #msg = create_fem_tables  Should be added when tables are able to be modified such us feed table etc.
        msg = run_fem
        unless msg.eql?("OK")
          @errors.push("Error simulating watershed " + @watershed.name + " (" + msg + ")")
          raise ActiveRecord::Rollback
        end # end unless msg
      end # end each do params loop
    end
    return msg
  end

  def set_notifications
  	@notice = nil
  	@error = nil
  end
  ################################  watershed list   #################################
  # GET /watersheds/1
  # GET /1/watersheds.json
  def list
    @scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
    watershed_scenarios_count(@watersheds)
    #@project = Project.find(params[:project_id])
    respond_to do |format|
      format.html notice: t('watershed.watershed') + " " + t('general.created') # list.html.erb
      format.json { render json: @watersheds }
    end
  end

  ################################  Index   #################################
  # GET /watersheds
  # GET /watersheds.json
  def index
    @scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
    #@project = Project.find(params[:project_id])
    @watersheds = Watershed.where(:location_id => @project.location.id)
    watershed_scenarios_count(@watersheds)

	  add_breadcrumb t('watershed.watershed')
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
    #@project = Project.find(params[:project_id])
    @errors = Array.new
    if (params[:commit].include?("FEM")) then
        msg = simulate_fem
	  elsif !(params[:commit].include?("Simulate")) then
  		#update watershed_scenarios
  		@watershed_name = params[:commit]
  		@watershed_name.slice! "Add to "
  		@watershed = Watershed.find_by_name_and_location_id(@watershed_name, @project.location.id)
  		status = new_scenario()
  		@notice = nil
  		case status
  			when "saved"
  				@notice = t('field.field') + "/" + t('scenario.scenario') + " " + t('general.created')
  			when "exist"
  				@errors.push(t('field.field') + "/" + t('scenario.scenario') + " " + t('errors.messages.exist'))
  			when "error"
  				@errors.push("Error " + t('general.adding') + " " + t('field.field') + "/" + t('scenario.scenario'))
  		end
    	else
    		#run simulations
    		if params[:select_watershed]
    			params[:select_watershed].each do |ws|
    				@watershed = Watershed.find(ws)
    				if @watershed.watershed_scenarios.count == 0
    					@errors.push("Unable to simulate Watershed " + @watershed.name + ". Please add a field to "  + @watershed.name + " to successfully run the simulation.")
    				end
    				break if @errors.present?
    				session[:simulation] = 'watershed'
    				@project = Project.find(params[:project_id])
    				watershed_id = ws
    				@dtNow1 = Time.now.to_s
    				dir_name = APEX + "/APEX" + session[:session_id]
    				if !File.exists?(dir_name)
    				  FileUtils.mkdir_p(dir_name)
    				end
    				watershed_scenarios = WatershedScenario.where(:watershed_id => watershed_id)
    				msg = create_control_file()			#this prepares the apexcont.dat file
    				if msg.eql?("OK") then msg = create_parameter_file() else return msg end			#this prepares the parms.dat file
    				#todo weather is created just from the first field at this time. and @scenario too. It should be for each field/scenario
    				@scenario = Scenario.find(watershed_scenarios[0].scenario_id)
    				if msg.eql?("OK") then msg = create_weather_file(dir_name, watershed_scenarios[0].field_id) else return msg end			#this prepares the apex.wth file
    				if msg.eql?("OK") then msg = create_site_file(Field.find_by_location_id(@project.location.id)) else return msg end		#this prepares the apex.sit file
    				if msg.eql?("OK") then msg = send_files_to_APEX("APEX" + State.find(@project.location.state_id).state_abbreviation) else return msg end #this operation will create apexcont.dat, parms.dat, apex.sit, apex.wth files and the APEX folder from APEX1 folder
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
    				@last_herd = 0
    				@herd_list = Array.new
    				@change_fert_for_grazing_line = Array.new
    		    	@fert_code = 79
    				j=0
    			    state_id = @project.location.state_id
    			  	@state_abbreviation = "**"
    			  	if state_id != 0 and state_id != nil then
    			  		@state_abbreviation = State.find(state_id).state_abbreviation
    			  	end
    				watershed_scenarios.each do |p|
    				  @scenario = Scenario.find(p.scenario_id)
    				  @field = Field.find(p.field_id)
    					@grazing = @scenario.operations.find_by_activity_id([7, 9])
    					if @grazing == nil then
    						#@soils = @field.soils.where(:selected => true)
    						@soils = Soil.where(:field_id => p.field_id)
    					else
    						#@soils = @field.soils.where(:selected => true).limit(1)
    						@soils = Soil.where(:field_id => p.field_id).limit(1)
    					end
    				  	#@soils = Soil.where(:field_id => p.field_id).where(:selected => true)
    				  	if msg.eql?("OK") then msg = create_apex_soils() else return msg end
    				  	if msg.eql?("OK") then msg = create_subareas(j+1) else return msg end
    				  	j+=1
    				end # end watershed_scenarios.each
    				print_array_to_file(@soil_list, "soil.dat")
    				print_array_to_file(@opcs_list_file, "OPCS.dat")
    				if msg.eql?("OK") then msg = create_wind_wp1_files() else return msg end
    				if msg.eql?("OK") then msg = send_files1_to_APEX("RUN") else return msg end #this operation will run a simulation
    				if !msg.include?("Error") then
    					msg = read_apex_results(msg)
    					@watershed.last_simulation = Time.now
    				end
    				@watershed.save
    				if msg == "OK"
    					@notice = "Simulation ran succesfully"
    				else
    					@errors.push("Error running simulation for " + @watershed.name)
    				end
    			end   # end params[:select_watershed].each
    		else
    			@errors.push("Please select a watershed for simulation.")
    		end	# end watershed present?
  	end
  	@scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
  	@watersheds = Watershed.where(:location_id => @project.location.id)
  	watershed_scenarios_count(@watersheds)
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
    #@project = Project.find(params[:project_id])
  end

  ################################ CREATE #################################
  # POST /watersheds
  # POST /watersheds.json
  def create
  	if params[:commit] != nil then
  		@watershed = Watershed.new(watershed_params)
  		@watershed.location_id = @project.location.id
    end
  	#@project = Project.find(params[:project_id])
  	add_breadcrumb t('watershed.watershed'), project_watersheds_path(@project)
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
  	@watershed = Watershed.find(params[:id])
  	respond_to do |format|
      if @watershed.update_attributes(watershed_params)
      	@watersheds = @project.location.watersheds
        format.html { redirect_to project_watersheds_path(@project), notice: 'Watershed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @watershed.errors, status: :unprocessable_entity }
      end
    end
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
    watershed_scenarios_count(@watersheds)
	  params[:project_id] = @project.id
    respond_to do |format|
      format.html { redirect_to project_watersheds_path(@project) }
      format.json { head :no_content }
    end
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

  ################### Watershed Scenarios Count ##################
  #Returns number of watershed scenarios for UI buttons
  def watershed_scenarios_count(watersheds)
  	@watershed_results_count = 0
    @watershed_scenarios_count = 0
  	watersheds.each do |watershed|
  		@watershed_scenarios_count += watershed.watershed_scenarios.count
  		@watershed_results_count += watershed.annual_results.count
  	end
  end

  def download
  	@project = Project.find(params[:project_id])
    download_apex_files()
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def watershed_params
    params.require(:watershed).permit(:name, :location_id, :id, :created_at, :updated_at)
  end

  ####################### Copy Watershed ########################
  def copy_watershed
    msg = duplicate_watershed(params[:id], params[:location_id])
      @watersheds = Watershed.where(:location_id => @location.id)
      add_breadcrumb 'Watershed'
    render "index"
  end
end
