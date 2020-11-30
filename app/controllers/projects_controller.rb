class ProjectsController < ApplicationController
  #load_and_authorize_resource

  include LocationsHelper
  include ProjectsHelper
  include ScenariosHelper
  layout 'welcome'
  require 'nokogiri'
  helper_method :sort_column, :sort_direction

  ########################################### INDEX ##################
  # GET /projects
  # GET /projects.json
  def index
    @user = User.find(session[:user_id])
    if @user.admin?
      #@projects = Project.order("#{sort_column} #{sort_direction}")
      @projects = Project.includes(:user, :location).order("#{sort_column} #{sort_direction}")
    else
      @projects = Project.where(:user_id => params[:user_id]).includes(:location).order("#{sort_column} #{sort_direction}")
    end
    session[:simulation] = "watershed"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  ########################################### SHOW - WHEN CLICK ON PROJECT NAME ##################
  # GET /projects/1
  # GET /projects/1.json
  def show #selected when click on a project or a new project is created.
    if params[:id] == "upload" then
      redirect_to "upload"
    end
    @project = Project.find(params[:id])
    @location = @project.location
    session[:location_id] = @location.id
    case true
    when @project.version == "NTTG3_special"
      redirect_to states_path()
    when @location.fields.count > 0 && @project.version == "NTTG3"  # load fields
      redirect_to project_fields_path(@project)
    else # Load map
      #if request.url.include? ".bk." or request.url.include? "localhost" or request.url.include? "ntt-re" then 
        redirect_to edit_project_location_path(@project, @location)  # new map
      #else
        #redirect_to project_location_path(@project, @location)   # old map       
      #end     
    end # end case true
  end

