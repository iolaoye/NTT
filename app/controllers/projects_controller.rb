class ProjectsController < ApplicationController
  require 'nokogiri'
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
		load_controls()
		load_parameters()
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
	location = Location.where(:project_id => params[:id])
	location.destroy_all unless location == []
    @project.destroy

    respond_to do |format|
      format.html { redirect_to welcomes_url }
      format.json { head :no_content }
    end
  end

	def record_not_found(exception)
	  render json: {error: exception.message}.to_json, status: 404
	  return
	end

	def error_occurred(exception)
	  render json: {error: exception.message}.to_json, status: 500
	  return
	end

  def upload 
	#nothing to do here. Just render the upload view
  end

	########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
	def upload_project
		@data = Hash.from_xml(params[:project].read)
		#@data = Nokogiri::XML(File.open(params[:project].path))
		#detect project version
		#todo check the name of the project. It should not exist.		
		msg = "OK"
		if (@data['Project'] == nil) then 
		    #new version
			#step 1. save project information
			msg = upload_project_new_version
			#step 2. Save location information
			msg = upload_location_new_version
			#step 3. Save field information
			@data["project"]["location"]["fields"].each do |f|
				#session[:depth] = f[1]["field_name"]
				msg = upload_field_new_version(f[1])
			end
			session[:depth] = msg
		elsif (@data["Project"]["StartInfo"]["StationWay"] != "Station")
		    #old version
			#step 1. save project information
			upload_project_info
			#step 2. Save location information
			upload_location_info
			#step 3. Save field information			
			for i in 0..@data["Project"]["FieldInfo"].size-1
				upload_field_info(i)
			end
			#step 4. Save Weather Information
		else
			redirect_to upload_project_path(0)
			flash[:notice] = "Unable to upload this file" and return false
		end  
		@projects = Project.where(:user_id => session[:user_id])
   	    render :action => "index", notice: msg
	end

	########################################### DOWNLOAD PROJECT FILE IN XML FORMAT ##################
	def download
	   #require 'open-uri'
	   #require 'net/http'
	   #require 'rubygems'

	   project = Project.find(params[:id])

	   builder = Nokogiri::XML::Builder.new do |xml|
			xml.project {
				#save project information
				xml.project_name project.name
				xml.project_description project.description
				xml.project_version project.version
				#save location information
				save_location_information(xml, params[:id])
			} # end xml.project
	   end   #builder do end

	   file_name = session[:session_id] + ".prj"
  	   path = File.join(DOWNLOAD, file_name)
	   content = builder.to_xml
	   File.open(path, "w") { |f| f.write(content)}
	   #file.write(content)
	   send_file path, :type=>"application/xml", :x_sendfile=>true
	end  #download project def end

	def save_location_information(xml, project_id)
		xml.location {
			#location information
			location = Location.find_by_project_id(project_id)
			xml.location_state_id location.state_id
			xml.location_county_id location.county_id
			xml.status location.status
			xml.coordinates location.coordinates
			xml.fields {
				fields = Field.where(:location_id => location.id)
				fields.each do |field|
					save_fields_information(xml, field)
				end #end fields.each				
			} # end xml.fields
		} #end xml.location
	end # end method

	def save_fields_information(xml, field)
		xml.field {
			#field information
			xml.field_name field.field_name
			xml.field_area field.field_area
			xml.field_average_slope field.field_average_slope
			xml.field_type field.field_type
			xml.coordinates field.coordinates
			weather = Weather.find_by_field_id(field.id)
			save_weather_information(xml, weather)
			site = Site.find_by_field_id(field.id)
			save_site_info(xml, site)
			soils = Soil.where(:field_id => field.id)
			xml.soils {
				soils.each do |soil|
					save_soil_information(xml, soil)		
				end # end soils.each
			} #end xml.soils					

			#scenarios and operations information
			scenarios = Scenario.where(:field_id => field.id)
			xml.scenarios{
				scenarios.each do |scenario|
					save_scenario_information(xml, scenario)		
				end # end scenarios.each
			} #end xml.scenarios					
		} # end field info
	end # end method

	def save_weather_information(xml, weather)
		xml.weather {
			xml.station_way weather.station_way
			xml.simulation_initial_year weather.simulation_initial_year
			xml.simulation_final_year weather.simulation_final_year
			xml.weather_longitude weather.longitude
			xml.weather_latitude weather.latitude
			xml.weather_file weather.weather_file 
			xml.way_id weather.way_id
			xml.weather_initial_year weather.simulation_initial_year
			xml.weather_final_year weather.simulation_final_year
		}  #weather info end
	end # end method

	def save_site_info(xml, site)
		xml.site {
			xml.apm site.apm
			xml.co2x site.co2x
			xml.cqnx site.cqnx
			xml.elev site.elev
			xml.fir0 site.fir0
			xml.rfnx site.rfnx
			xml.unr site.unr
			xml.upr site.upr
			xml.xlog site.xlog
			xml.ylat site.ylat
		} # end xml.site
	end  #site method

	def save_soil_information(xml, soil)						
		#soils and layers information
		xml.soil {
			xml.selected soil.selected
			xml.key soil.key
			xml.symbol soil.symbol
			xml.group soil.group
			xml.name soil.name
			xml.albedo soil.albedo
			xml.slope soil.slope
			xml.percentage soil.percentage
			xml.drainage_type soil.drainage_type
			xml.ffc soil.ffc
			xml.wtmn soil.wtmn
			xml.wtmx soil.wtmx
			xml.wtbl soil.wtbl
			xml.gwst soil.gwst
			xml.gwmx soil.gwmx
			xml.rft soil.rft
			xml.rfpk soil.rfpk
			xml.tsla soil.tsla
			xml.xids soil.xids
			xml.rtn1 soil.rtn1
			xml.xidk soil.xidk
			xml.zqt soil.zqt
			xml.zf soil.zf
			xml.ztk soil.ztk
			xml.fbm soil.fbm
			xml.fhp soil.fhp
			layers = Layer.where(:soil_id => soil.id)
			xml.layers {
				layers.each do |layer|
					save_layer_information(xml, layer)
				end # end layers.each
			} # end xml.layers
		} # end xml.soil
	end # end method

	def save_layer_information(xml, layer)
		xml.layer {
			xml.depth layer.depth
			xml.soilp layer.soil_p
			xml.bd layer.bulk_density
			xml.sand layer.sand
			xml.silt layer.silt
			xml.clay layer.clay
			xml.om layer.organic_matter
			xml.ph layer.ph
		} # layer xml
	end  # end layer method

	def save_scenario_information(xml, scenario)
		xml.scenario {
			xml.name scenario.name
			operations = Operation.where(:scenario_id => scenario.id)
			xml.operations {
				operations.each do |operation|
					save_operation_information(xml, operation)
				end # end operation.each
			} #end xml.operations

			bmps = Bmp.where(:scenario_id => scenario.id)
			xml.bmps {
				bmps.each do |bmp|
					save_bmp_information(xml, bmp)
				end # end bmps.each
			} # end xml.bmp operation
		} # end xml.scenario
	end #end scenarionmethod

	def save_operation_information(xml, operation)
		xml.operation {
			xml.crop_id operation.crop_id
			xml.activity_id operation.activity_id
			xml.day operation.day
			xml.month operation.month_id
			xml.year operation.year
			xml.type_id operation.type_id
			xml.amout operation.amount
			xml.depth operation.depth
			xml.no3_n operation.no3_n
			xml.po4_p operation.po4_p
			xml.org_n operation.org_n
			xml.org_p operation.org_p
			xml.nh3 operation.nh3
			xml.subtype_id operation.subtype_id
		} # xml each operation end
	end # end method

	def save_bmp_information(xml, bmp)
		xml.bmp {
			xml.bmp_id bmp.bmp_id
			xml.crop_id bmp.crop_id
			xml.irrigation_id bmp.irrigation_id
			xml.water_stress_factor bmp.water_stress_factor
			xml.irrigation_efficiency bmp.irrigation_efficiency
			xml.maximum_single_application bmp.maximum_single_application
			xml.safety_factor bmp.safety_factor
			xml.depth bmp.depth
			xml.area bmp.area
			xml.number_of_animals bmp.number_of_animals
			xml.days bmp.days
			xml.hours bmp.hours
			xml.animal_id bmp.animal_id
			xml.dry_manure bmp.dry_manure
			xml.no3_n bmp.no3_n
			xml.po4_p bmp.po4_p
			xml.org_n bmp.org_n
			xml.org_p bmp.org_p
			xml.width bmp.width
			xml.grass_field_portion bmp.grass_field_portion
			xml.buffer_slope_upland bmp.buffer_slope_upland
			xml.crop_width bmp.crop_width
			xml.slope_reduction bmp.slope_reduction
			xml.sides bmp.sides
			xml.name bmp.name
			xml.bmpsublist_id bmp.bmpsublist_id
			xml.difference_max_temperature bmp.difference_max_temperature
			xml.difference_min_temperature bmp.difference_min_temperature
			xml.difference_precipitation bmp.difference_precipitation
		} # xml bmp end
	end # end method

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def project_params
      params.require(:project).permit(:description, :name)
    end

	def upload_project_info
		project = Project.new
		project.user_id = session[:user_id]
		project.name = @data["Project"]["StartInfo"]["projectName"]
		project.description = @data["Project"]["StartInfo"]["Description"]
		project.version = "NTTG3"
		project.save
		session[:project_id] = project.id
	end 

	def upload_project_new_version
		project = Project.new
		project.user_id = session[:user_id]
		project.name = @data["project"]["project_name"]
		project.description = @data["project"]["project_description"]
		project.version = "NTTG3"
		if project.save
			session[:project_id] = project.id
			return "OK"
		else
			return "project could not be saved"
		end
	end 

	def upload_location_info
		location = Location.new
		location.project_id = session[:project_id]
		location.state_id = State.find_by_state_abbreviation(@data["Project"]["StartInfo"]["StateAbrev"]).id
		if !((@data["Project"]["StartInfo"]["CountyCode"]) == nil) then 
			location.county_id = County.find_by_county_state_code(@data["Project"]["StartInfo"]["CountyCode"]).id
		end
		location.status = @data["Project"]["StartInfo"]["Status"]
		location.coordinates = @data["Project"]["FarmInfo"]["Coordinates"]
		location.save
		session[:location_id] = location.id
	end

	def upload_location_new_version
		location = Location.new
		location.project_id = session[:project_id]
		location.state_id = @data["project"]["location"]["location_state_id"]
		location.county_id = @data["project"]["location"]["location_county_id"]
		location.status = @data["project"]["location"]["status"]
		location.coordinates = @data["project"]["location"]["coordinates"]
		if location.save
			session[:location_id] = location.id
			return "OK"
		else
			return "location could not be saved"
		end
	end

	def upload_field_info(i)
		field = Field.new
		field.location_id = session[:location_id]
		field.field_name = @data["Project"]["FieldInfo"][i]["Name"]
		field.field_area = @data["Project"]["FieldInfo"][i]["Area"]
		field.field_average_slope = @data["Project"]["FieldInfo"][i]["AvgSlope"]
		field.field_type = @data["Project"]["FieldInfo"][i]["Forestry"]
		field.coordinates = @data["Project"]["FieldInfo"][i]["Coordinates"]
		field.save
		# Step 5. save Weather Info
		upload_weather_info(field.id)
		# Step 6. save soil, layers, subareas, soil_operations information
		for k in 0..@data["Project"]["FieldInfo"][i]["SoilInfo"].size-1
			upload_soil_info(field.id, i, k)
		end
		# Ste p 7. save scenarios, operations, bmps information
		for j in 0..@data["Project"]["FieldInfo"][i]["ScenarioInfo"].size-1
			scenario_id = upload_scenario_info(field.id, i, j)
		end
	end

	def upload_field_new_version(new_field)
		field = Field.new
		field.location_id = session[:location_id]
		field.field_name = new_field["field_name"]
		field.field_area = new_field["field_area"]
		field.field_average_slope = new_field["field_average_slope"]
		field.field_type = new_field["field_type"]
		field.coordinates = new_field["coordinates"]
		if field.save then
			session[:field_id] = field.id
		else
			return e
			#return "field could not be saved"
		end
		 
		# Step 5. save Weather and Site Info
		msg = upload_weather_new_version(field.id, new_field)
		if msg != "OK" then
			return msg
		end
		msg = upload_site_new_version(field.id, new_field)
		if msg != "OK" then
			return msg
		end

		new_field["soils"].each do |s|
			session[:depth] = s[1]["field_name"]
			msg = upload_soil_new_version(field.id, s[1])
			if msg != "OK" then
				return msg
			end
		end

		new_field["scenarios"].each do |sc|
			scenario_id = upload_scenario_new_version(field.id, sc)
			if scenario_id == nil then
				return "scenario could not be saved"
			end
		end
		return "OK"
	end

	def upload_weather_info(field_id)
		weather = Weather.new
		weather.field_id = field_id
		weather.station_way = @data["Project"]["StartInfo"]["StationWay"]
		weather.simulation_initial_year = @data["Project"]["StartInfo"]["StationInitialYear"]
		weather.simulation_final_year = @data["Project"]["StartInfo"]["StationFinalYear"]
		weather.weather_initial_year = @data["Project"]["StartInfo"]["WeatherInitialYear"]
		weather.weather_final_year = @data["Project"]["StartInfo"]["WeatherFinalYear"]
		weather.latitude = @data["Project"]["StartInfo"]["WeatherLat"]
		weather.longitude = @data["Project"]["StartInfo"]["WeatherLon"]
		weather.weather_file = @data["Project"]["StartInfo"]["CurrentWeatherPath"]
		weather.way_id = Way.find_by_way_value(@data["Project"]["StartInfo"]["StationWay"]).id
		weather.save
	end

	def upload_weather_new_version(field_id, field)
		weather = Weather.new
		weather.field_id = field_id
		weather.station_way = field["weather"]["station_way"]
		weather.simulation_initial_year = field["weather"]["simulation_initial_year"]
		weather.simulation_final_year = field["weather"]["simulation_final_year"]
		weather.latitude = field["weather"]["weather_latitude"]
		weather.longitude = field["weather"]["weather_longitude"]
		weather.weather_file = field["weather"]["weather_file"]
		weather.way_id = field["weather"]["way_id"]
		if weather.save then
			return "OK"
		else
			return "weather could not be saved"
		end
	end

	def upload_site_new_version(field_id, field)
		site = Site.new
		site.field_id = field_id
		site.apm = field["site"]["apm"]
		site.co2x = field["site"]["co2x"]
		site.cqnx = field["site"]["cqnx"]
		site.elev = field["site"]["elev"]
		site.fir0 = field["site"]["fir0"]
		site.rfnx = field["site"]["rfnx"]
		site.unr = field["site"]["unr"]
		site.upr = field["site"]["upr"]
		site.xlog = field["site"]["xlog"]
		site.ylat = field["site"]["ylat"]
		if site.save then
			return "OK"
		else
			return "site could not be saved"
		end
	end

	def upload_soil_info(field_id, i, j)
		soil = Soil.new
		soil.field_id = field_id
		soil.selected = false
		soil.symbol = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Symbol"]
		soil.key = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Key"]
		if (@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Selected"] == "True") then
			soil.selected = true
		end
		soil.group = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Group"]
		soil.name = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Name"]
		soil.albedo = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Albedo"]
		soil.slope= @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Slope"]
		soil.percentage = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Area"]
		soil.drainage_type = @data["Project"]["FieldInfo"][i]["SoilInfo"][j]["Wtmx"]
		soil.save
		for k in 0..@data["Project"]["FieldInfo"][i]["SoilInfo"][j]["LayerInfo"].size-1
			upload_layer_info(soil.id, i, j, k)
		end
	end

	def upload_soil_new_version(field_id, new_soil)
		soil = Soil.new
		soil.field_id = field_id
		soil.selected = false
		soil.key = new_soil["key"]
		soil.symbol = new_soil["symbol"]
		if (new_soil["selected"] == "true")
			soil.selected = true
		end
		soil.group = new_soil["group"]
		soil.name = new_soil["name"]
		soil.albedo = new_soil["albedo"]
		soil.slope = new_soil["slope"]
		soil.percentage = new_soil["percentage"]
		soil.drainage_type = new_soil["drainage_type"]
		if !soil.save then
			return "Soil could not be saved"
		end
	
		new_soil["layers"].each do |l|
			return upload_layer_new_version(soil.id, l[1])
		end
	end 

	def upload_layer_info(soil_id, i, j, k)
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

	def upload_layer_new_version(soil_id, new_layer)
		layer = Layer.new
		layer.soil_id = soil_id
		layer.depth = new_layer["depth"]
		layer.soil_p = new_layer["soilp"]
		layer.bulk_density = new_layer["bd"]
		layer.sand = new_layer["sand"]
		layer.silt = new_layer["silt"]
		layer.clay = new_layer["clay"]
		layer.organic_matter = new_layer["om"]
		layer.ph = new_layer["ph"]
		if layer.save then
			return "OK"
		else
			return "layers could not be saved"
		end 
	end

	def upload_scenario_info(field_id, i, j)
		scenario = Scenario.new
		scenario.field_id = field_id
		scenario.name = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Name"]
		scenario.save
		#array is nil so calling size method on it throws nomethoderror
		#test in console w/tutorial: https://www.58bits.com/blog/2012/06/13/getting-started-nokogiri-xml-ruby
		for k in 0..@data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"].size-1
			upload_operation_info(scenario.id, i, j, k)
		end
		upload_bmp_info(scenario.id, i, j)
		return scenario.id
	end

	def upload_scenario_new_version(field_id, new_scenario)
		scenario = Scenario.new
		scenario.field_id = field_id
		scenario.name = new_scenario["name"]
		if !scenario.save then
			return "scenario could not be save"
		end

		new_scenario["operations"].each do |o|
			msg = upload_operation_new_version(scenario.id, o)
			if msg != "OK" then
				return msg
			end
		end
		upload_bmp_info_new_version(scenario.id, field, j)
		return scenario.id
	end

	def upload_operation_info(scenario_id, i, j, k)
		operation = Operation.new
		operation.scenario_id = scenario_id
		operation.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexCrop"]
		operation.activity_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexOp"]
		operation.day = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Day"]
		operation.month_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Month"]
		operation.year = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Year"]
		operation.type_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexTillCode"]
		operation.subtype_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexFert"]
		operation.amount = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexOpv1"]
		operation.depth = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["ApexOpv1"]
		operation.no3_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["NO3"]
		operation.po4_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["PO4"]
		operation.org_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["OrgN"]
		operation.org_p = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["OrgP"]
		operation.nh3 = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Operations"][k]["Nh3"]
	end

	def upload_operation_new_version(scenario_id, new_operation)
		operation = Operation.new
		operation.scenario_id = scenario_id
		operation.crop_id = operation["crop_id"]
		operation.activity_id = operation["activity_id"]
		operation.day = operation["day"]
		operation.month_id = operation["month"]
		operation.year = operation["year"]
		operation.type_id = operation["type_id"]
		operation.subtype_id = operation["subtype_id"]
		operation.amount = operation["amout"] #typo in xml generated file
		operation.depth = operation["depth"]
		operation.no3_n = operation["no3_n"]
		operation.po4_p = operation["po4_p"]
		operation.org_n = operation["org_n"]
		operation.org_p = operation["org_p"]
		operation.nh3 = operation["nh3"]
		if operation.save then
			return "OK"
		else
			return "operation could ot be saved"
		end
	end

	def upload_bmp_info(scenario_id, i, j)
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIType"].to_i > 0 then
			upload_bmp_ai(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AFType"].to_i > 0 then
			upload_bmp_af(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["TileDrainDepth"].to_f > 0 then
			upload_bmp_td(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDWidth"].to_f > 0 then
			upload_bmp_ppnd(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSWidth"].to_f > 0 then
			upload_bmp_ppds(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEWidth"].to_f > 0 then
			upload_bmp_ppde(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWWidth"].to_f > 0 then
			upload_bmp_pptw(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WLArea"].to_f > 0 then
			upload_bmp_wl(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PndF"].to_f > 0 then
			upload_bmp_pnd(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SFAnimals"].to_i > 0 then
			upload_bmp_sf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Sbs"] == "True" then
			upload_bmp_sbs(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFArea"].to_f > 0 then
			upload_bmp_rf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSCrop"].to_i > 0 then
			upload_bmp_fs(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWCrop"].to_i > 0 then
			upload_bmp_ww(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCrop"].to_i > 0 then
			upload_bmp_cf(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SlopeRed"].to_f > 0 then
			upload_bmp_ll(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Ts"] == "True" then
			upload_bmp_ts(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMaximumTeperature"].to_f > 0 or @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMinimumTeperature"].to_f > 0 or @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcPrecipitation"].to_f > 0 then
			upload_bmp_cc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AoC"] == "True" then
			upload_bmp_aoc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Gc"] == "True" then
			upload_bmp_gc(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["Sa"] == "True" then
			upload_bmp_sa(scenario_id, i, j)
		end
		if @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgCrop"].to_i > 0 then
			upload_bmp_sdg(scenario_id, i, j)
		end
	end

	def upload_bmp_info_new_version(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["bmp_id"]
		bmp.bmpsublist_id = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["bmpsublist_id"]
		bmp.crop_id = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["crop_id"]
		bmp.irrigation_id = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["irrigation_id"]
		bmp.water_stress_factor = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["water_stress_factor"]
		bmp.irrigation_efficiency = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["irrigation_efficiency"]
		bmp.maximum_single_application = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["maximum_single_application"]
		bmp.safety_factor = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["safety_factor"]
		bmp.depth = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["depth"]
		bmp.area = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["area"]
		bmp.number_of_animals = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["number_of_animals"]
		bmp.days = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["days"]
		bmp.hours = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["hours"]
		bmp.animal_id = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["animal_id"]
		bmp.dry_manure = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["dry_manure"]
		bmp.no3_n = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["no3_n"]
		bmp.po4_p = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["po4_p"]
		bmp.org_n = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["org_n"]
		bmp.width = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["width"]
		bmp.grass_field_portion = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["grass_field_portion"]
		bmp.buffer_slope_upland = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["buffer_slope_upland"]
		bmp.crop_width = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["crop_width"]
		bmp.slope_reduction = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["slope_reduction"]
		bmp.sides = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["sides"]
		bmp.name = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["name"]
		bmp.difference_max_temperature = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["difference_max_temperature"]
		bmp.difference_min_temperature = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["difference_min_temperature"]
		bmp.difference_precipitation = @data["project"]["fields"][i]["scenarios"][j]["bmps"]["difference_precipitation"]
	end

	def upload_bmp_ai(scneario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 1
		bmp.bmpsublist_id = 1
		bmp.irrigation_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIType"]
		bmp.water_stress_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIWaterStressFactor"]
		bmp.irrigation_efficiency = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIEff"]
		bmp.maximum_single_application = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIMaxSingleApp"]
		bmp.safety_factor = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AISafetyFactor"]
		bmp.days = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["AIFreq"]
	end

	def upload_bmp_af(scneario_id, i, j)
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

	def upload_bmp_td(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 3
		bmp.depth = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["TileDrainDepth"]
	end

	def upload_bmp_ppnd(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 4
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPNDSides"]		
	end 

	def upload_bmp_ppds(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 5
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDSSides"]		
	end 

	def upload_bmp_ppde(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 6
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDESides"]		
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPDEResArea"]		
	end 

	def upload_bmp_pptw(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 2
		bmpsublist_id = 7
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWWidth"]
		bmp.sides = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWSides"]		
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PPTWResArea"]		
	end 

	def upload_bmp_wl(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 3
		bmpsublist_id = 8
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WLArea"]
	end 

	def upload_bmp_pnd(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 3
		bmpsublist_id = 9
		bmp.no3_n = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["PndF"]   # Because is a fraction
	end 

	def upload_bmp_sf(scenario_id, i, j)
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

	def upload_bmp_sbs(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 11
	end 

	def upload_bmp_rf(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 12
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFArea"]
		bmp.grass_field_portion = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFGrassFieldPortion"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["RFWidth"]
	end 

	def upload_bmp_fs(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 13
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSArea"]
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSCrop"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["FSWidth"]
	end 

	def upload_bmp_ww(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 4
		bmpsublist_id = 14
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWCrop"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["WWWidth"]
	end 

	def upload_bmp_cb(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 5
		bmpsublist_id = 15
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCrop"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBBWidth"]
		bmp.crop_width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CBCWidth"]
	end 

	def upload_bmp_ll(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 6
		bmpsublist_id = 16
		bmp.slope_reduction = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SlopeRed"]
	end 

	def upload_bmp_ts(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 6
		bmpsublist_id = 17
	end 

	def upload_bmp_cc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 7
		bmpsublist_id = 22
		bmp.difference_max_temperature = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMaximumTeperature"]
		bmp.difference_min_temperature = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcMinimumTeperature"]
		bmp.difference_precipitation = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["CcPrecipitation"]
	end 

	def upload_bmp_aoc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 23
	end 

	def upload_bmp_gc(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 24
	end 

	def upload_bmp_sa(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 25
	end 

	def upload_bmp_sdg(scenario_id, i, j)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		bmp.bmp_id = 8
		bmpsublist_id = 26
		bmp.area = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgArea"]
		bmp.crop_id = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SggCrop"]
		bmp.buffer_slope_upland = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgslopeRatio"]
		bmp.width = @data["Project"]["FieldInfo"][i]["ScenarioInfo"][j]["Bmps"]["SdgWidth"]
	end
	#todo move this two methods to fields or location when the state is known. Also update years of simulation + initialyear in weather
	def load_controls()
		Control.all.each do |c|
			apex_control = ApexControl.new
			apex_control.control_id = c.id
			apex_control.value = c.default_value
			apex_control.project_id = @project.id
			apex_control.save
		end
	end

	def load_parameters()
		Parameter.all.each do |c|
			apex_parameter = ApexParameter.new
			apex_parameter.parameter_id = c.id
			apex_parameter.value = c.default_value
			apex_parameter.project_id = @project.id
			apex_parameter.save
		end
	end
end
