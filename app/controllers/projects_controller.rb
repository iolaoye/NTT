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

  	#def record_not_found(exception)
	#  render json: {error: exception.message}.to_json, status: 404
	#  return
	#end

	#def error_occurred(exception)
	#  render json: {error: exception.message}.to_json, status: 500
	#  return
	#end

  def upload 
	#nothing to do here. Just render the upload view
  end

  ########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
	def upload_project
		@data = Nokogiri::XML(params[:project])
		@data.root.elements.each do |node|
			case node.name
				when "project"  #appears to return false, thus goes to else
					msg = upload_project_new_version(node)
				when "location"
					msg = upload_location_new_version(node)
				when "StartInfo"
					msg = upload_project_info(node)
				when "FarmInfo"
					msg = upload_location_info1(node)	
				when "FieldInfo"
					msg = upload_field_info(node)		
			end
		end
		# summarizes results for totals and soils.
		summarize_total()

		#todo check the name of the project. It should not exist.		
		msg = "OK"
		if (@data['Project'] == nil) then 
		    #new version
			#step 1. save project information
			#msg = upload_project_new_version
			#step 2. Save location information
			#msg = upload_location_new_version
			#step 3. Save field information
			#@data["project"]["location"]["fields"].each do |f|
				
			#	msg = upload_field_new_version(f["field"])
			#end
		elsif (@data["Project"]["StartInfo"]["StationWay"] != "Station")
		    #old version
			#step 1. save project information
			#upload_project_info
			#step 2. Save location information
			#upload_location_info
			#step 3. Save field information			
			#for i in 0..@data["Project"]["FieldInfo"].size-1
			#	upload_field_info(i)
			#end
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
	     xml.projects {
			xml.project {
				#save project information
				xml.project_name project.name
				xml.project_description project.description
				xml.project_version project.version
			} # end xml.project
			#save location information
			save_location_information(xml, params[:id])
		} # end xml.projects
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
			xml.state_id location.state_id
			xml.county_id location.county_id
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
			xml.longitude weather.longitude
			xml.latitude weather.latitude
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

			soil_operations = SoilOperation.where(:scenario_id => scenario.id)
			xml.soil_operations {
				soil_operations.each do |so|
					save_soil_operation_information(xml, so)
				end # end soil_operations.each
			} # end xml.soil_operations

			subareas = Subarea.where(:scenario_id => scenario.id)
			xml.subareas {
				subareas.each do |sa|
					save_subarea_information(xml, sa)
				end # end subarea.each
			} # end xml.subareas

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

	def save_soil_operation_information(xml, soil_operation)
		xml.soil_operation {
			xml.apex_crop soil_operation.apex_crop
			xml.opv1 soil_operation.opv1
			xml.opv2 soil_operation.opv2
			xml.opv3 soil_operation.opv3
			xml.opv4 soil_operation.opv4
			xml.opv5 soil_operation.opv5
			xml.opv6 soil_operation.opv6
			xml.opv7 soil_operation.opv7
			xml.activity_id soil_operation.activity_id
			xml.year soil_operation.year
			xml.month soil_operation.month
			xml.day soil_operation.day
			xml.operation_id soil_operation.operation_id
			xml.type_id soil_operation.type_id
			xml.scenario_id soil_operation.soil_id
			xml.apex_operation soil_operation.apex_operation
		} # xml each soil_operation end
	end # end method

	def save_subarea_information(xml, subarea)
		xml.subarea {
			xml.type subarea.type
			xml.description subarea.description
			xml.number subarea.number
			xml.inps subarea.inps
			xml.iops subarea.iops
			xml.iow subarea.iow
			xml.ii subarea.ii
			xml.iapl subarea.iapl
			xml.nvcn subarea.nvcn
			xml.iwth subarea.iwth
			xml.ipts subarea.ipts
			xml.isao subarea.isao
			xml.luns subarea.luns
			xml.imw subarea.imw
			xml.sno subarea.sno
			xml.stdo subarea.stdo
			xml.yct subarea.yct
			xml.xct subarea.xct
			xml.azm subarea.azm
			xml.fl subarea.fl
			xml.angl subarea.angl
			xml.wsa subarea.wsa
			xml.chl subarea.chl
			xml.chd subarea.chd
			xml.chs subarea.chs
			xml.chn subarea.chn
			xml.slp subarea.slp
			xml.splg subarea.splg
			xml.upn subarea.upn
			xml.ffpq subarea.ffpq
			xml.urbf subarea.urbf
			xml.soil_id subarea.soil_id
			xml.bmp_id subarea.bmp_id
			xml.scenario_id subarea.scenario_id
		} # xml each subarea end
	end # end method

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def project_params
      params.require(:project).permit(:description, :name)
    end

	def upload_project_info(node)
		project = Project.new
		project.user_id = session[:user_id]
		node.elements.each do |p|
			case p.name
				when "projectName" 
					project.name = p.text
				when "Description"
					project.description = p.text					
			end
		end
		project.version = "NTTG3"
		if project.save then
			session[:project_id] = project.id
			upload_location_info(node)
			upload_weather_info(node)
			return "OK"
		else
			return "Error saving project"
		end
	end 

	def upload_project_new_version(node)
		project = Project.new
		project.user_id = session[:user_id]
		node.elements.each do |p|
			case p.name
				when "project_name" #no value receieved/saved
					project.name = p.text
				when "project_description"
					project.description = p.text					
			end
		end
		project.version = "NTTG3"
		if project.save
			session[:project_id] = project.id
			return "OK"
		else
			return "project could not be saved"
		end
	end 

	def upload_location_info(node)
		location = Location.new
		location.project_id = session[:project_id]
		node.elements.each do |p|
			case p.name
				when "StateAbrev"
					state_id = State.find_by_state_abbreviation(p.text).id
					location.state_id = state_id
				when "CountyCode"
					county_id = County.find_by_county_state_code(p.text).id
					location.county_id = county_id
				when "Status"
					location.status = p.text
			end
		end
		if location.save
			session[:location_id] = location.id
		else
			return "location could not be saved"
		end
	end

	def upload_location_info1(node)
		location = Location.find(session[:location_id])
		node.elements.each do |p|
			case p.name
				when "Coordinates"
					location.coordinates = p.text
			end
		end
		location.save
	end

	def upload_location_new_version(node)
		msg = "OK"
		location = Location.new
		location.project_id = session[:project_id]
		node.elements.each do |p|
			case p.name
				when "state_id"
					location.state_id = p.text
				when "county_id"
					location.county_id = p.text					
				when "status"
					location.status = p.text					
				when "coordinates"
					location.coordinates = p.text
				when "fields"
					if location.save
						session[:location_id] = location.id
						p.elements.each do |f|
							msg = upload_field_new_version(f)				
						end
					else
						return "location could not be saved"
					end
			end
		end
	end

	def upload_field_info(node)
		field = Field.new
		field.location_id = session[:location_id]
		node.elements.each do |p|
			case p.name
				when "Forestry"
					if p.text == "True" then
						field.field_type = true
					else
						field.field_type = false
					end
				when "Name"
					field.field_name = p.text					
				when "Area"
					field.field_area = p.text					
				when "AvgSlope"
					field.field_average_slope = p.text
				when "Coordinates"
					field.coordinates = p.text
				when "SoilInfo"
					field.save
					upload_soil_info(p, field.id)
				when "ScenarioInfo"
					upload_scenario_info(p, field.id)
			end
		end

		field.save
		# save Weather Info
		weather = Weather.new
		weather.field_id = field.id
		weather.simulation_initial_year = @weather["simulation_initial_year"] 
		weather.simulation_final_year = @weather["simulation_final_year"]
		weather.weather_initial_year = @weather["weather_initial_year"]
		weather.weather_final_year = @weather["weather_final_year"]
		weather.latitude = @weather["latitude"]
		weather.longitude = @weather["longitude"]
		weather.weather_file = @weather["weather_file"]
		weather.way_id = @weather["way_id"]		
		weather.save
	end

	def upload_field_new_version(node)
		field = Field.new
		field.location_id = session[:location_id]
		node.elements.each do |p|
			case p.name
				when "field_name"
					field.field_name = p.text
				when "field_area"
					field.field_area = p.text
				when "field_average_slope"
					field.field_average_slope = p.text
				when "field_type"
					field.field_type = p.text
				when "coordinates"
					field.coordinates = p.text
					if field.save! then
						session[:field_id] = field.id
					else
						return "field could not be saved"
					end
				when "weather"
					msg = upload_weather_new_version(p, field.id)
				when "site"
					msg = upload_site_new_version(p, field.id)
				when "soils"
					p.elements.each do |f|
						msg = upload_soil_new_version(field.id, f)
					end
				when "scenarios"
					p.elements.each do |f|
						scenario_id = upload_scenario_new_version(field.id, f)
						if scenario_id == nil then
							return "scenario could not be saved"
						end
					end
			end
		end	 
		return "OK"
	end

	def upload_weather_info(node)
		#create hash to keep for the whole upload. Each field is going to have the same wather.
		@weather = Hash.new
		@weather["station_way"] = "map"
		#weather.field_id = field_id todo has to take field when field is created later.
		node.elements.each do |p|
			case p.name
				when "StationInitialYear"
					@weather["simulation_initial_year"] = p.text
				when "StationFinalYear"
					@weather["simulation_final_year"] = p.text
				when "WeatherInitialYear"
					@weather["weather_initial_year"] = p.text
				when "WeatherFinalYear"
					@weather["weather_final_year"] = p.text
				when "WeatherLat"
					@weather["latitude"] = p.text
				when "WeatherLon"
					@weather["longitude"] = p.text
				when "CurrentWeatherPath"
					file_name = p.text.split(/\N/)
					@weather["weather_file"] = file_name[1]
				when "StationWay"
					way_id = Way.find_by_way_value(p.text).id		
					@weather["way_id"] = way_id
			end
		end
		return "OK"
	end

	def upload_weather_new_version(node, field_id)
		weather = Weather.new
		weather.field_id = field_id
		node.elements.each do |p|
			case p.name
				when "station_way"
					weather.station_way = p.text
				when "simulation_initial_year"
					weather.simulation_initial_year = p.text
				when "simulation_final_year"
					weather.simulation_final_year = p.text
				when "weather_initial_year"
					weather.weather_initial_year = p.text
				when "weather_final_year"
					weather.weather_final_year = p.text
				when "latitude"
					weather.latitude = p.text
				when "longitude"
					weather.longitude = p.text
				when "weather_file"
					weather.weather_file = p.text
				when "way_id"
					weather.way_id = p.text
			end
		end
		if weather.save then
			return "OK"
		else
			return "weather could not be saved"
		end
	end

	def upload_site_new_version(node, field_id)
		site = Site.new
		site.field_id = field_id
		node.elements.each do |p|
			case p.name
				when "apm"
					site.apm = p.text
				when "co2x"
					site.co2x = p.text
				when "cqnx"
					site.cqnx = p.text
				when "elev"
					site.elev = p.text
				when "fir0"
					site.fir0 = p.text
				when "rfnx"
					site.rfnx = p.text
				when "unr"
					site.unr = p.text
				when "upr"
					site.upr = p.text
				when "xlog"
					site.xlog = p.text
				when "ylat"
					site.ylat = p.text
			end
		end
		if site.save then
			return "OK"
		else
			return "site could not be saved"
		end
	end

	def upload_soil_info(node, field_id)
		soil = Soil.new
		soil.field_id = field_id
		soil.selected = false
		node.elements.each do |p|
			case p.name
				when "Selected"
					if p.text == "True" then
						soil.selected = true
					end
				when "Key"
					soil.key = p.text
				when "Symbol"
					soil.symbol = p.text
				when "Group"
					soil.group = p.text
				when "Name"
					soil.name = p.text
				when "Albedo"
					soil.albedo = p.text
				when "Slope"
					soil.slope = p.text
				when "Area"
					soil.percentage = p.text
				when "Ffc"
					soil.ffc = p.text
				when "Wtmn"
					soil.wtmn = p.text
				when "Wtmx"
					soil.wtmx = p.text
					soil.drainage_type = p.text
				when "Wtbl"
					soil.wtbl= p.text
				when "Gwst"
					soil.gwst = p.text
				when "Gwmx"
					soil.gwmx = p.text
				when "Rftt"
					soil.rft = p.text
				when "Rfpk"
					soil.rfpk = p.text
				when "tsla"
					soil.tsla= p.text
				when "xids"
					soil.xids = p.text
				when "Rtn1"
					soil.rtn1 = p.text
				when "Xidk"
					soil.xidk = p.text
				when "Zqt"
					soil.zqt = p.text
				when "Zf"
					soil.zf = p.text
				when "Ztk"
					soil.ztk = p.text
				when "Fbm"
					soil.fbm = p.text
				when "Fhp"
					soil.fhp = p.text
				when "LayerInfo"
					if soil.save then
						upload_layer_info(p, soil.id)
					else
						return "Error uploading soils"
					end
				when "SoilScenarioInfo"
					if soil.save then
						upload_soil_scenario_info(p, soil.field_id, soil.id)
					else
						return "Error uploading "
					end
			end
		end
	end

	def upload_soil_new_version(field_id, node)
		soil = Soil.new
		soil.field_id = field_id
		soil.selected = false
		node.elements.each do |p|
			case p.name
				when "key"
					soil.key = p.text
				when "symbol"
					soil.symbol = p.text
				when "selected"
					if p.text == "true"
						soil.selected = true
					end
				when "group"
					soil.group = p.text
				when "name"	
					soil.name = p.text
				when "albedo"
					soil.albedo = p.text
				when "slope"
					soil.slope = p.text
				when "percentage"
					soil.percentage = p.text
				when "drainage_type"
					soil.drainage_type = p.text
				when "layers"
					if soil.save
						p.elements.each do |f|
							msg = upload_layer_new_version(soil.id, p)
						end
					else
						return "Soil could not be saved"
					end
			end
		end
	end 

	def upload_layer_info(node, soil_id)
		layer = Layer.new
		layer.soil_id = soil_id
		node.elements.each do |p|
			case p.name
				when "Depth"
					layer.depth = p.text
				when "SoilP"
					layer.soil_p = p.text
				when "BD"
					layer.bulk_density = p.text
				when "Sand"
					layer.sand = p.text
				when "Silt"
					layer.silt = p.text
					layer.clay = '%.2f' % (100 - layer.silt - layer.sand)
				when "OM"
					layer.organic_matter = p.text
				when "PH"
					layer.ph = p.text
				when "SatC"
					layer.satc = p.text
				when "Bdd"
					layer.bdd = p.text
				when "Wn"
					layer.wn = p.text
				when "Uw"
					layer.uw = p.text
				when "Smb"
					layer.woc = p.text
				when "Rsd"
					layer.rsd = p.text
				when "Rok"
					layer.rok = p.text
				when "Psp"
					layer.psp = p.text
				when "Fc"
					layer.fc = p.text
				when "Cnds"
					layer.cnds = p.text
				when "cac"
					layer.cac = p.text
				when "cec"
					layer.cec = p.text
			end
		end
		if layer.save then
			return "OK"
		else
			return "Error saving layers"
		end
	end

	def upload_layer_new_version(soil_id, node)
		layer = Layer.new
		layer.soil_id = soil_id
		node.elements.each do |p|
			case p.name
				when "depth"
					layer.depth = p.text
				when "soilp"
					layer.soil_p = p.text
				when "bd"
					layer.bulk_density = p.text
				when "sand"
					layer.sand = p.text
				when "silt"
					layer.silt = p.text
				when "clay"
					layer.clay = p.text
				when "om"
					layer.organic_matter = p.text
				when "ph"
					layer.ph = p.text
			end
		end
		if layer.save
			return "OK"
		else
			return "Layers could not be saved"
		end 
	end

	def upload_soil_scenario_info(node, field_id, soil_id)
		saved = true
		scenario_id = 0
		node.elements.each do |p|
			case p.name
				when "Name"
					#validates if scenario already exists
					scenario = Scenario.find_by_field_id_and_name(field_id, p.text)
					if scenario == nil then
						scenario = Scenario.new
						scenario.field_id = field_id
						scenario.name = name = p.text
						if !scenario.save then
							saved = false
						else
							scenario_id = scenario.id
						end
					else
						scenario_id = scenario.id
					end
				when "Subareas"
					if saved == true then
						upload_subarea_info(p, scenario_id, soil_id)
					else
						return "Error saving scenario"
					end
				when "Operations"
					if saved == true then
						upload_soil_operation_info(p, scenario_id, soil_id)
					else
						return "Error saving scenario"
					end
				when "Results"
					if saved == true then
						upload_result_info(p, field_id, soil_id, scenario_id)
					else
						return "Error saving scenario"
					end
			end
		end
	end

	def upload_scenario_new_version(field_id, new_scenario)
		msg = "OK"
		scenario = Scenario.new
		scenario.field_id = field_id
		new_scenario.elements.each do |p|
			case p.name
				when "name"
					scenario.name = p.text
				when "operations"
					p.elements.each do |o|
						msg = upload_operation_new_version(scenario.id, o)
						if msg != "OK"
							return msg
						end
					end
				when "bmps"
					p.elements.each do |b|
						msg = upload_bmp_info_new_version(scenario.id, b)
						if msg != "OK"
							return msg
						end
					end
			end
		end
		if !scenario.save then
			return "scenario could not be saved"
		end
		return msg
	end

	def upload_subarea_info(node, scenario_id, soil_id)
		subarea = Subarea.new
		subarea.soil_id = soil_id
		subarea.scenario_id = scenario_id
		node.elements.each do |p|
			case p.name
				when "SbaType"
					subarea.subarea_type = p.text
				when "SubareaTitle"
					subarea.description = p.text
				when "SubareaNumber"
					subarea.number = p.text
				when "Inps"
					subarea.inps = p.text
				when "Iops"
					subarea.iops = p.text
				when "Iow"
					subarea.iow = p.text
				when "Ii"
					subarea.ii = p.text
				when "Iapl"
					subarea.iapl = p.text
				when "Nvcn"
					subarea.nvcn = p.text
				when "Iwth"
					subarea.iwth = p.text
				when "Ipts"
					subarea.ipts = p.text
				when "Isao"
					subarea.isao = p.text
				when "Luns"
					subarea.luns = p.text
				when "Imw"
					subarea.imw = p.text
				when "Sno"
					subarea.sno = p.text
				when "Stdo"
					subarea.stdo = p.text
				when "Yct"
					subarea.yct = p.text
				when "Xct"
					subarea.xct = p.text
				when "Azm"
					subarea.azm = p.text
				when "Fl"
					subarea.fl = p.text
				when "Fw"
					subarea.fw = p.text
				when "Angl"
					subarea.angl = p.text
				when "Wsa"
					subarea.wsa = p.text
				when "chl"
					subarea.chl = p.text
				when "Chd"
					subarea.chd = p.text
				when "Chs"
					subarea.chs = p.text
				when "Chn"
					subarea.chn = p.text
				when "Slp"
					subarea.slp = p.text
				when "Slpg"
					subarea.splg = p.text
				when "Upn"
					subarea.upn = p.text
				when "Ffpq"
					subarea.ffpq = p.text
				when "Urbf"
					subarea.urbf = p.text
				when "Rchl"
					subarea.rchl = p.text
				when "Rchd"
					subarea.rchd = p.text
				when "Rcbw"
					subarea.rcbw = p.text
				when "Rctw"
					subarea.rctw = p.text
				when "Rchs"
					subarea.rchs = p.text
				when "Rchc"
					subarea.rchc = p.text
				when "Rchn"
					subarea.rchn = p.text
				when "Rchk"
					subarea.rchk = p.text
				when "Rfpw"
					subarea.rfpw = p.text
				when "Rfpl"
					subarea.rfpl = p.text
				when "Rsee"
					subarea.rsee = p.text
				when "Rsae"
					subarea.rsae = p.text
				when "Rsve"
					subarea.rsve = p.text
				when "Rsep"
					subarea.rsep = p.text
				when "Rsap"
					subarea.rsap = p.text
				when "Rsvp"
					subarea.rsvp = p.text
				when "Rsv"
					subarea.rsv = p.text
				when "Rsrr"
					subarea.rsrr = p.text
				when "Rsys"
					subarea.rsys = p.text
				when "Rsyn"
					subarea.rsyn = p.text
				when "Rshc"
					subarea.rshc = p.text
				when "Rsdp"
					subarea.rsdp = p.text
				when "Rsdb"
					subarea.rsdb = p.text
				when "Pcof"
					subarea.pcof = p.text
				when "Bcof"
					subarea.bcof = p.text
				when "Bffl"
					subarea.bffl = p.text
				when "Idf1"
					subarea.idf1 = p.text
				when "Idf2"
					subarea.idf2 = p.text
				when "Idf3"
					subarea.idf3 = p.text
				when "Idf4"
					subarea.idf4 = p.text
				when "Idf5"
					subarea.idf5 = p.text
				when "Nirr"
					subarea.nirr = p.text
				when "Iri"
					subarea.iri = p.text
				when "Ifa"
					subarea.ira = p.text
				when "Lm"
					subarea.lm = p.text
				when "Ifd"
					subarea.ifd = p.text
				when "Idr"
					subarea.idr = p.text
				when "Bir"
					subarea.bir = p.text
				when "Efi"
					subarea.efi = p.text
				when "Vimx"
					subarea.vimx = p.text
				when "armn"
					subarea.armn = p.text
				when "Armx"
					subarea.armx = p.text
				when "Bft"
					subarea.bft = p.text
				when "Fnp4"
					subarea.fnp4 = p.text
				when "Fnp2"
					subarea.fnp2 = p.text
				when "Fnp5"
					subarea.fnp5 = p.text
				when "Fmx"
					subarea.fmx = p.text
				when "Drt"
					subarea.drt = p.text
				when "Fdsf"
					subarea.fdsf = p.text
				when "Pec"
					subarea.pec = p.text
				when "Dalg"
					subarea.dalg = p.text
				when "Ddlg"
					subarea.ddlg = p.text
				when "Vlgn"
					subarea.vlgn = p.text
				when "Coww"
					subarea.coww = p.text
				when "Solq"
					subarea.solq = p.text
				when "Sflg"
					subarea.sflg = p.text
				when "Firg"
					subarea.firg = p.text
				when "Ny1"
					subarea.ny1 = p.text
				when "Ny2"
					subarea.ny2 = p.text
				when "Ny3"
					subarea.ny3 = p.text
				when "Ny4"
					subarea.ny4 = p.text
				when "Xtp1"
					subarea.xtp1 = p.text
				when "Xtp2"
					subarea.xtp2 = p.text
				when "Xtp3"
					subarea.xtp3 = p.text
				when "Xtp4"
					subarea.xtp4 = p.text
			end
		end
		if subarea.save then
			return "OK"
		else
			retutn "Error loading subares"
		end
	end

	def upload_soil_operation_info(node, scenario_id, soil_id)
		soil_operation = SoilOperation.new
		soil_operation.soil_id = soil_id
		soil_operation.scenario_id = scenario_id
		node.elements.each do |p|
			case p.name
				when "EventId"  #use to take the event id to be able to match this operation with the operations in scenarios
					soil_operation.tractor_id = p.text					
				when "Year"
					soil_operation.year = p.text
				when "Month"
					soil_operation.month = p.text
				when "Day"
					soil_operation.day = p.text
				when "operation_id"  #todo this need to be taken from operation table
				when "ApexCrop"
					soil_operation.apex_crop = p.text				
				when "NO3", "PO4", "OrgN", "OrgP"
					if p.text.to_f > 0.0
						soil_operation.type_id = 25
					end
				when "OpVal1"
					soil_operation.opv1 = p.text				
				when "OpVal2"
					soil_operation.opv2 = p.text				
				when "OpVal3"
					soil_operation.opv3 = p.text				
				when "OpVal4"
					soil_operation.opv4 = p.text				
				when "OpVal5"
					soil_operation.opv5 = p.text				
				when "OpVal6"
					soil_operation.opv6 = p.text				
				when "OpVal7"
					soil_operation.opv7 = p.text				
				when "ApexOpAbbreviation"
					soil_operation.activity_id = Activity.find_by_abbreviation(p.text).id
				when "ApexTillCode"
					soil_operation.apex_operation = p.text
			end
		end
		if soil_operation.save then
			return "OK"
		else
			retutn "Error loading operations"
		end
	end

	def upload_operation_info(node, scenario_id, field_id)
		operation = Operation.new
		operation.scenario_id = scenario_id
		event_id = 0
		scenario = ""
		apex_till_code = 0
		node.elements.each do |p|
			case p.name
				when "EventId"  #use to take the event id to be able to match this operation with the operations in scenarios
					#look for the same opeerations in in the SoilOperation table to add the operation id
					event_id = p.text
				when "ApexOpAbbreviation"
					operation.activity_id = Activity.find_by_abbreviation(p.text).id
				when "Year"
					operation.year = p.text
				when "Month"
					operation.month_id = p.text
				when "Day"
					operation.day = p.text
				when "ApexCrop"
					operation.crop_id = Crop.find_by_number(p.text).id
				when "NO3"
					operation.no3_n = p.text
				when "PO4"
					operation.po4_p = p.text
				when "OrgN"
					operation.org_n = p.text
				when "OrgP"
					operation.org_p = p.text
				when "ApexOpv1"
					operation.amount = p.text
				when "ApexOpv2"
					operation.depth = p.text
				when "ApexTillCode"
					apex_till_code = p.text.to_i
				when "ApexTillName"
					case operation.activity_id
						when 1  #planting
							operation.type_id = apex_till_code
						when 2  # fertilizer
							if p.text == "Commercial Fertilizer" 
								operation.type_id = 1
								operation.subtype_id = 25
							else
								operation.type_id =2
								operation.subtype_id = 55
							end
					end # end case p.text
			end # case
		end # end each
		operation.save
		soils = Soil.where(:field_id => field_id, :selected => true)
		soils.each do |soil|
			session[:depth] = soil.id.to_s + "-" + scenario_id.to_s + "-" + event_id.to_s
			soil_operation = SoilOperation.where(:soil_id => soil.id, :scenario_id => scenario_id, :tractor_id => event_id).first
			soil_operation.operation_id = operation.id
			soil_operation.save
		end # end soils.each
	end

	def upload_operation_new_version(scenario_id, new_operation)
		operation = Operation.new
		operation.scenario_id = scenario_id
		new_operation.elements.each do |p|
			case p.name
				when "crop_id"
					operation.crop_id = p.text
				when "activity_id"
					operation.activity_id = p.text
				when "day"
					operation.day = p.text
				when "month"
					operation.month_id = p.text
				when "year"
					operation.year = p.text
				when "type_id"
					operation.type_id = p.text
				when "subtype_id"
					operation.subtype_id = p.text
				when "amout" #typo in xml download
					operation.amount = p.text
				when "depth"
					operation.depth = p.text
				when "no3_n"
					operation.no3_n = p.text
				when "po4_p"
					operation.po4_p = p.text
				when "org_n"
					operation.org_n = p.text
				when "org_p"
					operation.org_p = p.text
				when "nh3"
					operation.nh3 = p.text
				when "soil_operation"
					p.elements.each do |s|
						upload_soil_operation_new(scenario_id, s)
						if msg != "OK"
							return msg
						end
					end
			end
		end
		if operation.save then
			return "OK"
		else
			return "operation could not be saved"
		end
	end

	def upload_soil_operation_new(scenario_id, operation)
		soil_operation = SoilOperation.new
		soil_operation.scenario_id = scenario_id
		soil_operation.operation_id = operation.id
		#soil_operation.soil_id = ??
		operation.elements.each do |p|
			case p.name
				when "apex_crop"
					soil_operation.apex_crop = p.text
				when "opv1"
					soil_operation.opv1 = p.text
				when "opv2"
					soil_operation.opv2 = p.text
				when "opv3"
					soil_operation.opv3 = p.text
				when "opv4"
					soil_operation.opv4 = p.text
				when "opv5"
					soil_operation.opv5 = p.text
				when "opv6"
					soil_operation.opv6 = p.text
				when "opv7"
					soil_operation.opv7 = p.text
				when "activity_id"
					soil_operation.activity_id = p.text
				when "year"
					soil_operation.year = p.text
				when "month"
					soil_operation.month = p.text
				when "day"
					soil_operation.day = p.text
				when "type_id"
					soil_operation.type_id = p.text
				when "apex_operation"
					soil_operation.apex_operation = p.text
			end
		end
	end

	def upload_result_info(node, field_id, soil_id, scenario_id)
		node.elements.each do |p|
			case p.name
				when "Crops"
					upload_crop_soil_result_info(p, field_id, soil_id, scenario_id)
				when "Soil"
					upload_soil_result_info(p, field_id, soil_id, scenario_id)
			end # end case p.name
		end  # end node.elements.each
	end  # end method

	def upload_soil_result_info(node, field_id, soil_id, scenario_id)
		#tile drain flow is duplicated in the old version NTTG2 VB. So is needed to control that the second one is not used
		tile_drain = false

		node.elements.each do |p|
			case p.name
				when "OrgN"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 21)
				when "OrgNCI"
					@result.ci_value = p.text
					@result.save
				when "runoffN"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 22)
				when "runoffNCI"
					@result.ci_value = p.text
					@result.save
				when "subsurfaceN"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 23)
				when "subsurfaceNCI"
					@result.ci_value = p.text
					@result.save
				when "OrgP"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 31)
				when "OrgPCI"
					@result.ci_value = p.text
					@result.save
				when "PO4"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 32)
				when "PO4CI"
					@result.ci_value = p.text
					@result.save
				when "runoff"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 41)
				when "runoffCI"
					@result.ci_value = p.text
					@result.save
				when "subsurfaceFlow"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 42)
				when "subsurfaceFlowCI"
					@result.ci_value = p.text
					@result.save
				when "tileDrainFlow"
					if tile_drain == false then
						@result = add_result(field_id, soil_id, scenario_id, p.text, 43)
					end
				when "tileDrainFlowCI"
					if tile_drain == false then
						tile_drain = true
						@result.ci_value = p.text
						@result.save
					end
				when "irrigation"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 51)
				when "irrigationCI"
					@result.ci_value = p.text
					@result.save
				when "deepPerFlow"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 52)
				when "deepPerFlowCI"
					@result.ci_value = p.text
					@result.save
				when "Sediment"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 61)
				when "SedimentCI"
					@result.ci_value = p.text
					@result.save
					#add manure. It is not in the old version projects
					@result = add_result(field_id, soil_id, scenario_id, 0, 62)
					@result.ci_value = 0
					@result.save
				when "Manure"  # just in case this exist in some projects the values for manuer (62) are updated
					@result = Result.where(:field_id => field_id, :soil_id => soil_id, :scenario_id => scenario_id, description_id => 62)
					if @result != nil then
						@result.value = p.text
					end 
				when "ManureCI"  # just in case this exist in some projects the values for manuer (62) are updated
					@result = Result.where(:field_id => field_id, :soil_id => soil_id, :scenario_id => scenario_id, description_id => 62)
					if @result != nil then
						@result.ci_value = p.text
					end 
				when "tileDrainN"
					@result = add_result(field_id, soil_id, scenario_id, p.text, 24)
				when "tileDrainP"
					@result1 = add_result(field_id, soil_id, scenario_id, p.text, 33)
				when "tileDrainNCI"
					@result.ci_value = p.text
					@result.save
				when "tileDrainPCI"
					@result1.ci_value = p.text
					@result1.save
				when "annualFlow"
					upload_chart_info(p, field_id, 0, scenario_id, 41)
				when "annualNO3"
					upload_chart_info(p, field_id, 0, scenario_id, 22)
				when "annualOrgN"
					upload_chart_info(p, field_id, 0, scenario_id, 21)
				when "annualOrgP"
					upload_chart_info(p, field_id, 0, scenario_id, 31)
				when "annualPO4"
					upload_chart_info(p, field_id, 0, scenario_id, 32)
				when "annualSediment"
					upload_chart_info(p, field_id, 0, scenario_id, 61)
				when "annualPrecipitation"
					upload_chart_info(p, field_id, 0, scenario_id, 100)
				when "annualCropYield"
					p.elements.each do |p|
						#upload annual crops
						upload_chart_crop_info(p, field_id, 0, scenario_id)
					end
			end # end case p.name
		end  # end node.elements.each
	end

	def summarize_total()
		descriptions = Description.where("description like ?", "%Total%")
		fields = Field.where(:location_id => Location.find_by_project_id(session[:project_id]).id)
		fields.each do |field|
			scenarios = Scenario.where(:field_id => field.id)
			scenarios.each do |scenario|
				descriptions.each do |description|
					value = Result.where("field_id = " + field.id.to_s + " AND soil_id = 0 AND scenario_id = " + scenario.id.to_s + " AND description_id > " + description.id.to_s + " AND description_id < " + (description.id + 10).to_s).sum(:value)
					result = add_result(field.id, 0, scenario.id, value, description.id)
					ci_value = Result.where("field_id = " + field.id.to_s + " AND soil_id = 0 AND scenario_id = " + scenario.id.to_s + " AND description_id > " + description.id.to_s + " AND description_id < " + (description.id + 10).to_s).sum(:ci_value)
					result.ci_value = ci_value
					result.save
				end # end descriptions each
				soils = Soil.where(:field_id => field.id)
				soils.each do |soil|
					descriptions.each do |description|
						value = Result.where("field_id = " + field.id.to_s + " AND soil_id = " + soil.id.to_s + " AND scenario_id = " + scenario.id.to_s + " AND description_id > " + description.id.to_s + " AND description_id < " + (description.id + 10).to_s).sum(:value)
						result = add_result(field.id, soil.id, scenario.id, value, description.id)
						ci_value = Result.where("field_id = " + field.id.to_s + " AND soil_id = " + soil.id.to_s + " AND scenario_id = " + scenario.id.to_s + " AND description_id > " + description.id.to_s + " AND description_id < " + (description.id + 10).to_s).sum(:ci_value)
						result.ci_value = ci_value
						result.save
					end # end descriptions each
				end # end each soil
			end # end each scenario
		end # end each field
	end # end summarize_totals method.

	def add_result(field_id, soil_id, scenario_id, p_text, description_id)
		result = Result.new
		result.field_id = field_id
		result.soil_id = soil_id
		result.scenario_id = scenario_id
		result.value = p_text
		result.description_id = description_id
		return result
	end

	def upload_crop_soil_result_info(node, field_id, soil_id, scenario_id)
		crop_name = ""
		crop_value = 0.0
		crop_ci = 0.0
		description_id = 71
		node.elements.each do |p|
			case p.name
				when "cropName"
					crop_name = p.text
				when "cropYield"
					crop_value = p.text
				when "cropYieldCI"
					result = add_result(field_id, soil_id, scenario_id, crop_value, description_id)
					result.ci_value = p.text
					result.crop_id = Crop.find_by_code(crop_name).id
					result.save
					description_id += description_id
			end # end case
		end # each do
		#after all of the crops ahve been added, Crop yield should be added too
		#result = add_result(field_id, soil_id, scenario_id, "", 70)
		#result.ci_value = ""
		#result.crop_id = ""
		#result.save
	end # end method

	def upload_scenario_info(node, field_id)
		name = ""
		scenario_id = 0
		node.elements.each do |p|
			case p.name
				when "Name"
					name = p.text
				when "Operations"
					scenario_id = Scenario.find_by_field_id_and_name(field_id, name).id
					upload_operation_info(p, scenario_id, field_id)
				when "Results"
					scenario_id = Scenario.find_by_field_id_and_name(field_id, name).id
					upload_result_info(p, field_id, 0, scenario_id)
			end #end case
		end ## end each
	end # end method

	def upload_chart_info(node, field_id, soil_id, scenario_id, description_id)
		i = 1
		month_year = 0
		year = @weather["simulation_final_year"].to_i - 11
		node.elements.each do |p|
			if i <= 12 then
				month_year = year
				year += 1
			else
				month_year = i - 12
			end
			i +=1
			chart = Chart.new
			chart.field_id = field_id
			chart.soil_id = soil_id
			chart.scenario_id = scenario_id
			chart.value = p.text
			chart.description_id = description_id
			chart.month_year = month_year
			chart.save
		end # end node each
	end

	def upload_chart_crop_info(node, field_id, soil_id, scenario_id)
	#todo check for more than one crop
		i = 1		
		month_year = @weather["simulation_final_year"].to_i - 11
		node.elements.each do |p|
			chart = Chart.new
			chart.field_id = field_id
			chart.soil_id = soil_id
			chart.scenario_id = scenario_id
			chart.value = p.elements[1]
			chart.description_id = 71		#todo increase if more than one crop
			chart.month_year = month_year
			chart.save
			if i < 12 then
				month_year += 1
			else
				return
			end
			i +=1
		end # end node each
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

	def upload_bmp_info_new_version(scenario_id, new_bmp)
		bmp = Bmp.new
		bmp.scenario_id = scenario_id
		new_bmp.elements.each do |p|
			case p.name
				when "bmp_id"
					bmp.bmp_id = p.text
				when "bmpsublist_id"
					bmp.bmpsublist_id = p.text
				when "crop_id"
					bmp.crop_id = p.text
				when "irrigation_id"
					bmp.irrigation_id = p.text
				when "water_stress_factor"
					bmp.water_stress_factor = p.text
				when "irrigation_efficiency"
					bmp.irrigation_efficiency = p.text
				when "maximum_single_application"
					bmp.maximum_single_application = p.text
				when "safety_factor"
					bmp.safety_factor = p.text
				when "depth"
					bmp.depth = p.text
				when "area"
					bmp.area = p.text
				when "number_of_animals"
					bmp.number_of_animals = p.text
				when "days"
					bmp.days = p.text
				when "hours"
					bmp.hours = p.text
				when "animal_id"
					bmp.animal_id = p.text
				when "dry_manure"
					bmp.dry_manure = p.text
				when "no3_n"
					bmp.no3_n = p.text
				when "po4_p"
					bmp.po4_p = p.text
				when "org_n"
					bmp.org_n = p.text
				when "width"
					bmp.width = p.text
				when "grass_field_portion"
					bmp.grass_field_portion = p.text
				when "buffer_slope_upland"
					bmp.buffer_slope_upland = p.text
				when "crop_width"
					bmp.crop_width = p.text
				when "slope_reduction"
					bmp.slope_reduction = p.text
				when "sides"
					bmp.sides = p.text
				when "name"
					bmp.name = p.text
				when "difference_max_temperature"
					bmp.difference_max_temperature = p.text
				when "difference_min_temperature"
					bmp.difference_min_temperature = p.text
				when "difference_precipitation"
					bmp.difference_precipitation = p.text
			end
		end
		if bmp.save
			return "OK"
		else
			return "bmp could not be saved"
		end
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
end