##esto es una prueba
  ########################################### SHOWS - WHEN CLICK ON PROJECT NAME ##################
  # GET /projects/1
  # GET /projects/1.json
  def shows
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html { render action: "show" } # show.html.erb
      format.json { render json: @project }
    end
  end

  ########################################### NEW ######################################################
  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  ########################################### EDIT ######################################################
  # GET /projects/1/edit
  def edit
    @user = User.find(params[:user_id])
    @project = Project.find(params[:id])
  end

  ################  copy the selected project  ###################
  def copy_project
    @use_old_soil = true
    msg = duplicate_project()
    if !msg == "OK" then
      flash[:info] = msg
    else
      flash[:notice] = @project.name + " " + t('notices.copied')
    end # end if msg
    #download_project(params[:id], "copy")
    @user = User.find(session[:user_id])
    if @user.admin?
      @projects = Project.order("#{sort_column} #{sort_direction}")
    else
      @projects = Project.where(:user_id => params[:user_id]).order("#{sort_column} #{sort_direction}")
    end
    #render "index"
    redirect_to(request.env['HTTP_REFERER']) #return to previous page
  end

  ########################################### CREATE NEW PROJECT##################
  # POST /projects
  # POST /projects.json
  def create
    @user = User.find(session[:user_id])
    @project = Project.new(project_params)
    #params[:project_id] = @project.id
    @project.user_id = session[:user_id]
    @project.version = "NTTG3"
    respond_to do |format|
      if @project.save
        flash[:notice] = ""
        params[:project_id] = @project.id
        location = Location.new
        location.project_id = @project.id
        location.save
        session[:location_id] = location.id
        format.html { redirect_to @project, info: t('models.project') + "" + t('notices.created') }
        format.json { render json: @project, status: :created, location: @project }
      else
        flash[:info]= t('project.project_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
        flash[:error] = ""
        format.html { redirect_to user_projects_path(session[:user_id]) }
        #format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  ########################################### update PROJECT##################
  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @user = User.find(params[:user_id])
    @project = Project.find(params[:id])
    if @project.version != "Comet" then
      @project.version = "NTTG3"
    end
    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to user_projects_path(params[:user_id]), info: t('models.project') + "" + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  ######################## DELETE PROJECT ##################
  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    location = Location.where(:project_id => params[:id])
    location.destroy_all unless location == []
    respond_to do |format|
    if @project.destroy
      format.html { redirect_to user_projects_path(session[:user_id]), notice: t('models.project') + " " + @project.name + t('notices.deleted') }
      format.json { head :no_content }
    end
  end
    @projects = Project.where(:user_id => params[:user_id])
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
    @id = params[:format]
    #nothing to do here. Just render the upload view
  end

  ########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
  def upload_project
    if params[:commit] == "Continue" then   #check if project State_Project exist and field County_field exist
      saved = process_county()
      if saved then   #redirect to scenarios
        redirect_to project_field_scenarios_path(@project, @field)
        return
      end
    else
      saved = upload_prj()
    end
    if saved
      flash[:notice] = t('models.project') + " " + t('general.success')
      redirect_to user_projects_path(session[:user_id]), info: t('models.project') + " " + @project.name + t('notices.uploaded')
    else
      redirect_to projects_upload_path(@upload_id)
    end
  end

 ########################################### Create or update State/county project ##################
  def process_county
    state = State.find(params[:state_select])
    county = County.find(params[:county_select])
    project_name = state.state_name + "_Project"
    field_name = county.county_name + "_Field"
    @project = Project.find_by_name(project_name)
    if @project == nil
      #Project should be created as well as field
      @project = Project.new
      @project.name = project_name
      @project.description = project_name
      @project.version = "NTTG3_special"
      @project.user_id = session[:user_id]
      if !(@project.save) then
        return false
      end
      if create_location then
        return create_field(field_name)
      else
        return false
      end
    end
    if @project.location == nil then     #project exist but for some reason no location need to create
      if !create_location() then
        return false
      end
    else
      @location = @project.location
    end
    @field = Field.find_by_field_name(field_name)
    if @field == nil  #fieldis check to see if it exist no matter if porject was created before or not as well as location
      #field is created
      return create_field(field_name)
    end
    return true
  end

  ########################################### Create county location ##################
  def create_location()
    @location = Location.new
    @location.project_id = @project.id
    @location.state_id = params[:state_select]
    @location.county_id = params[:county_select]
    if @location.save then
      return true
    end
    return false
  end

  ########################################### Create county field ##################
  def create_field(field_name)
    debugger
    @field = Field.new
    @field.field_name = field_name
    @field.location_id = 0
    @field.field_area = 100
    @field.weather_id = 0
    @field.soilp = 0
    @field.location_id = @location.id
    if !(@field.save) then
      return false
    else
      #crete weather and soil info
      if !create_weather() then return false end
      if !create_soil() then return false end
      load_controls()
      load_parameters(0)
    end
    return true
  end

  def create_weather
    @weather = Weather.new
    @weather.field_id = @field.id
    @weather.simulation_initial_year = 1987
    @weather.simulation_final_year = 2019
    @weather.weather_initial_year = 1982
    @weather.weather_final_year = 2019
    if @weather.save then
      return true
    else
      return false
    end
  end

  def create_soil
    soil = Soil.new
    soil.field_id = @field.id
    soil.key = @project.id    #just to identify it no used
    soil.group = "B"
    soil.name = @field.field_name
    soil.slope = 0.1
    soil.albedo = 0.37
    soil.percentage = 100
    if soil.save then
      return true
    else
      return false
    end
  end

 ########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
  def upload_prj
    @inps1 = 0
    saved = false
    msg = ""
    @upload_id = 0
    ActiveRecord::Base.transaction do
      #begin
      msg = "OK"
      @upload_id = 0
      if params[:commit].eql? t('project.upload_project') then
        if params[:project] == nil then
          redirect_to projects_upload_path(@upload_id)
          flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('models.project') and return false
        end
        @data = Nokogiri::XML(params[:project])
        @upload_id = 0
      elsif params[:commit].eql? t('project.upload_example') then
        @upload_id = 1
        case params[:examples]  # No example was selected
        when "0"
          respond_to do |format|
            format.html { redirect_to projects_upload_path(@upload_id)}
            format.json { head :no_content }
            flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('general.one') and return false
          end
        when "1" # Load OH two fields
          @data = Nokogiri::XML(File.open(EXAMPLES + "/OH_MultipleFields.xml"))
        when "2"  # load just the saved project to be copied
          @data = Nokogiri::XML(File.open(@path))
          @upload_id = 2
        end # end case examples
      else
        if params[:project] == nil then
          redirect_to projects_upload_path(@upload_id)
          flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('models.project') and return false
        end
        original_data = params[:project].read
        @data = Nokogiri::XML(original_data.gsub("[","<").gsub("]",">"))        
        @upload_id = 2       
      end
      @data.root.elements.each do |node|
        case node.name
        when "project"
          msg = upload_project_new_version(node)
        when "location"
          msg = upload_location_new_version(node)
        when "StartInfo"
          if @upload_id == 1 then
            msg = upload_project_info(node)
          else    #Means is a comet project
            msg = upload_project_comet_version(node)
          end            
        when "FarmInfo"
          msg = upload_location_info1(node)
        when "FieldInfo"
          if @upload_id == 1 then
            msg = upload_field_info(node)
            msg = renumber_subareas()
          else
            msg = upload_field_comet_version(node)
          end
        when "SiteInfo"
          msg = upload_site_info(node)
        when "controls"
          node.elements.each do |c|
            msg = upload_control_values_new_version(c)
          end
        when "ControlValues"
          msg = upload_control_values(node)
        when "ParmValues"
          msg = upload_parameter_values(node)
        when "parameters"
          node.elements.each do |c|
            msg = upload_parameter_values_new_version(c)
          end
        end
        break if (msg != "OK" && msg != true)
      end
      if msg == "OK" && Location.find(@project.location.id).state_id != nil && Location.find(@project.location.id).state_id.to_s != "" then
        load_parameters(ApexParameter.where(:project_id => @project.id).count)
      end

      if (msg == "OK" || msg == true)
        @projects = Project.where(:user_id => session[:user_id])
        saved = true
      else
        saved = false
        flash[:notice] = msg
        raise ActiveRecord::Rollback
      end
      #rescue NoMethodError => e
    end
    return saved
  end

  ########################################### RENUMERATE THE SUBAREAS FILES FOR PREVIOUS VERSION PROJECTS ##################
  def renumber_subareas()
    msg = "OK"
    #renumber the subarea inps, iops, iown
    @project.location.fields.each do |field|
    @iops1 = 1
      field.soils.each do |soil|
        #if soil.selected then
        soil.subareas.each do |subarea|
            subarea.iops = @iops1
            subarea.inps = @iops1
            subarea.iow = @iops1
            if !subarea.save
              msg = "Error renumber subareas"
            end
        end # end subareas.each
          @iops1 +=1
        #end   # end if soil selected
      end   # end soils.each
    end  # end field.each
    return msg
  end  # end method

  ########################################### DOWNLOAD PROJECT FILE IN XML FORMAT ##################
  def download()
    download_project(params[:id], "download")
  end

  def download_project(project_id, type)
    #require 'open-uri'
    #require 'net/http'
    #require 'rubygems'
    project = Project.find(project_id)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.projects {
        xml.project {
          #save project information
          xml.project_name project.name
          xml.project_description project.description
          xml.project_version project.version
        } # end xml.project
        #save location information
        save_location_information(xml, project_id)
        xml.controls {
          controls = ApexControl.where(:project_id => project_id)
          controls.each do |c|
          save_control_information(xml, c)
          end
        } # xml each control end

        xml.parameters {
          parameters = ApexParameter.where(:project_id => project_id)
          parameters.each do |c|
          save_parameter_information(xml, c)
          end
        } # xml each control end
      } # end xml.projects
    end #builder do end

    file_name = session[:session_id] + ".prj"
    @path = File.join(DOWNLOAD, file_name)
    content = builder.to_xml
    File.open(@path, "w") { |f| f.write(content) }
    #file.write(content)
    send_file @path, :type => "application/xml", :x_sendfile => true
    if type == "copy"
      #call upload to copy project
      params[:examples] = "2"
      saved = upload_prj()
    end
  end   #download project def end

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
          save_field_information(xml, field)
        end #end fields.each
      } # end xml.fields
      xml.watersheds {
        watersheds = Watershed.where(:location_id => location.id)
        watersheds.each do |watershed|
          save_watershed_information(xml, watershed)
        end # end watersheds.each
      } # end xml.watersheds
    } #end xml.location
  end

  def save_field_information(xml, field)
    xml.field {
      #field information
      xml.id field.id
      xml.field_name field.field_name
      xml.field_area field.field_area
      xml.field_average_slope field.field_average_slope
      xml.field_type field.field_type
      xml.soilp field.soilp 
      xml.soil_aliminum field.soil_aliminum 
      xml.soil_test field.soil_test
      xml.coordinates field.coordinates   #any thing for field should be before coordinates beacuse here the new field is saved.
      climes = Clime.where(:field_id => field.id)
      xml.climes {
        climes.each do |clime|
          save_clime_information(xml, clime)
        end
      }
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
      xml.scenarios {
        scenarios.each do |scenario|
          save_scenario_information(xml, scenario)
        end # end scenarios.each
      } #end xml.scenarios
    } # end field info
  end   # end method

  def save_weather_information(xml, weather)
    xml.weather {
      xml.station_way weather.station_way
      xml.simulation_initial_year weather.simulation_initial_year
      xml.simulation_final_year weather.simulation_final_year
      xml.longitude weather.longitude
      xml.latitude weather.latitude
      xml.weather_file weather.weather_file
      xml.way_id weather.way_id
      xml.weather_initial_year weather.weather_initial_year
      xml.weather_final_year weather.weather_final_year
      xml.station_id weather.station_id
    } #weather info end
  end # end method

  def save_clime_information(xml, clime)   
    xml.clime {
      xml.field_id clime.field_id
      xml.daily_weather clime.daily_weather       
    }
  end

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
  end  # end site method

  def save_soil_information(xml, soil)
    #soils and layers information
    xml.soil {
      xml.id soil.id
      xml.selected soil.selected
      xml.key soil.key
      xml.symbol soil.symbol
      xml.group soil.group
      xml.name soil.name
      xml.albedo soil.albedo
      xml.slope soil.slope
      xml.percentage soil.percentage
      xml.drainage_id soil.drainage_id
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
      xml.soil_id_old soil.id
      layers = Layer.where(:soil_id => soil.id)
      xml.layers {
        layers.each do |layer|
          save_layer_information(xml, layer)
        end # end layers.each
      } # end xml.layers
    } # end xml.soil
  end  # end method

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
      xml.uw layer.uw
      xml.fc layer.fc
      xml.wn layer.wn
      xml.smb layer.smb
      xml.woc layer.woc
      xml.cac layer.cac
      xml.cec layer.cec
      xml.rok layer.rok
      xml.cnds layer.cnds
      xml.rsd layer.rsd
      xml.bdd layer.bdd
      xml.psp layer.psp
      xml.satc layer.satc
      xml.soil_aluminum layer.soil_aluminum
      xml.soil_test_id layer.soil_test_id
      xml.soil_p_initial layer.soil_p_initial
    } # layer xml
  end  # end layer method

  def save_scenario_information(xml, scenario)
    xml.scenario {
      xml.id scenario.id
      xml.name scenario.name
      if scenario.last_simulation != nil then
        xml.last_simulation scenario.last_simulation
      end
      operations = Operation.where(:scenario_id => scenario.id)
      xml.operations {
        operations.each do |operation|
          save_operation_information(xml, operation)
        end # end operation.each
      } #end xml.operations

      bmps = scenario.bmps
      xml.bmps {
        bmps.each do |bmp|
          save_bmp_information(xml, bmp)
        end # end bmps.each
      } # end xml.bmp operation
      subareas = Subarea.where(:scenario_id => scenario.id, :bmp_id => nil)
      if subareas.blank?
        subareas = Subarea.where(:scenario_id => scenario.id, :bmp_id => 0)
      end
      xml.subareas {
        subareas.each do |subarea|
          save_subarea_information(xml, subarea)
        end # end subarea.each
      } # end xml.subareas

      results = scenario.annual_results
      xml.results {
        results.each do |result|
          save_result_information(xml, result)
        end # end results.each
      } # end xml.results

      crops = scenario.crop_results
      xml.crop_results {
        crops.each do |crop|
          save_crop_result_information(xml, crop)
        end # end charts.each
      } # end xml.charts
    } # end xml.scenario
  end  #end scenario method

  def save_operation_information(xml, operation)
    xml.operation {
      xml.crop_id operation.crop_id
      xml.activity_id operation.activity_id
      xml.day operation.day
      xml.month operation.month_id
      xml.year operation.year
      xml.type_id operation.type_id
      xml.amount operation.amount
      xml.depth operation.depth
      xml.no3_n operation.no3_n
      xml.po4_p operation.po4_p
      xml.org_n operation.org_n
      xml.org_p operation.org_p
      xml.nh3 operation.nh3
      xml.subtype_id operation.subtype_id
      xml.moisture operation.moisture
      xml.org_c operation.org_c
      xml.rotation operation.rotation
      soil_operations = SoilOperation.where(:operation_id => operation.id)
      xml.soil_operations {
        soil_operations.each do |so|
          save_soil_operation_information(xml, so)
        end # end soil_operations.each
      } # end xml.soil_operations
    } # xml each operation end
  end # end method

  def save_control_information(xml, control)
    xml.control {
    xml.control_description_id control.control_description_id
    xml.value control.value
  }
  end

  def save_parameter_information(xml, parameter)
    xml.parameter {
    xml.value parameter.value
    xml.parameter_description_id parameter.parameter_description_id
  }
  end

  def save_result_information(xml, result)
    xml.result {
      xml.watershed_id result.watershed_id
      xml.scenario_id result.scenario_id
      xml.sub1 result.sub1
      xml.year result.year
      xml.flow result.flow
      xml.qdr result.qdr
      xml.surface_flow result.surface_flow
      xml.sed result.sed
      xml.ymnu result.ymnu
      xml.orgp result.orgp
      xml.po4 result.po4
      xml.orgn result.orgn
      xml.no3 result.no3
      xml.qdrn result.qdrn
      xml.qdrp result.qdrp
      xml.qn result.qn
      xml.dprk result.dprk
      xml.irri result.irri
      xml.pcp result.pcp
      xml.n2o result.n2o
      xml.prkn result.prkn
      xml.co2 result.co2
      xml.biom result.biom
    } # xml each result end
  end  # end method

  def save_crop_result_information(xml, result)
    xml.result {
      xml.watershed_id result.watershed_id
      xml.scenario_id result.scenario_id
      xml.name result.name
      xml.sub1 result.sub1
      xml.year result.year
      xml.yldg result.yldg
      xml.yldf result.yldf
      xml.ws result.ws
      xml.ns result.ns
      xml.ps result.ps
      xml.ts result.ts
    } # xml each result end
  end  # end method

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
      climates = Climate.where(:bmp_id => bmp.bmp_id)
      xml.climates {
        climates.each do |climate|
          save_climate_information(xml, climate)
        end # end climates.each
      } # end xml.climates
      subareas = Subarea.where(:bmp_id => bmp.id)
      xml.subareas {
        subareas.each do |subarea|
          save_subarea_information(xml, subarea)
        end # end subareas.each
      } # end xml.subareas

      soil_operations = SoilOperation.where(:bmp_id => bmp.id)
      xml.soil_operations {
        soil_operations.each do |so|
          save_soil_operation_information(xml, so)
        end # end soil_operations.each
      } # end xml.soil_operations
      timespans = Timespan.where(:bmp_id => bmp.id)
      xml.timespans {
        timespans.each do |timespan|
          save_timespan_information(xml, timespan)
        end # end subareas.each
      } # end xml.subareas
    } # xml bmp end
  end   # end method

  def save_soil_operation_information(xml, soil_operation)
    xml.soil_operation {
      xml.operation_id soil_operation.operation_id
      xml.scenario_id soil_operation.scenario_id
      xml.soil_id soil_operation.soil_id
      xml.bmp_id soil_operation.bmp_id
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
      xml.type_id soil_operation.type_id
      xml.apex_operation soil_operation.apex_operation
      xml.tractor_id soil_operation.tractor_id
    } # xml each soil_operation end
  end    # end method

  def save_subarea_information(xml, subarea)
    xml.subarea {
      xml.soil_id subarea.soil_id
      xml.bmp_id subarea.bmp_id
      xml.scenario_id subarea.scenario_id
      xml.subarea_type subarea.subarea_type
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
      xml.fw subarea.fw
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
      xml.rchl subarea.rchl
      xml.rchd subarea.rchd
      xml.rcbw subarea.rcbw
      xml.rctw subarea.rctw
      xml.rchs subarea.rchs
      xml.rchn subarea.rchn
      xml.rchc subarea.rchc
      xml.rchk subarea.rchk
      xml.rfpw subarea.rfpw
      xml.rfpl subarea.rfpl
      xml.rsee subarea.rsee
      xml.rsae subarea.rsae
      xml.rsve subarea.rsve
      xml.rsep subarea.rsep
      xml.rsap subarea.rsap
      xml.rsvp subarea.rsvp
      xml.rsv subarea.rsv
      xml.rsrr subarea.rsrr
      xml.rsys subarea.rsys
      xml.rsyn subarea.rsyn
      xml.rshc subarea.rshc
      xml.rsdp subarea.rsdp
      xml.rsbd subarea.rsbd
      xml.pcof subarea.pcof
      xml.bcof subarea.bcof
      xml.bffl subarea.bffl
      xml.nirr subarea.nirr
      xml.iri subarea.iri
      xml.ira subarea.ira
      xml.lm subarea.lm
      xml.ifd subarea.ifd
      xml.idr subarea.idr
      xml.idf1 subarea.idf1
      xml.idf2 subarea.idf2
      xml.idf3 subarea.idf3
      xml.idf4 subarea.idf4
      xml.idf5 subarea.idf5
      xml.bir subarea.bir
      xml.efi subarea.efi
      xml.vimx subarea.vimx
      xml.armn subarea.armn
      xml.armx subarea.armx
      xml.bft subarea.bft
      xml.fnp4 subarea.fnp4
      xml.fmx subarea.fmx
      xml.drt subarea.drt
      xml.fdsf subarea.fdsf
      xml.pec subarea.pec
      xml.dalg subarea.dalg
      xml.vlgn subarea.vlgn
      xml.coww subarea.coww
      xml.ddlg subarea.ddlg
      xml.solq subarea.solq
      xml.sflg subarea.sflg
      xml.fnp2 subarea.fnp2
      xml.fnp5 subarea.fnp5
      xml.firg subarea.firg
      xml.ny1 subarea.ny1
      xml.ny2 subarea.ny2
      xml.ny3 subarea.ny3
      xml.ny4 subarea.ny4
      xml.ny5 subarea.ny5
      xml.ny6 subarea.ny6
      xml.ny7 subarea.ny7
      xml.ny8 subarea.ny8
      xml.ny9 subarea.ny9
      xml.ny10 subarea.ny10
      xml.xtp1 subarea.xtp1
      xml.xtp2 subarea.xtp2
      xml.xtp3 subarea.xtp3
      xml.xtp4 subarea.xtp4
      xml.xtp5 subarea.xtp5
      xml.xtp6 subarea.xtp6
      xml.xtp7 subarea.xtp7
      xml.xtp8 subarea.xtp8
      xml.xtp9 subarea.xtp9
      xml.xtp10 subarea.xtp10
    } # xml each subarea end
  end

  #def save_chart_information(xml, chart)
    #xml.chart {
      #xml.description_id chart.description_id
      #xml.watershed_id chart.watershed_id
      #xml.scenario_id chart.scenario_id
      #xml.field_id chart.field_id
      #xml.soil_id chart.soil_id
      #xml.month_year chart.month_year
      #xml.value chart.value
      #xml.crop_id chart.crop_id
    #} # xml each chart_info end
  #end

  def save_climate_information(xml, climate)
    xml.climate {
      xml.max_temp climate.max_temp
      xml.min_temp climate.min_temp
      xml.month climate.month
      xml.precipitation climate.precipitation
    } # xml each climate end
  end

  def save_watershed_information(xml, watershed)
    xml.watershed {
      xml.name watershed.name
      if watershed.last_simulation != nil then
        xml.last_simulation watershed.last_simulation
      end
      watershed_scenarios = WatershedScenario.where(:watershed_id => watershed.id)
      xml.watershed_scenarios {
        watershed_scenarios.each do |wss|
          save_watershed_scenario_information(xml, wss)
        end # end scenarios each
      } # end scenarios

    results = watershed.annual_results
      xml.results {
        results.each do |result|
          save_result_information(xml, result)
        end # end results.each
      } # end xml.results

      crops = watershed.crop_results
      xml.crop_results {
        crops.each do |crop|
          save_crop_result_information(xml, crop)
        end # end charts.each
      } # end xml.charts
    } # xml each watershed end
  end

  def save_watershed_scenario_information(xml, watershed_scenario)
    xml.watershed_scenario {
      xml.field_id watershed_scenario.field_id
      xml.scenario_id watershed_scenario.scenario_id
    }
  end  # end method

  def save_timespan_information(xml, timespan)
    xml.timespan {
      xml.crop_id timespan.crop_id
      xml.bmp_id timespan.bmp_id
      xml.start_month timespan.start_month
      xml.start_day timespan.start_day
      xml.end_month timespan.end_month
      xml.end_day timespan.end_day
    }
  end

  private
  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def project_params
    params.require(:project).permit(:description, :name)
  end

  def sortable_columns
    [["Project Name"], "Date Created"]
  end

  def sort_column
    if params[:column] != nil
      case params[:column].downcase
        when t('project.project_name').downcase
          return "name"
        #when t('general.last_modified')
        when t('pdf.date_created').downcase
          return "created_at"
        when t('models.user') .downcase
          return "user_id"
      end
    end
    return "name"
    #sortable_columns.include?(params[:column]) ? params[:column] : "Name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def upload_project_info(node)
    #begin  #check this one
      @project = Project.new
      @project.user_id = session[:user_id]
      node.elements.each do |p|
        
        case p.name
          when "projectName"
            @project.name = p.text
          when "Description"
            @project.description = p.text
        end
      end
      @project.version = "NTTG3"
      if @project.save then
        msg = upload_location_info(node)
        msg = upload_weather_info(node)
        return "OK"
      else
        return "Error saving project"
      end
    #rescue
      #return 'Error saving project'
    #end
  end

  def upload_project_new_version(node)
    #begin
      @project = Project.new
      @project.user_id = session[:user_id]
      node.elements.each do |p|
        case p.name
        when "project_name" #if project name exists, save fails
          @project.name = p.text
          if params[:examples] == "2"
            @project.name = @project.name + " copy"
          end
        when "project_description"
          @project.description = p.text
        end
      end
      @project.version = "NTTG3"
      if @project.save
        #session[:project_id] = @project.id
        return "OK"
      else
        return t('project.project_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
      end
    #rescue
      #return t('activerecord.errors.messages.projects.no_saved')
    #end
  end

  def upload_project_comet_version(node)
    #begin
    @project = Project.new
    @project.user_id = session[:user_id]
    @initial_year = 0
    @number_years = 0
    node.elements.each do |p|
      case p.name
        when "ProjectName" #if project name exists, save fails
          @project.name = p.text
        when "project_description"
          @project.description = @project.name + " from Comet"
      end
    end
    @project.version = "Comet"
    @project.description = @project.name + " from Comet"
    if @project.save
      location = Location.new
      location.project_id = @project.id
      node.elements.each do |p|
        case p.name
          when "State"
            state_id = State.find_by_state_abbreviation(p.text).id
            location.state_id = state_id
          when "County"
            county_id = County.find_by_county_state_code(p.text).id
            location.county_id = county_id
          when "Status"
            location.status = p.text
          when "InitialYear"
            @initial_year = p.text
          when "NumberOfYears"
            @number_years = p.text
        end   # end case 
      end   # end node.elements
      if location.save
        @location = location
        return "OK"
      else
        return t('activerecord.errors.messages.projects.no_saved') + " - " + t('activerecord.errors.messages.projects.exist')
      end
    end   # end if Save
    #rescue
    return t('project.project_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
    #end
  end

  def upload_field_comet_version(node)
    field_id = Hash.new
    field = Field.new
    old_field_id = 0
    field.location_id = @location.id
    scenario = Scenario.new
    node.elements.each do |p|
      case p.name
      when "Field_id"
        field.field_name = p.text
      when "Area"
        field.field_area = p.text   # value es received in ac.
        #field.field_area = field.field_area / HA_TO_AC   #convert to acres.
      when "field_average_slope"
        field.field_average_slope = p.text
      when "Type"
        field.field_type = nil
      when "SoilP"
        field.soilp = p.text
      when "Aluminum"
        field.soil_aliminum = p.text
        if field.soil_aliminum == nil or field.soil_aliminum == "" then field.soil_aliminum = 0 end
      when "SoilP_type"
        field.soil_test = p.text
      when "Coordinates"
        @location.coordinates = p.text
        @location.save
        field.coordinates = p.text
        centroid = calculate_centroid(field.coordinates)
        #add weather
        @weather = Weather.new
        @weather.way_id = 1
        @weather.station_way ="map"
        msg = save_prism(field.coordinates)
        #@weather.weather_file = "No set Yet"
        #@weather.weather_initial_year = @initial_year
        #@weather.weather_final_year = @initial_year + @number_years
        #@weather.simulation_initial_year = @weather.weather_initial_year + 5
        #@weather.simulation_final_year = @weather.weather_final_year 
        #@weather.save
        field.weather_id = @weather.id
        if field.save! then
          #save weathr again to take field.id
          @weather.field_id = field.id
          @weather.save
          session[:field_id] = field.id
          field_id[old_field_id] = field.id
          #@field_ids.push(field_id)
          @field = Field.find(session[:field_id])
          #now create scenario and save it
          scenario.field_id = field.id
          scenario.name = "Scenario1"
          scenario.save
          #add soils
          request_soils()
          #save parameters and controls
          load_parameters(0)
          load_controls
          #update the initial year and years of simulation with the ones uploaded
          @project.apex_controls[1].value = @initial_year
          @project.apex_controls[1].save
          @project.apex_controls[0].value = @number_years
          @project.apex_controls[0].save
          #create site file
          site = Site.new
          site.field_id = field.id
          site.apm = 1
          site.co2x = 0
          site.cqnx = 0
          site.elev = 0
          site.fir0 = 0
          site.rfnx = 0
          site.unr = 0
          site.upr = 0
          #centroid = calculate_centroid()
          site.ylat = centroid.cy
          site.xlog = centroid.cx
          site.save
          #add soil p to layer         
          soils = @field.soils
          if field.soil_test != nil then
            soil_test = SoilTest.find(field.soil_test)
          else
            field.soilp = 0
          end
          soils.each do |soil|
            layer = soil.layers[0]
            if soil_test.id == 7 then
              layer.soil_p = soil_test.factor2 * field.soilp - soil_test.factor1 * layer.ph - 32.757 * (field.soil_aliminum) + 90.73
            else
              layer.soil_p = soil_test.factor1 + soil_test.factor2 * field.soilp
            end
            layer.save
          end
        else
          return "field could not be saved"
        end
      when "OperationInfo"
          upload_operation_comet_version(scenario.id, p.elements)
      when "BmpInfo"
        upload_bmp_comet_version(scenario.id, p.elements)
      end
    end
    return "OK"
  end

  def upload_location_info(node)
    location = Location.new
    location.project_id = @project.id
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
    return "OK"
    else
      return "location could not be saved"
    end
  end

  def upload_location_info1(node)
    begin
      location = Location.find(session[:location_id])
      node.elements.each do |p|
        
        case p.name
          when "Coordinates"
            location.coordinates = p.text
        end
      end
      if location.save
    session[:location_id] = location.id
    return "OK"
    end
    rescue
      return "Location could not be saved"
    end
  end

  def upload_location_new_version(node)
    #begin  #TODO CHECK THIS ONE. WHEN IT IS ACTIVE THE PROCCESS DOES NOT RUN FOR SOME REASON.
      msg = "OK"
      location = Location.new
      location.project_id = @project.id
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
              #create an array of hashes to hold the old field id and the new field id to use in the watershed download
              @field_ids = Array.new
              @scenario_ids = Array.new
              session[:location_id] = location.id
              p.elements.each do |f|
                msg = upload_field_new_version(f)
              end
            else
              return "location could not be saved " + msg
            end  # end location.save
          when "watersheds"
            p.elements.each do |ws|
              watershed_id = upload_watershed_information_new_version(location.id, ws)
            end
        end # end case p.name
      end # end node.elements do
      #rescue
      #msg = 'Location could not be saved'
    #end
    return msg
  end

  def upload_field_info(node)   
    #begin
    field = Field.new
    field.location_id = session[:location_id]
    node.elements.each do |p|        
      case p.name
        when "Forestry"
          if p.text == "True" then
            field.field_type = true
          else
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
    session[:field_id] = field.id
    #rescue
      #return "Field could not be saved"
    #end
    begin
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
      if weather.save then
        field.weather_id = weather_id
        field.save
      else
        return "Weather could not be saved"
      end
    rescue
      return "Weather could not be saved"
    end
  end

  def upload_field_new_version(node)
    field_id = Hash.new
    field = Field.new
    old_field_id = 0
    field.location_id = session[:location_id]
    node.elements.each do |p|
      case p.name
      when "id"
        old_field_id = p.text
      when "field_name"
        field.field_name = p.text
      when "field_area"
        field.field_area = p.text
      when "field_average_slope"
        field.field_average_slope = p.text
      when "field_type"
        field.field_type = p.text
      when "soilp"
        field.soilp = p.text
      when "soil_aliminum"
        field.soil_aliminum = p.text
      when "soil_test"
        field.soil_test = p.text
      when "coordinates"
        field.coordinates = p.text
        if field.save! then
          session[:field_id] = field.id
          field_id[old_field_id] = field.id
          @field_ids.push(field_id)
        else
          return "field could not be saved"
        end
      when "climes"
        p.elements.each do |f|
          #msg = "OK"
          msg = upload_clime_new_version(field.id, f)
          if msg != "OK"
            return msg
          end
        end
      when "weather"
        msg = upload_weather_new_version(p, field.id)
        if msg != "OK"
          return msg
        end
      when "site"
        msg = upload_site_new_version(p, field.id)
        if msg != "OK"
          return msg
        end
      when "soils"
        p.elements.each do |f|
          msg = upload_soil_new_version(field.id, f)
          if msg != "OK"
            return msg
          end
        end
      when "scenarios"
        #create and array and hash to have the new and the old scenario id to use in watersheds.
        p.elements.each do |f|
          scenario_id = upload_scenario_new_version(field.id, f)
          if scenario_id == nil then
            return "scenario could not be saved"
          end
        end
        field.soils.update_all(:soil_id_old => nil)
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
          @weather["weather_file"] = "N" + file_name[1]
        when "StationWay"
          if p.text == "googleMap" then
            way_id = Way.find_by_way_value("Prism").id
          else
            way_id = Way.find_by_way_value(p.text).id
          end
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

  def upload_site_info(node)
    begin
      fields = Field.where(:location_id => session[:location_id])
      fields.each do |field|
        site = Site.new
        site.field_id = field.id
        site.fir0 = 0
        node.elements.each do |p|
          case p.name
            when "Apm"
              site.apm = p.text
            when "Co2x"
              site.co2x = p.text
            when "Cqnx"
              site.cqnx = p.text
            when "Elevation"
              site.elev = p.text
            when "Rfnx"
              site.rfnx = p.text
            when "Unr"
              site.unr = p.text
            when "Upr"
              site.upr = p.text
            when "Longitude"
              site.xlog = p.text
              if site.xlog == 0 then
                site.xlog = Weather.find_by_field_id(field.id).longitude
              end
            when "Latitude"
              site.ylat = p.text
              if site.ylat == 0 then
                site.ylat = Weather.find_by_field_id(field.id).latitude
              end
          end # end case p.name
        end # end nodel.elements
        if !site.save then
          return "site could not be saved"
        end
      end # each field
      return "OK"
    rescue
      return "Site could not be saved"
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
          if site.xlog = 0
            site.xlog = Weather.find_by_field_id(field_id).longitude
          end
        when "ylat"
          site.ylat = p.text
          if site.ylat = 0
            site.ylat = Weather.find_by_field_id(field_id).latitude
          end
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
          else
            return
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
      case soil.wtmx
      when 5
        soil.drainage_id = 2
      when 6
        soil.drainage_id = 3
      else
        soil.drainage_id = 1
      end #case soil.wtmx
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
            return "Error uploading soil"
          end
      end
    end
  end

  def upload_clime_new_version(field_id, node)
    clime = Clime.new
    clime.field_id = field_id
    node.elements.each do |p|
      case p.name
        when "daily_weather"
          clime.daily_weather = p.text
      end # end case      
    end   # end node
    if clime.save
      return "OK"
    else
      return "Weather uploaded record could not be saved"
    end
  end  # end def

  def upload_soil_new_version(field_id, node)
    soil = Soil.new
    soil.field_id = field_id
    soil.selected = false
    node.elements.each do |p|
      case p.name
        when "id"
          soil.soil_id_old = p.text
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
        when "drainage_id"
          soil.drainage_id = p.text
        when "layers"
          if soil.save
            p.elements.each do |f|
              msg = upload_layer_new_version(soil.id, f)
              if msg != "OK"
                return msg
              end
            end
          end
        when "ffc"
          soil.ffc = p.text
        when "wtmn"
          soil.wtmn = p.text
        when "wtmx"
          soil.wtmx = p.text
        when "wtbl"
          soil.wtbl = p.text
        when "gwst"
          soil.gwst = p.text
        when "gwmx"
          soil.gwmx = p.text
        when "rft"
          soil.rft = p.text
        when "rfpk"
          soil.rfpk = p.text
        when "tsla"
          soil.tsla = p.text
        when "xids"
          soil.xids = p.text
        when "rtn1"
          soil.rtn1 = p.text
        when "xidk"
          soil.xidk = p.text
        when "zqt"
          soil.zqt = p.text
        when "zf"
          soil.zf = p.text
        when "ztk"
          soil.ztk = p.text
        when "fbm"
          soil.fbm = p.text
        when "fhp"
          soil.fhp = p.text
      end # case end
    end # each element end
    if soil.save
      return "OK"
    else
      return "Soil could not be saved"
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
        when "uw"
          layer.uw = p.text
        when "fc"
          layer.fc = p.text
        when "wn"
          layer.wn = p.text
        when "smb"
          layer.smb = p.text
        when "woc"
          layer.woc = p.text
        when "cac"
          layer.cac = p.text
        when "cec"
          layer.cec = p.text
        when "rok"
          layer.rok = p.text
        when "cnds"
          layer.cnds = p.text
        when "rsd"
          layer.rsd = p.text
        when "bdd"
          layer.bdd = p.text
        when "psp"
          layer.psp = p.text
        when "satc"
          layer.satc = p.text
        when "soil_aliminum"
          layer.soil_aluminum = p.text
        when "soil_test_id"
          layer.soil_test_id = p.text
        when "soil_p_initial"
          layer.soil_p_initial = p.text
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
            scenario.name = p.text
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
            #upload_result_info(p, field_id, soil_id, scenario_id)
          else
            return "Error saving scenario"
          end
      end
    end
    return "OK"
  end

  def upload_scenario_new_version(field_id, new_scenario)
    msg = "OK"
    scenario_id = Hash.new
    scenario = Scenario.new
    scenario.field_id = field_id
    old_scenario_id = 0
    new_scenario.elements.each do |p|
      case p.name
      when "id"
        old_scenario_id = p.text
      when "name"
        scenario.name = p.text
        if !scenario.save then
          return "scenario could not be saved"
        end
      when "last_simulation"
        scenario.last_simulation = p.text
        if !scenario.save then
          return "scenario could not be saved"
        end
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
      when "results"
        p.elements.each do |r|
          msg = upload_result_new_version(scenario.id, 0, field_id, r)
          if msg != "OK"
            return msg
          end
        end
      when "crop_results"
        p.elements.each do |r|
          msg = upload_crop_result_new_version(scenario.id, 0, field_id, r)
          if msg != "OK"
            return msg
          end
        end
      when "subareas"
        p.elements.each do |sa|
          msg = upload_subarea_new_version(0, scenario.id, sa)
          if msg != "OK"
            return msg
          end
        end
      end
    end
    if !scenario.save then
      return "scenario could not be saved"
    end
    scenario_id[old_scenario_id] = scenario.id
    @scenario_ids.push(scenario_id)
    return msg
  end

  def upload_subarea_info(node, scenario_id, soil_id)
    subarea = Subarea.new
    subarea.soil_id = soil_id
    subarea.scenario_id = scenario_id
    subarea.ny5 = 0
    subarea.ny6 = 0
    subarea.ny7 = 0
    subarea.ny8 = 0
    subarea.ny9 = 0
    subarea.ny10 = 0
    subarea.xtp5 = 0
    subarea.xtp6 = 0
    subarea.xtp7 = 0
    subarea.xtp8 = 0
    subarea.xtp9 = 0
    subarea.xtp10 = 0
    node.elements.each do |p|
      case p.name
        when "SbaType"
          subarea.subarea_type = p.text
        when "SubareaTitle"
          subarea.description = p.text
        when "SubareaNumber"
          subarea.number = p.text
        when "Inps"
          subarea.inps = @inps1
        when "Iops"
          subarea.iops = subarea.inps
        when "Iow"
          subarea.iow = subarea.inps
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
        when "Rsbd"
          subarea.rsbd = p.text
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
        when "Armn"
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
      return "Error loading subareas"
    end
  end

  def upload_subarea_new_version(bmp_id, scenario_id, node)
    subarea = Subarea.new
    subarea.scenario_id = scenario_id
    subarea.bmp_id = bmp_id
    #subarea.soil_id = soil_id
    subarea.ny5 = 0
    subarea.ny6 = 0
    subarea.ny7 = 0
    subarea.ny8 = 0
    subarea.ny9 = 0
    subarea.ny10 = 0
    subarea.xtp5 = 0
    subarea.xtp6 = 0
    subarea.xtp7 = 0
    subarea.xtp8 = 0
    subarea.xtp9 = 0
    subarea.xtp10 = 0
    node.elements.each do |p|
      case p.name
        when "subarea_type"
          subarea.subarea_type = p.text
        when "description"
          subarea.description = p.text
        when "bmp_id"
          subarea.bmp_id = bmp_id
        when "soil_id"
          if p.text == "0"
            subarea.soil_id = 0
          else
            soil = Soil.find_by_soil_id_old(p.text)
            if soil == nil then
              next
            else
              subarea.soil_id = soil.id
              #soil.soil_id_old = 0
            end
          end
        when "number"
          subarea.number = p.text
        when "inps"
          subarea.inps = p.text
        when "iops"
          subarea.iops = p.text
        when "iow"
          subarea.iow = p.text
        when "ii"
          subarea.ii = p.text
        when "iapl"
          subarea.iapl = p.text
        when "nvcn"
          subarea.nvcn = p.text
        when "iwth"
          subarea.iwth = p.text
        when "ipts"
          subarea.ipts = p.text
        when "isao"
          subarea.isao = p.text
        when "luns"
          subarea.luns = p.text
        when "imw"
          subarea.imw = p.text
        when "sno"
          subarea.sno = p.text
        when "stdo"
          subarea.stdo = p.text
        when "yct"
          subarea.yct = p.text
        when "xct"
          subarea.xct = p.text
        when "azm"
          subarea.azm = p.text
        when "fl"
          subarea.fl = p.text
        when "fw"
          subarea.fw = p.text
        when "angl"
          subarea.angl = p.text
        when "wsa"
          subarea.wsa = p.text
        when "chl"
          subarea.chl = p.text
        when "chd"
          subarea.chd = p.text
        when "chs"
          subarea.chs = p.text
        when "chn"
          subarea.chn = p.text
        when "slp"
          subarea.slp = p.text
        when "splg"
          subarea.splg = p.text
        when "upn"
          subarea.upn = p.text
        when "ffpq"
          subarea.ffpq = p.text
        when "urbf"
          subarea.urbf = p.text
        when "rchl"
          subarea.rchl = p.text
        when "rchd"
          subarea.rchd = p.text
        when "rcbw"
          subarea.rcbw = p.text
        when "rctw"
          subarea.rctw = p.text
        when "rchs"
          subarea.rchs = p.text
        when "rchn"
          subarea.rchn = p.text
        when "rchc"
          subarea.rchc = p.text
        when "rchk"
          subarea.rchk = p.text
        when "rfpw"
          subarea.rfpw = p.text
        when "rfpl"
          subarea.rfpl = p.text
        when "rsee"
          subarea.rsee = p.text
        when "rsae"
          subarea.rsae = p.text
        when "rsve"
          subarea.rsve = p.text
        when "rsep"
          subarea.rsep = p.text
        when "rsap"
          subarea.rsap = p.text
        when "rsvp"
          subarea.rsvp = p.text
        when "rsv"
          subarea.rsv = p.text
        when "rsrr"
          subarea.rsrr = p.text
        when "rsys"
          subarea.rsys = p.text
        when "rsyn"
          subarea.rsyn = p.text
        when "rshc"
          subarea.rshc = p.text
        when "rsdp"
          subarea.rsdp = p.text
        when "rsbd"
          subarea.rsbd = p.text
        when "pcof"
          subarea.pcof = p.text
        when "bcof"
          subarea.bcof = p.text
        when "bffl"
          subarea.bffl = p.text
        when "nirr"
          subarea.nirr = p.text
        when "iri"
          subarea.iri = p.text
        when "ira"
          subarea.ira = p.text
        when "lm"
          subarea.lm = p.text
        when "ifd"
          subarea.ifd = p.text
        when "idr"
          subarea.idr = p.text
        when "idf1"
          subarea.idf1 = p.text
        when "idf2"
          subarea.idf2 = p.text
        when "idf3"
          subarea.idf3 = p.text
        when "idf4"
          subarea.idf4 = p.text
        when "idf5"
          subarea.idf5 = p.text
        when "bir"
          subarea.bir = p.text
        when "efi"
          subarea.efi = p.text
        when "vimx"
          subarea.vimx = p.text
        when "armn"
          subarea.armn = p.text
        when "armx"
          subarea.armx = p.text
        when "bft"
          subarea.bft = p.text
        when "fnp4"
          subarea.fnp4 = p.text
        when "fmx"
          subarea.fmx = p.text
        when "drt"
          subarea.drt = p.text
        when "fdsf"
          subarea.fdsf = p.text
        when "pec"
          subarea.pec = p.text
        when "dalg"
          subarea.dalg = p.text
        when "vlgn"
          subarea.vlgn = p.text
        when "coww"
          subarea.coww = p.text
        when "ddlg"
          subarea.ddlg = p.text
        when "solq"
          subarea.solq = p.text
        when "sflg"
          subarea.sflg = p.text
        when "fnp2"
          subarea.fnp2 = p.text
        when "fnp5"
          subarea.fnp5 = p.text
        when "firg"
          subarea.firg = p.text
        when "ny1"
          subarea.ny1 = p.text
        when "ny2"
          subarea.ny2 = p.text
        when "ny3"
          subarea.ny3 = p.text
        when "ny4"
          subarea.ny4 = p.text
        when "ny5"
          subarea.ny5 = p.text
        when "ny6"
          subarea.ny6 = p.text
        when "ny7"
          subarea.ny7 = p.text
        when "ny8"
          subarea.ny8 = p.text
        when "ny9"
          subarea.ny9 = p.text
        when "ny10"
          subarea.ny10 = p.text
        when "xtp1"
          subarea.xtp1 = p.text
        when "xtp2"
          subarea.xtp2 = p.text
        when "xtp3"
          subarea.xtp3 = p.text
        when "xtp4"
          subarea.xtp4 = p.text
        when "xtp5"
          subarea.xtp5 = p.text
        when "xtp6"
          subarea.xtp6 = p.text
        when "xtp7"
          subarea.xtp7 = p.text
        when "xtp8"
          subarea.xtp8 = p.text
        when "xtp9"
          subarea.xtp9 = p.text
        when "xtp10"
          subarea.xtp10 = p.text
      end #end case
    end #end each
    if subarea.save then
      return "OK"
    else
      return "Error loading subareas"
    end
  end

  def upload_soil_operation_info(node, scenario_id, soil_id)
    soil_operation = SoilOperation.new
    soil_operation.soil_id = soil_id
    soil_operation.scenario_id = scenario_id
    node.elements.each do |p|
      case p.name
        when "EventId" #use to take the event id to be able to match this operation with the operations in scenarios
          soil_operation.tractor_id = p.text
        when "Year"
          soil_operation.year = p.text
        when "Month"
          soil_operation.month = p.text
        when "Day"
          soil_operation.day = p.text
        when "operation_id"
          #todo this need to be taken from operation table
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
          soil_operation.activity_id = Activity.find_by_abbreviation(p.text.strip).id
        when "ApexTillCode"
          soil_operation.apex_operation = p.text
          if soil_operation.activity_id == 4 then
            crop_state = Crop.where(:number => soil_operation.apex_crop, :state_id => Location.find(session[:location_id]).state_id).first
            if crop_state == nil then
              crop_state = Crop.where(:number => soil_operation.apex_crop, :state_id => "**").first
            end
          soil_operation.apex_operation = crop_state.harvest_code
          end
      end
    end
    if soil_operation.save then
      return "OK"
    else
      return "Error loading operations"
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
      when "EventId" #use to take the event id to be able to match this operation with the operations in scenarios
        #look for the same opeerations in in the SoilOperation table to add the operation id
        event_id = p.text
      when "ApexOpAbbreviation"
        operation.activity_id = Activity.find_by_abbreviation(p.text.strip).id
      when "Year"
        operation.year = p.text
      when "Month"
        operation.month_id = p.text
      when "Day"
        operation.day = p.text
      when "ApexCrop"
        operation.crop_id = Crop.find_by_number(p.text).id
      when "NO3"
        operation.no3_n = p.text.to_f * 100
      when "PO4"
        operation.po4_p = p.text.to_f * 100
      when "OrgN"
        operation.org_n = p.text.to_f * 100
      when "OrgP"
        operation.org_p = p.text.to_f * 100
      when "ApexOpv1"
        operation.amount = p.text
        if operation.activity_id == 1 then (operation.amount /= AC_TO_FT2).round(2) end
      when "ApexOpv2"
        operation.depth = p.text
      when "ApexTillCode"
        apex_till_code = p.text.to_i
      when "ApexTillName"
        case operation.activity_id
        when 1 #planting
          operation.type_id = apex_till_code
        when 3 #tillage
            operation.type_id = apex_till_code
        when 2 # fertilizer
          if p.text == "Commercial Fertilizer"
            operation.type_id = 1
            operation.subtype_id = 1
          else
            operation.type_id = 2
            operation.subtype_id = 56
          end  # end if p.text
        when 7  # Grazing
          operation.type_id = Fertilizer.find_by_name(p.text.upcase).code
        end # end activity_id
      end # case p.name
    end # end each
    if operation.save then
      soils = Soil.where(:field_id => field_id)
      soils.each do |soil|
        soil_operation = SoilOperation.where(:soil_id => soil.id, :scenario_id => scenario_id, :tractor_id => event_id).first
        soil_operation.operation_id = operation.id
        soil_operation.save
      end # end soils.each
      return "OK"
    else
      return "Error saving Operation"
    end
  end

  def upload_operation_new_version(scenario_id, new_operation)
    operation = Operation.new
    operation.scenario_id = scenario_id
    operation.save
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
        when "amount", "amout"
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
        when "moisture"
          operation.moisture = p.text
        when "org_c"
          operation.org_c = p.text
        when "rotation"
          operation.rotation = p.text
        when "soil_operations"
          p.elements.each do |soil_op|
            msg = upload_soil_operation_new(soil_op, scenario_id, 0, operation.id, 0)
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

  def add_soil_operation(operation,carbon)
      soils = @field.soils
      msg = "OK"
      soils.each do |soil|
        if msg.eql?("OK")
          msg = update_soil_operation(SoilOperation.new, soil.id, operation,carbon)
        else
          break
        end
      end
      return msg
  end

  def upload_result_info(node, field_id, soil_id, scenario_id)
    node.elements.each do |p|
      case p.name
      when "Crops"
        #upload_crop_soil_result_info(p, field_id, soil_id, scenario_id)
      when "Soil"
        upload_soil_result_info(p, field_id, soil_id, scenario_id)
      when "lastSimulation"
        sc = Scenario.find(scenario_id)
        sc.last_simulation = p.text
        sc.save
      end # end case p.name
    end # end node.elements.each
  end
  # end method

  def upload_result_new_version(scenario_id, watershed_id, field_id, new_result)
    result = AnnualResult.new
    result.scenario_id = scenario_id
    result.watershed_id = watershed_id
    #result.field_id = field_id
    new_result.elements.each do |p|
      case p.name
      when "sub1"
        result.sub1 = p.text
      when "year"
        result.year = p.text
      when "flow"
        result.flow = p.text
      when "qdr"
        result.qdr = p.text
      when "surface_flow"
        result.surface_flow = p.text
      when "sed"
        result.sed = p.text
      when "ymnu"
        result.ymnu = p.text
      when "orgp"
        result.orgp = p.text
      when "po4"
        result.po4 = p.text
      when "orgn"
        result.orgn = p.text
      when "no3"
        result.no3 = p.text
      when "qdrn"
        result.qdrn = p.text
      when "qdrp"
        result.qdrp = p.text
      when "qn"
        result.qn = p.text
      when "dprk"
        result.dprk = p.text
      when "irri"
        result.irri = p.text
      when "pcp"
        result.pcp = p.text
      when "n2o"
        result.n2o = p.text
      when "prkn"
        result.prkn = p.text
      when "co2"
        result.co2 = p.text
      when "biom"
        result.biom = p.text
      end # end case
    end # end each
    if result.save
      return "OK"
    else
      return "Result could not be saved"
    end
  end

  def upload_soil_result_info(node, field_id, soil_id, scenario_id)
    #tile drain flow is duplicated in the old version NTTG2 VB. So is needed to control that the second one is not used
    tile_drain = false
    total_n = 0
    #total_n_ci = 0
    total_p = 0
    #total_p_ci = 0
    total_runoff = 0
    #total_runoff_ci = 0
    total_other_water = 0
    #total_other_water_ci = 0
    total_sediment = 0
    #total_sediment_ci = 0
    node.elements.each do |p|
      case p.name
        when "OrgN"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 21)
          total_n = total_n + @result.value
        when "OrgNCI"
          @result.ci_value = p.text
          @result.save
          total_n_ci = total_n_ci + @result.ci_value
        when "runoffN"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 22)
          total_n = total_n + @result.value
        when "runoffNCI"
          @result.ci_value = p.text
          @result.save
          total_n_ci = total_n_ci + @result.ci_value
        when "subsurfaceN"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 23)
          total_n = total_n + @result.value
        when "subsurfaceNCI"
          @result.ci_value = p.text
          @result.save
          total_n_ci = total_n_ci + @result.ci_value
        when "OrgP"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 31)
          total_p = total_p + @result.value
        when "OrgPCI"
          @result.ci_value = p.text
          @result.save
          total_p_ci = total_p_ci + @result.ci_value
        when "PO4"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 32)
          total_p = total_p + @result.value
        when "PO4CI"
          @result.ci_value = p.text
          @result.save
          total_p_ci = total_p_ci + @result.ci_value
        when "runoff"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 41)
         total_runoff = total_runoff + @result.value
        when "runoffCI"
          @result.ci_value = p.text
          @result.save
          total_runoff_ci = total_runoff_ci + @result.ci_value
        when "subsurfaceFlow"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 42)
          total_runoff = total_runoff + @result.value
        when "subsurfaceFlowCI"
          @result.ci_value = p.text
          @result.save
          total_runoff_ci = total_runoff_ci + @result.ci_value
        when "tileDrainFlow"
          if tile_drain == false then
            @result = add_result(field_id, soil_id, scenario_id, p.text, 43)
            total_runoff = total_runoff + @result.value
          end
        when "tileDrainFlowCI"
          if tile_drain == false then
            tile_drain = true
            @result.ci_value = p.text
            @result.save
            total_runoff_ci = total_runoff_ci + @result.ci_value
          end
        when "irrigation"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 51)
          total_other_water = total_other_water + @result.value
        when "irrigationCI"
          @result.ci_value = p.text
          @result.save
          total_other_water_ci = total_other_water_ci + @result.value
        when "deepPerFlow"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 52)
          total_other_water = total_other_water + @result.value
        when "deepPerFlowCI"
          @result.ci_value = p.text
          @result.save
          total_other_water_ci = total_other_water_ci + @result.ci_value
        when "Sediment"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 61)
          total_sediment = total_sediment + @result.value
        when "SedimentCI"
          @result.ci_value = p.text
          @result.save
          total_sediment_ci = total_sediment_ci + @result.ci_value
          #add manure. It is not in the old version projects
          @result = add_result(field_id, soil_id, scenario_id, 0, 62)
          total_sediment = total_sediment + @result.value
          @result.ci_value = 0
          @result.save
          total_sediment_ci = total_sediment_ci + @result.ci_value
        when "Manure" # just in case this exist in some projects the values for manuer (62) are updated
          @result = Result.where(:field_id => field_id, :soil_id => soil_id, :scenario_id => scenario_id, description_id => 62)
          if @result != nil then
            @result.value = p.text
          end
        when "ManureCI" # just in case this exist in some projects the values for manuer (62) are updated
          @result = Result.where(:field_id => field_id, :soil_id => soil_id, :scenario_id => scenario_id, description_id => 62)
          if @result != nil then
            @result.ci_value = p.text
          end
        when "tileDrainN"
          @result = add_result(field_id, soil_id, scenario_id, p.text, 24)
          total_n = total_n + @result.value
        when "tileDrainP"
          @result1 = add_result(field_id, soil_id, scenario_id, p.text, 33)
          total_p = total_p + @result1.value
        when "tileDrainNCI"
          @result.ci_value = p.text
          @result.save
          total_n_ci = total_n_ci + @result.value
        when "tileDrainPCI"
          @result1.ci_value = p.text
          @result1.save
          total_p_ci = total_p_ci + @result1.ci_value
        when "annualFlow"
          #upload_chart_info(p, field_id, 0, scenario_id, 41)
        when "annualNO3"
          #upload_chart_info(p, field_id, 0, scenario_id, 22)
        when "annualOrgN"
          #upload_chart_info(p, field_id, 0, scenario_id, 21)
        when "annualOrgP"
          #upload_chart_info(p, field_id, 0, scenario_id, 31)
        when "annualPO4"
          #upload_chart_info(p, field_id, 0, scenario_id, 32)
        when "annualSediment"
          #upload_chart_info(p, field_id, 0, scenario_id, 61)
        when "annualPrecipitation"
          #upload_chart_info(p, field_id, 0, scenario_id, 100)
        when "annualCropYield"
          #p.elements.each do |p|
          #upload annual crops
          #upload_chart_crop_info(p, field_id, 0, scenario_id)
        #end
      end # end case p.name
    end # end node.elements.each
    #add total n
    @result = add_result(field_id, soil_id, scenario_id, total_n, 20)
    @result.ci_value = total_n_ci
    @result.save
    #add total p
    @result = add_result(field_id, soil_id, scenario_id, total_p, 30)
    @result.ci_value = total_p_ci
    @result.save
    #add total runoff
    @result = add_result(field_id, soil_id, scenario_id, total_runoff, 40)
    @result.ci_value = total_runoff_ci
    @result.save
    #add total other water information
    @result = add_result(field_id, soil_id, scenario_id, total_other_water, 50)
    @result.ci_value = total_other_water_ci
    @result.save
    #add total sediment
    @result = add_result(field_id, soil_id, scenario_id, total_sediment, 60)
    @result.ci_value = total_sediment_ci
    @result.save
    #add total crop (zeros because crop are not totalized
    @result = add_result(field_id, soil_id, scenario_id, 0, 70)
    @result.save
    #add total area
    @result = add_result(field_id, soil_id, scenario_id, Field.find(field_id).field_area, 10)
    #@result.save
    #save result id for total area in order to substract the bmp buffer areas from it.
    @result_id = @result.id
  end

  def add_result(field_id, soil_id, scenario_id, p_text, description_id)
    result = AnnualResult.new
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
  end

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
          #upload_result_info(p, field_id, 0, scenario_id)
        when "Bmps"
          scenario_id = Scenario.find_by_field_id_and_name(field_id, name).id
          upload_bmp_info(p, scenario_id)
      end #end case
    end ## end each
  end

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
    node.elements.each do |p1|
      p1.elements.each do |p|
        case p.name
          when "cropName"
            #todo add controls
          when "cropYield"
            chart = Chart.new
            chart.field_id = field_id
            chart.soil_id = soil_id
            chart.scenario_id = scenario_id
            chart.description_id = 71 #todo increase if more than one crop
            chart.month_year = month_year
            chart.value = p.text
            chart.save
            if i < 12 then
              month_year += 1
            else
              return
            end
            i +=1
        end # end case p.name
      end # end p1.elements.each
    end # end node each
  end

  def upload_crop_result_new_version(scenario_id, watershed_id, field_id, new_crop)
    result = CropResult.new
    result.scenario_id = scenario_id
    result.watershed_id = watershed_id
    #chart.field_id = field_id
    new_crop.elements.each do |p|
      case p.name
      when "name"
        result.name = p.text
      when "sub1"
        result.sub1 = p.text
      when "year"
        result.year = p.text
      when "yldg"
        result.yldg = p.text
      when "yldf"
        result.yldf = p.text
      when "ws"
        result.ws = p.text
      when "ns"
        result.ns = p.text
      when "ps"
        result.ps = p.text
      when "ts"
       result.ts = p.text
      end # end case
    end # end each
    if result.save
      return "OK"
    else
      return "crop result could not be saved"
    end
  end

  # p, field_id, 0, scenario_id
  def upload_bmp_info(node, scenario_id)
    node.elements.each do |p|
      case p.name
        when "AIType"
          if p.text.to_i > 0
            upload_bmp_ai(node, scenario_id)
          end
        when "AFType"
          if p.text.to_i > 0
            upload_bmp_af(node, scenario_id)
          end
        when "TileDrainDepth"
          if p.text.to_f > 0
            upload_bmp_td(node, scenario_id)
          end
        when "PPNDWidth"
          if p.text.to_f > 0
            upload_bmp_ppnd(node, scenario_id)
          end
        when "PPDSWidth"
          if p.text.to_f > 0
            upload_bmp_ppds(node, scenario_id)
          end
        when "PPDEWidth"
          if p.text.to_f > 0
            upload_bmp_ppde(node, scenario_id)
          end
        when "PPTWWidth"
          if p.text.to_f > 0
            upload_bmp_pptw(node, scenario_id)
          end
        when "WLArea"
          if p.text.to_f> 0
            upload_bmp_wl(node, scenario_id)
          end
        when "PndF"
          if p.text.to_f > 0
            upload_bmp_pnd(node, scenario_id)
          end
        when "SFAnimals"
          if p.text.to_i > 0
            upload_bmp_sf(node, scenario_id)
          end
        when "Sbs"
          if p.text == "True"
            upload_bmp_sbs(node, scenario_id)
          end
        when "RFArea"
          if p.text.to_f > 0
            upload_bmp_rf(node, scenario_id)
          end
        when "FSCrop"
          if p.text.to_i > 0
            upload_bmp_fs(node, scenario_id)
          end
        when "WWCrop"
          if p.text.to_i > 0
            upload_bmp_ww(node, scenario_id)
          end
        when "CBCrop"
          if p.text.to_i > 0
            upload_bmp_cb(node, scenario_id)
          end
        when "SlopeRed"
          if p.text.to_f > 0
            upload_bmp_ll(node, scenario_id)
          end
        when "Ts"
          if p.text == "True"
            upload_bmp_ts(node, scenario_id)
          end
        when "CcMaximumTeperature", "CcMinimumTeperature", "CcPrecipitation"
          if p.text.to_f > 0
            upload_bmp_cc(node, scenario_id)
          end
        when "AoC"
          if p.text == "True"
            upload_bmp_aoc(node, scenario_id)
          end
        when "Gc"
          if p.text == "True"
            upload_bmp_gc(node, scenario_id)
          end
        when "Sa"
          if p.text == "True"
            upload_bmp_sa(node, scenario_id)
          end
        when "SdgCrop"
          if p.text.to_i > 0
            upload_bmp_sdg(node, scenario_id)
          end
      end
    end
  end

  def upload_bmp_af(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 1
    bmp.bmpsublist_id = 2
    node.elements.each do |p|
      case p.name
        when "AFEff"
          bmp.irrigation_efficiency = p.text.to_f
        when "AFFreq"
          bmp.days = p.text.to_i
        when "AFMaxSingleApp"
          bmp.maximum_single_application = p.text.to_f
        when "AFType"
          bmp.irrigation_id = p.text.to_i
        when "AFWaterStressFactor"
          bmp.water_stress_factor = p.text.to_f
        when "AFSafetyFactor"
          bmp.safety_factor = p.text.to_f
        when "AFArea"
          bmp.area = p.text.to_f
        when "AFNConc"
          # unsure of what this is
          #bmp.irrigation_efficiency = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_ai(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 1
    bmp.bmpsublist_id = 1
    node.elements.each do |p|
      case p.name
        when "AIEff"
          bmp.irrigation_efficiency = p.text.to_f
        when "AIFreq"
          bmp.days = p.text.to_i
        when "AIMaxSingleApp"
          bmp.maximum_single_application = p.text.to_f
        when "AIType"
          bmp.irrigation_id = p.text.to_i
        when "AIWaterStressFactor"
          bmp.water_stress_factor = p.text.to_f
        when "AISafetyFactor"
          bmp.safety_factor = p.text.to_f
        when "AFArea"
          bmp.area = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_td(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 2
    bmp.bmpsublist_id = 3
    node.elements.each do |p|
      case p.name
        when "TileDrainDepth"
          bmp.depth = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_ppnd(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 2
    bmp.bmpsublist_id = 4
    node.elements.each do |p|
      case p.name
        when "PPNDWidth"
          bmp.width = p.text.to_f
        when "PPNDSides"
          bmp.sides = p.text.to_i
      end
    end
    bmp.save
  end

  def upload_bmp_ppds(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 2
    bmp.bmpsublist_id = 5
    node.elements.each do |p|
      case p.name
        when "PPDSWidth"
          bmp.width = p.text.to_f
        when "PPDSSides"
          bmp.sides = p.text.to_i
      end
    end
    bmp.save
  end

  def upload_bmp_ppde(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 2
    bmp.bmpsublist_id = 6
    node.elements.each do |p|
      case p.name
        when "PPDEWidth"
          bmp.width = p.text.to_f
        when "PPDESides"
          bmp.sides = p.text.to_i
        when "PPDEResArea"
          bmp.area = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_pptw(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 2
    bmp.bmpsublist_id = 7
    node.elements.each do |p|
      case p.name
        when "PPTWWidth"
          bmp.width = p.text.to_f
        when "PPTWSides"
          bmp.sides = p.text.to_i
        when "PPTWResArea"
          bmp.area = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_wl(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 3
    bmp.bmpsublist_id = 8
    node.elements.each do |p|
      case p.name
        when "WLArea"
          bmp.area = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_pnd(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 3
    bmp.bmpsublist_id = 9
    node.elements.each do |p|
      case p.name
        when "PndF"
          bmp.irrigation_efficiency = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_sf(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 4
    bmp.bmpsublist_id = 10
    node.elements.each do |p|
      case p.name
        when "SFAnimals"
          bmp.number_of_animals = p.text.to_i
        when "SFCode"
          bmp.animal_id = p.text.to_i
        when "SFDays"
          bmp.days = p.text.to_i
        when "SFHours"
          bmp.hours = p.text.to_i
        when "SFDryManure"
          bmp.dry_manure = p.text.to_f
        when "SFNo3"
          bmp.no3_n = p.text.to_f
        when "SFPo4"
          bmp.po4_p = p.text.to_f
        when "SFOrgN"
          bmp.org_n = p.text.to_f
        when "SFOrgP"
          bmp.org_p = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_sbs(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 4
    bmp.bmpsublist_id = 11
  end

  def upload_bmp_rf(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 4
    bmp.bmpsublist_id = 12
    node.elements.each do |p|
      case p.name
        when "RFArea"
          bmp.area = p.text.to_f
        when "RFGrassFieldPortion"
          bmp.grass_field_portion = p.text.to_f
        when "RFslopeRatio"
          bmp.buffer_slope_upland = p.text.to_f
        when "RFWidth"
          bmp.width = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_fs(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 4
    bmp.bmpsublist_id = 13
    node.elements.each do |p|
      case p.name
        when "FSArea"
          bmp.area = p.text.to_f
      @result = add_result(session[:field_id], 0, scenario_id, bmp.area, 61)
      @result = Result.find(@result_id)
      @result.area = @result.area - bmp.area
      #@result.save
        when "FSCrop"
          bmp.crop_id = p.text.to_i
        when "FSslopeRatio"
          bmp.buffer_slope_upland = p.text.to_f
        when "FSWidth"
          bmp.width = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_ww(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 4
    bmp.bmpsublist_id = 14
    node.elements.each do |p|
      case p.name
        when "WWCrop"
          bmp.crop_id = p.text.to_i
        when "WWWidth"
          bmp.width = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_cb(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 5
    bmp.bmpsublist_id = 15
    node.elements.each do |p|
      case p.name
        when "CBCrop"
          bmp.crop_id = p.text.to_i
        when "CBBWidth"
          bmp.width = p.text.to_f
        when "CBCWidth"
          bmp.crop_width = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_ll(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 6
    bmp.bmpsublist_id = 16
    node.elements.each do |p|
      case p.name
        when "SlopeRed"
          bmp.slope_reduction = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_ts(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 6
    bmpsublist_id = 17
  end

  def upload_bmp_cc(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 7
    bmp.bmpsublist_id = 19
    node.elements.each do |p|
      case p.name
        when "CcMaximumTeperature"
          bmp.difference_max_temperature = p.text.to_f
        when "CcMinimumTeperature"
          bmp.difference_min_temperature = p.text.to_f
        when "CcPrecipitation"
          bmp.difference_precipitation = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_bmp_aoc(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 8
    bmp.bmpsublist_id = 20
  end

  def upload_bmp_gc(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 8
    bmp.bmpsublist_id = 21
  end

  def upload_bmp_sa(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 8
    bmp.bmpsublist_id = 22
  end

  def upload_bmp_sdg(node, scenario_id)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    bmp.bmp_id = 8
    bmp.bmpsublist_id = 23
    node.elements.each do |p|
      case p.name
        when "SdgArea"
          bmp.area = p.text.to_f
        when "SggCrop"
          bmp.crop_id = p.text.to_i
        when "SdgslopeRatio"
          bmp.buffer_slope_upland = p.text.to_f
        when "SdgWidth"
          bmp.width = p.text.to_f
      end
    end
    bmp.save
  end

  def upload_control_values(node)
    #begin
      control = ApexControl.new
      control.project_id = @project.id
      node.elements.each do |p|
        case p.name
          when "Code"
            control_text = p.text.strip
            case control_text
              when "BUS1"
                control_text= "BUS(1)"
              when "BUS2"
                control_text = "BUS(2)"
              when "BUS3"
                control_text = "BUS(3)"
              when "BUS4"
                control_text = "BUS(4)"
            end # end case p.text.strip

            control.control_description_id = ControlDescription.find_by_code(control_text).control_desc_id
            case control.control_description_id
              when 1 # get number of years of simulation from weather
                weather = Weather.find_by_field_id(session[:field_id])
                control.value = @weather['simulation_final_year'].to_i - @weather['simulation_initial_year'].to_i + 1 + 5
                control.save
                # get the first year of simulation from weather
                control = ApexControl.new
                control.project_id = @project.id
                control.control_description_id = Control.find_by_id(2).id
                control.value = @weather['simulation_initial_year'].to_i - 5
                control.save
                return "OK"
              when 2 # do nothing because the second value should be already be taken
                return "OK"
            end # end case control.control_description_id
          when "Value"
            control.value = p.text
        end #end case
      end ## end each
      if !control.save then
        return "Error saving control file"
      else
        return "OK"
      end
    #rescue
      #return "Control values could not be saved"
    #end
  end

  def upload_control_values_new_version(node)
    begin
    control = ApexControl.new
      control.project_id = @project.id
      node.elements.each do |p|
        case p.name
          when "control_description_id"
            control.control_description_id = p.text
          when "code"
            control.control.code = p.text
          when "line"
            control.control.line = p.text
          when "column"
            control.control.column = p.text
          when "low_range"
            control.control.range_low = p.text
          when "high_range"
            control.control.range_high = p.text
          when "value"
            control.value = p.text
        end # end case
      end # end each
      if !control.save
        return "Error saving control file"
      else
        return "OK"
      end
    rescue
      return "Control values could not be saved"
    end
  end

  def upload_parameter_values(node)
    begin
      parameter = ApexParameter.new
      parameter.project_id = @project.id
      node.elements.each do |p|
        case p.name
          when "Code"
            case p.text.length
              when 5
                parameter.parameter_description_id = p.text[4]
              when 6
                parameter.parameter_description_id = p.text[4] + p.text[5]
              when 7
                parameter.parameter_description_id = p.text[4] + p.text[5] + p.text[6]
        else
                parameter.parameter_description_id = p.text
            end
          when "Value"
            parameter.value = p.text
        end #end case
      end ## end each
      if !parameter.save then
        return "Error saving parameter file"
      else
        return "OK"
      end
    rescue
      return "Parameters could not be saved"
    end
  end

  def upload_parameter_values_new_version(node)
    begin
    parameter = ApexParameter.new
      parameter.project_id = @project.id
      node.elements.each do |p|
        case p.name
          when "parameter_description_id"
            parameter.parameter_description_id = p.text
          when "value"
            parameter.value = p.text
        end # end case
      end # end each
      if !parameter.save
        return "Error saving parameter file"
      else
        return "OK"
      end
    rescue
      return "Parameters could not be saved"
    end
  end

  def upload_watershed_information_new_version(location_id, node)
    watershed = Watershed.new
    watershed.location_id = location_id
    node.elements.each do |p|
      case p.name
      when "name"
        watershed.name = p.text
        if !watershed.save then
          return "Watershed could not be saved"
        end
      when "last_simulation"
        watershed.last_simulation = p.text
        if !watershed.save then
          return "Watershed could not be saved"
        end
      when "watershed_scenarios"
        p.elements.each do |node|
          msg = upload_watershed_scenario_information_new_version(node, watershed.id)
        end
      when "results"
        p.elements.each do |r|
          msg = upload_result_new_version(0, watershed.id, 0, r)
          if msg != "OK"
            return msg
          end
        end
      when "crop_results"
        p.elements.each do |r|
          msg = upload_crop_result_new_version(0, watershed.id, 0, r)
          if msg != "OK"
            return msg
          end
        end
      end # end case
    end # end each
    if watershed.save
        session[:watershed_id] = watershed.id
      return "OK"
    else
      return "Watershed could not be saved"
    end
  end

  def upload_watershed_scenario_information_new_version(node, watershed_id)
    watershed_scenario = WatershedScenario.new
    watershed_scenario.watershed_id = watershed_id
    node.elements.each do |p|
      case p.name
        when "field_id"
          @field_ids.each do |field_id|
            if field_id.has_key?(p.text) then
              watershed_scenario.field_id = field_id.fetch(p.text)
            end
          end
          #watershed_scenario.field_id = p.text
        when "scenario_id"
          @scenario_ids.each do |scenario_id|
            if scenario_id.has_key?(p.text) then
              watershed_scenario.scenario_id = scenario_id.fetch(p.text)
            end
          end
          #watershed_scenario.scenario_id = p.text
      end # end case
    end # end each element
    if watershed_scenario.save
      return "OK"
    else
      return "watershed_scenarios could not be saved"
    end
  end
end