class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.json
  def index 
    @projects = Project.where(:user_id => params[:user_id])
    respond_to do |format|
      format.html   # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show   #selected when click on a project or a new project is created.
    if params[:id] == "upload" then 
		redirect_to "upload"
	end 
    session[:project_id] = params[:id]
    @location = Location.find_by_project_id(params[:id])
    redirect_to location_path(@location.id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def shows
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html { render action: "show" } # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
	session[:project_id] = @project.id
	@project.user_id = session[:user_id]
	@project.version = "NTTG3"
    respond_to do |format|
      if @project.save
		location = Location.new
		location.project_id = @project.id
		location.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to welcomes_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to welcomes_url }
      format.json { head :no_content }
    end
  end

  def upload 
	#nothing to do here. Just render the upload view
  end

	########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
	def upload_project
		@data = Hash.from_xml(params[:project].read)
		#step 1. save project information
			save_project_info
		#step 2. Save location information
			save_location_info
		#step 3. Save field information
			for i in 0..@data["Project"]["FieldInfo"].size-1
				save_field_info(i)
			end
		#step 4. Save Weather Information
			@projects = Project.where(:user_id => session[:user_id])
			render :action => "index"
	end

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def project_params
      params.require(:project).permit(:description, :name)
    end

	def save_project_info
		project = Project.new
		project.user_id = session[:user_id]
		project.name = @data["Project"]["StartInfo"]["projectName"]
		project.description = @data["Project"]["StartInfo"]["Description"]
		project.version = "NTTG3"
		project.save
		session[:project_id] = project.id
	end 

	def save_location_info
		location = Location.new
		location.project_id = session[:project_id]
		location.state_id = State.find_by_state_abbreviation(@data["Project"]["StartInfo"]["StateAbrev"]).id
		location.county_id = County.find_by_county_state_code(@data["Project"]["StartInfo"]["CountyCode"]).id
		location.status = @data["Project"]["StartInfo"]["Status"]
		location.coordinates = @data["Project"]["FarmInfo"]["Coordinates"]
		location.save
		session[:location_id] = location.id
	end

	def save_field_info(i)
		field = Field.new
		field.location_id = session[:location_id]
		field.field_name = @data["Project"]["FieldInfo"][i]["Name"]
		field.field_area = @data["Project"]["FieldInfo"][i]["Area"]
		field.field_average_slope = @data["Project"]["FieldInfo"][i]["AvgSlope"]
		field.field_type = @data["Project"]["FieldInfo"][i]["Forestry"]
		field.coordinates = @data["Project"]["FieldInfo"][i]["Coordinates"]
		field.save
		# Step 5. save Weather Info
		save_weather_info(field.id)
		for j in 0..@data["Project"]["FieldInfo"][i]["SoilInfo"].size-1
			save_soil_info(field.id, i, j)
		end
		for j in 0..@data["Project"]["FieldInfo"][i]["ScenarioInfo"].size-1
			scenario_id = save_scenario_info(field.id, i, j)
		end
	end

	def save_weather_info(field_id)
		weather = Weather.new
		weather.field_id = field_id
		weather.station_way =  @data["Project"]["StartInfo"]["StationWay"]
		weather.simulation_initial_year =  @data["Project"]["StartInfo"]["StationInitialYear"]
		weather.simulation_final_year =  @data["Project"]["StartInfo"]["StationFinalYear"]
		weather.simulation_final_year =  @data["Project"]["StartInfo"]["StationFinalYear"]
		weather.latitude =  @data["Project"]["StartInfo"]["WeatherLat"]
		weather.longitude =  @data["Project"]["StartInfo"]["WeatherLon"]
		weather.weather_file =  @data["Project"]["StartInfo"]["CurrentWeatherPath"]
		weather.way_id = Way.find_by_way_name(@data["Project"]["StartInfo"]["StationWay"]).id
		weather.save
	end

	def save_soil_info(field_id, i, j)
		soil = Soil.new
		soil.field_id = field_id
		soil.selected = false
		if @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Selected"] == "True" then
			soil.selected = true
		end
		soil.key = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Key"]
		soil.symbol = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Symbol"]
		soil.group = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Group"]
		soil.name = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Name"]
		soil.albedo = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Albedo"]
		soil.slope= @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Slope"]
		soil.percentage = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Area"]
		soil.drainage_type = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Wtmx"]
		soil.save
		for k in 0..@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"].size-1
			save_layer_info(soil.id, i, j, k)
		end
	end 

	def save_layer_infor(soil_id, i, j, k)
		layer = Layer.new
		layer.soil_id = soil_id
		layer.depth = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["Depth"]
		layer.soil_p=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["SoilP"]
		layer.bulk_density=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["BD"]
		layer.sand=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["Sand"]
		layer.silt=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["Silt"]
		layer.clay=100 - layer.sand - layer.silt
		layer.organic_matter=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["OM"]
		layer.ph=@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"][k]["PH"]
		layer.save
	end

	def save_scenario_info(field_id, i, j)
		scenario = Scenario.new
		scenario.field_id = field_id
		scenario.name = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Name"]
		scenario.save
		for k in 0..@data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"].size-1
			save_operation_info(scenario_id, i, j, k)
		end
		save_bmp_info(scenario_id, i, j)
		return scenario.id
	end

	def save_operation_info(scenario_id, i, j, k)
		operation = Operation.new
		operation.scenario_id = scenario_id
		operation.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexCrop"]
		operation.operation_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexOp"]
		operation.day = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Day"]
		operation.month_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Month"]
		operation.year = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Year"]
		operation.type_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j][""]
		operation.amount = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j][""]
		operation.depth = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j][""]
		operation.no3_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j]["NO3"]
		operation.po4_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j]["PO4"]
		operation.org_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j]["OrgN"]
		operation.org_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"]["Operations"][k][j]["OrgP"]
		operation.nh3 = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Nh3"]
	end

	def save_bmp_info(scenario_id, i, j)
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIType"] > 0 then
			save_bmp_ai(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFType"] > 0 then
			save_bmp_af(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["TileDrainDepth"] > 0 then
			save_bmp_td(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDWidth"] > 0 then
			save_bmp_ppnd(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSWidth"] > 0 then
			save_bmp_ppds(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEWidth"] > 0 then
			save_bmp_ppde(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWWidth"] > 0 then
			save_bmp_pptw(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WLArea"] > 0 then
			save_bmp_wl(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PndF"] > 0 then
			save_bmp_pnd(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFAnimals"] > 0 then
			save_bmp_sf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Sbs"] == "True" then
			save_bmp_sbs(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFArea"] > 0 then
			save_bmp_rf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSCrop"] > 0 then
			save_bmp_fs(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWCrop"] > 0 then
			save_bmp_ww(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCrop"] > 0 then
			save_bmp_cf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SlopeRed"] > 0 then
			save_bmp_ll(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Ts"] == "True" then
			save_bmp_ts(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMaximumTeperature"] > 0 or @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMinimumTeperature"] > 0 or @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcPrecipitation"] > 0 then
			save_bmp_cc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AoC"] == "True" then
			save_bmp_aoc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Gc"] == "True" then
			save_bmp_gc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Sa"] == "True" then
			save_bmp_sa(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgCrop"] > 0 then
			save_bmp_sdg(scenario_id, i, j)
		end
	end

	def save_bmp_ai(scneario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 1
		bmpsublist_id = 1
		bmp.irrigation_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIType"]
		bmp.water_stress_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIWaterStressFactor"]
		bmp.irrigation_efficiency = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIEff"]
		bmp.maximum_single_application = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIMaxSingleApp"]
		bmp.safety_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AISafetyFactor"]
		bmp.days = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIFreq"]
	end

	def save_bmp_af(scneario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 1
		bmpsublist_id = 2
		bmp.irrigation_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFType"]
		bmp.water_stress_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFWaterStressFactor"]
		bmp.irrigation_efficiency = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFEff"]
		bmp.maximum_single_application = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFMaxSingleApp"]
		bmp.safety_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFSafetyFactor"]
		bmp.days = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFFreq"]
	end

	def save_bmp_td(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 3
		bmp.depth = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["TileDrainDepth"]
	end

	def save_bmp_ppnd(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 4
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDSides"]		
	end 

	def save_bmp_ppds(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 5
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSSides"]		
	end 

	def save_bmp_ppde(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 6
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDESides"]		
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEResArea"]		
	end 

	def save_bmp_pptw(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 7
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWSides"]		
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWResArea"]		
	end 

	def save_bmp_wl(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 3
		bmpsublist_id = 8
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WLArea"]
	end 

	def save_bmp_pnd(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 3
		bmpsublist_id = 9
		bmp.no3_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PndF"]   # Because is a fraction
	end 

	def save_bmp_sf(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 10
		bmp.number_of_animals = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFAnimals"]   
		bmp.animal_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFCode"]   
		bmp.days = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFDays"]   
		bmp.hours = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFHours"]   
		bmp.dry_manure = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFDryManure"]
		bmp.no3_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFNo3"]
		bmp.po4_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFPo4"]
		bmp.org_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFOrgN"]
		bmp.org_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFOrgP"]
	end 

	def save_bmp_sbs(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 11
	end 

	def save_bmp_rf(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 12
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFArea"]
		bmp.grass_field_portion = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFGrassFieldPortion"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFWidth"]
	end 

	def save_bmp_fs(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 13
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSArea"]
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSCrop"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSWidth"]
	end 

	def save_bmp_ww(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 14
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWCrop"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWWidth"]
	end 

	def save_bmp_cb(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 5
		bmpsublist_id = 15
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCrop"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBBWidth"]
		bmp.crop_width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCWidth"]
	end 

	def save_bmp_ll(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 6
		bmpsublist_id = 16
		bmp.slope_reduction = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SlopeRed"]
	end 

	def save_bmp_ts(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 6
		bmpsublist_id = 17
	end 

	def save_bmp_cc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 7
		bmpsublist_id = 22
		bmp.difference_max_temperature = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMaximumTeperature"]
		bmp.difference_min_temperature = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMinimumTeperature"]
		bmp.difference_precipitation = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcPrecipitation"]
	end 

	def save_bmp_aoc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 23
	end 

	def save_bmp_gc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 24
	end 

	def save_bmp_sa(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 25
	end 

	def save_bmp_sdg(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 26
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgArea"]
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SggCrop"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgWidth"]
	end 
end
