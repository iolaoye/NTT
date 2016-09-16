class ProjectsController < ApplicationController
  #EXAMPLES = "public/Examples"
  require 'nokogiri'
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(:user_id => params[:user_id])
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
    session[:project_id] = params[:id]
    @location = Location.find_by_project_id(params[:id])
    session[:location_id] = @location.id
    if Field.where(:location_id => @location.id).count > 0 then
      redirect_to list_field_path(session[:location_id])
    else
      redirect_to location_path(@location.id)
    end
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

  ################## ERASE ALL PROJECT AND CORRESPONDING FILES ##################

  # Does not seem to be working
  def self.wipe_database
    ApexControl.delete_all
    ApexParameter.delete_all
    Bmp.delete_all
    Chart.delete_all
    Climate.delete_all
    Field.delete_all
    Layer.delete_all
    Location.delete_all
    Operation.delete_all
    Project.delete_all
    Result.delete_all
    Scenario.delete_all
    Site.delete_all
    Soil.delete_all
    SoilOperation.delete_all
    Subarea.delete_all
    Watershed.delete_all
    WatershedScenario.delete_all
    Weather.delete_all
  end

  ########################################### CREATE NEW PROJECT##################
  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    session[:project_id] = @project.id
    @project.user_id = session[:user_id]
    @project.version = "NTTG3"
    respond_to do |format|
      if @project.save
        session[:project_id] = @project.id
        location = Location.new
        location.project_id = @project.id
        location.save
        session[:location_id] = location.id
        format.html { redirect_to @project, notice: t('models.project') + "" + t('notices.created') }
        format.json { render json: @project, status: :created, location: @project }
      else
        flash[:error] = @project.errors
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
        format.html { redirect_to list_field_path(session[:location_id]), notice: t('models.project') + "" + t('notices.updated') }
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
    if @project.destroy
      flash[:info] = t('models.project') + " " + @project.name + t('notices.deleted')
    end
    @projects = Project.where(:user_id => params[:user_id])

    respond_to do |format|
      format.html { redirect_to welcomes_path, notice: 'Project was successfully deleted.' }
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
    @id = params[:id]
    #nothing to do here. Just render the upload view
  end

  ########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
  def upload_project
    saved = false
    msg = ""
    upload_id = 0
    ActiveRecord::Base.transaction do
      #begin
      msg = "OK"
      upload_id = 0
      if params[:commit].eql? t('submit.save') then
        if params[:project] == nil then
          redirect_to upload_project_path(upload_id)
          flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('models.project') and return false
        end
        @data = Nokogiri::XML(params[:project])
        upload_id = 0
      else
        upload_id = 1
        case params[:examples]
          when "0"
            redirect_to upload_project_path(upload_id)
            flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('general.one') and return false
          when "1" # Load OH two fields
            @data = Nokogiri::XML(File.open(EXAMPLES + "/OH_MultipleFields.xml"))
        end # end case examples
      end
      @data.root.elements.each do |node|
        case node.name
          when "project"
            msg = upload_project_new_version(node)
          when "location"
            msg = upload_location_new_version(node)
          when "StartInfo"
            msg = upload_project_info(node)
          when "FarmInfo"
            msg = upload_location_info1(node)
          when "FieldInfo"
            msg = upload_field_info(node)
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
      if (msg == "OK" || msg == true)
        # summarizes results for totals and soils.
        #summarize_total()
        @projects = Project.where(:user_id => session[:user_id])
        saved = true
      else
        saved = false
        raise ActiveRecord::Rollback
      end
      #rescue NoMethodError => e
      #msg = e.inspect
      #saved = false
      #raise ActiveRecord::Rollback
      #end
    end
    if saved
      flash[:notice] = t('models.project') + " " + t('general.success')
      redirect_to list_field_path(session[:location_id]), notice: msg
    else
      redirect_to upload_project_path(upload_id)
      flash[:notice] = msg and return false
    end
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
		xml.controls {
		  controls = ApexControl.where(:project_id => params[:id])
		  controls.each do |c|
			save_control_information(xml, c)
		  end
		} # xml each control end

		xml.parameters {
		  parameters = ApexParameter.where(:project_id => params[:id])
		  parameters.each do |c|
			save_parameter_information(xml, c)
		  end
		} # xml each control end
      } # end xml.projects
    end #builder do end

    file_name = session[:session_id] + ".prj"
    path = File.join(DOWNLOAD, file_name)
    content = builder.to_xml
    File.open(path, "w") { |f| f.write(content) }
    #file.write(content)
    send_file path, :type => "application/xml", :x_sendfile => true
  end

  #download project def end

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

  # end method

  def save_field_information(xml, field)
    xml.field {
      #field information
	  xml.id field.id
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
      xml.scenarios {
        scenarios.each do |scenario|
          save_scenario_information(xml, scenario)
        end # end scenarios.each
      } #end xml.scenarios

      #charts = Chart.where(:field_id => field.id)
      #xml.charts {
        #charts.each do |chart|
          #save_chart_information(xml, chart)
        #end # end charts.each
      #} # end xml.charts
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
    } #weather info end
  end

  # end method

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
  end

  #site method

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
  end

  # end method

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
    } # layer xml
  end

  # end layer method

  def save_scenario_information(xml, scenario)
    xml.scenario {
      xml.id scenario.id
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

      subareas = Subarea.where("scenario_id == " + scenario.id.to_s + " AND bmp_id == 0")
      xml.subareas {
        subareas.each do |subarea|
          save_subarea_information(xml, subarea)
        end # end subarea.each
      } # end xml.subareas

      results = Result.where(:scenario_id => scenario.id)
      xml.results {
        results.each do |result|
          save_result_information(xml, result)
        end # end results.each
      } # end xml.results

      charts = Chart.where(:scenario_id => scenario.id)
      xml.charts {
        charts.each do |chart|
          save_chart_information(xml, chart)
        end # end charts.each
      } # end xml.charts
    } # end xml.scenario
  end

  #end scenario method

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
      soil_operations = SoilOperation.where(:operation_id => operation.id)
      xml.soil_operations {
        soil_operations.each do |so|
          save_soil_operation_information(xml, so)
        end # end soil_operations.each
      } # end xml.soil_operations
    } # xml each operation end
  end

  # end method

  def save_control_information(xml, control)
	  xml.control {
		  xml.control_id control.control_id
      xml.code control.control.code
      xml.line control.control.line
      xml.column control.control.column
      xml.value control.value
      xml.low_range control.control.range_low
      xml.high_range control.control.range_high
	}
  end

  def save_parameter_information(xml, parameter)
	  xml.parameter {
		  xml.value parameter.value
		  xml.parameter_id parameter.parameter_id
	}
  end

  def save_result_information(xml, result)
    xml.result {
      xml.description_id result.description_id
      xml.value result.value
      xml.ci_value result.ci_value
      xml.crop_id result.crop_id
	    xml.soil_id result.soil_id
	    xml.watershed_id result.watershed_id
	    xml.scenario_id result.scenario_id
	    xml.field_id result.field_id
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

      subareas = Subarea.where(:bmp_id => bmp.bmp_id)
      xml.subareas {
        subareas.each do |subarea|
          save_subarea_information(xml, subarea)
        end # end subareas.each
      } # end xml.subareas

      soil_operations = SoilOperation.where(:bmp_id => bmp.bmp_id)
      xml.soil_operations {
        soil_operations.each do |so|
          save_soil_operation_information(xml, so)
        end # end soil_operations.each
      } # end xml.soil_operations
    } # xml bmp end
  end

  # end method

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
  end

  # end method

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
      xml.ny5 subarea.ny6
      xml.ny5 subarea.ny7
      xml.ny5 subarea.ny8
      xml.ny5 subarea.ny9
      xml.ny5 subarea.ny10
      xml.xtp1 subarea.xtp1
      xml.xtp2 subarea.xtp2
      xml.xtp3 subarea.xtp3
      xml.xtp4 subarea.xtp4
      xml.xtp4 subarea.xtp5
      xml.xtp4 subarea.xtp6
      xml.xtp4 subarea.xtp7
      xml.xtp4 subarea.xtp8
      xml.xtp4 subarea.xtp9
      xml.xtp4 subarea.xtp10
    } # xml each subarea end
  end

  def save_chart_information(xml, chart)
    xml.chart {
      xml.description_id chart.description_id
      xml.month_year chart.month_year
      xml.value chart.value
	  xml.watershed_id chart.watershed_id
	  xml.scenario_id chart.scenario_id
	  xml.field_id chart.field_id
	  xml.soil_id chart.soil_id
    } # xml each chart_info end
  end

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

      watershed_scenarios = WatershedScenario.where(:watershed_id => watershed.id)
      xml.watershed_scenarios {
        watershed_scenarios.each do |wss|
          save_watershed_scenario_information(xml, wss)
        end # end scenarios each
      } # end scenarios

      charts = Chart.where(:watershed_id => watershed.id)
      xml.charts {
        charts.each do |chart|
          save_chart_information(xml, chart)
        end # end charts.each
      } # end charts

      results = Result.where(:watershed_id => watershed.id)
      xml.results {
        results.each do |result|
          save_result_information(xml, result)
        end # end results.each
      } # end results
    } # xml each watershed end
  end

=begin Work in progress
  def save_watershed_scenario_information(xml, watershed_scenario)
    xml.watershed_scenario {
      xml.
    }
  end
=end

  # end method

  private
  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def project_params
    params.require(:project).permit(:description, :name)
  end

  def upload_project_info(node)
    begin
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
    rescue
      return 'Error saving project'
    end
  end

  def upload_project_new_version(node)
    begin
      project = Project.new
      project.user_id = session[:user_id]
      node.elements.each do |p|
        case p.name
          when "project_name" #if project name exists, save fails
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
    rescue
      return 'Project could not be saved'
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
    begin
      location = Location.find(session[:location_id])
      node.elements.each do |p|
        case p.name
          when "Coordinates"
            location.coordinates = p.text
        end
      end
      location.save
    rescue
      return "Location could not be saved"
    end
  end

  def upload_location_new_version(node)
    #begin  #TODO CHECK THIS ONE. WHEN IT IS ACTIVE THE PROCCESS DOES NOT RUN FOR SOME REASON.
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
              return "location could not be saved " + msg
            end  # end location.save
          when "watershed"
            p.elements.each do |ws|
              msg = upload_watershed_information_new_version(ws)
            end
        end # end case p.name
      end # end node.elements do
    #rescue
      #msg = 'Location could not be saved'
    #end
	return msg
  end

  # end method

  def upload_field_info(node)
    begin
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
      session[:field_id] = field.id
    rescue
      return "Field could not be saved"
    end
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
      weather.save
    rescue
      return "Weather could not be saved"
    end
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
		  session[:depth] = field
		  ooo
            return "field could not be saved"
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
          @weather["weather_file"] = "N" + file_name[1]
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
              if site.xlog = 0 then
                site.xlog = Weather.find_by_field_id(field.id).longitude
              end
            when "Latitude"
              site.ylat = p.text
              if site.ylat = 0 then
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
            return "Error uploading soil"
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
        when "drainage_type"
          soil.drainage_type = p.text
        when "layers"
          if soil.save
            p.elements.each do |f|
              msg = upload_layer_new_version(soil.id, f)
              if msg != "OK"
                return msg
              end
            end
          end
        #when "subareas"
          #p.elements.each do |sa|
            #msg = upload_subarea_new_version(0, 0, soil.id, sa)
            #if msg != "OK"
              #return msg
            #end
          #end
        #when "soil_operations"
          #p.elements.each do |so|
            #msg = upload_soil_operation_new(so, 0, soil.id, 0, 0)
            #if msg != "OK"
              #return msg
            #end
          #end
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
            upload_result_info(p, field_id, soil_id, scenario_id)
          else
            return "Error saving scenario"
          end
      end
    end
    return "OK"
  end

  def upload_scenario_new_version(field_id, new_scenario)
    msg = "OK"
    scenario = Scenario.new
    scenario.field_id = field_id
    new_scenario.elements.each do |p|
      case p.name
        when "name"
          scenario.name = p.text
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
            msg = upload_result_new_version(scenario.id, field_id, r)
            if msg != "OK"
              return msg
            end
          end
        when "charts"
          p.elements.each do |r|
            msg = upload_chart_new_version(scenario.id, field_id, r)
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
				subarea.soil_id = Soil.find_by_soil_id_old(p.text).id
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
        when "rfp1"
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
        when "xtp1"
          subarea.xtp1 = p.text
        when "xtp2"
          subarea.xtp2 = p.text
        when "xtp3"
          subarea.xtp3 = p.text
        when "xtp4"
          subarea.xtp4 = p.text
      end
    end
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
          soil_operation.activity_id = Activity.find_by_abbreviation(p.text).id
        when "ApexTillCode"
          soil_operation.apex_operation = p.text
          if soil_operation.activity_id == 4 then
            soil_operation.apex_operation = Crop.find_by_number_and_state(soil_operation.apex_crop, Location.find(session[:location_id].id).state_id).harvest_code
            if soil_operation.apex_operation == nil then
              soil_operation.apex_operation = Crop.find_by_number_and_state(soil_operation.apex_crop, "**").harvest_code
            end
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
            when 1 #planting
              operation.type_id = apex_till_code
            when 2 # fertilizer
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
        when "amout"
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

  def upload_soil_operation_new(node, scenario_id, soil_id, operation_id, bmp_id)
    soil_operation = SoilOperation.new
    soil_operation.scenario_id = scenario_id
    soil_operation.operation_id = operation_id
    #soil_operation.soil_id = soil_id
    soil_operation.bmp_id = bmp_id
    node.elements.each do |p|
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
        when "tractor_id"
          soil_operation.tractor_id = p.text
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
		when "soil_id"
			if p.text == "0"
				soil_operation.soil_id = 0
			else
				soil_operation.soil_id = Soil.find_by_soil_id_old(p.text).id
			end
      end  # end case 
    end  # node
    if soil_operation.save
      return "OK"
    else
      return "soil operation could not be saved"
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
    end # end node.elements.each
  end
  # end method

  def upload_result_new_version(scenario_id, field_id, new_result)
    result = Result.new
    result.scenario_id = scenario_id
    result.field_id = field_id
    new_result.elements.each do |p|
      case p.name
        when "value"
          result.value = p.text
        when "ci_value"
          result.ci_value = p.text
        when "description_id"
          result.description_id = p.text
		when "soil_id"
			if p.text == "0"
				result.soil_id = 0
			else
				result.soil_id = Soil.find_by_soil_id_old(p.text).id
			end
		when "crop_id"
		    result.crop_id = p.text
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
          #p.elements.each do |p|
          #upload annual crops
          upload_chart_crop_info(p, field_id, 0, scenario_id)
        #end
      end # end case p.name
    end # end node.elements.each
  end

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
  end

  # end method

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
        when "Bmps"
          scenario_id = Scenario.find_by_field_id_and_name(field_id, name).id
          upload_bmp_info(p, scenario_id)
      end #end case
    end ## end each
  end

  # end method

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

  def upload_chart_new_version(scenario_id, field_id, new_chart)
    chart = Chart.new
    chart.scenario_id = scenario_id
    chart.field_id = field_id
    new_chart.elements.each do |p|
      case p.name
        when "value"
          chart.value = p.text
        when "month_year"
          chart.month_year = p.text
        when "description_id"
          chart.description_id = p.text
		when "soil_id"
  		  chart.soil_id = p.text
	    when "watershed_id"
	      chart.watershed_id = p.text
      end # end case
    end # end each
    if chart.save
      return "OK"
    else
      return "chart could not be saved"
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
        when "climates"
          p.elements.each do |climate|
            msg = upload_climate_new_version(climate, bmp.bmp_id)
            if msg != "OK"
              return msg
            end
          end
        when "subareas"
          p.elements.each do |subarea|
            msg = upload_subarea_new_version(bmp.bmp_id, scenario_id, subarea)
            if msg != "OK"
              return msg
            end
          end
        when "soil_operations"
          p.elements.each do |soil_op|
            msg = upload_soil_operation_new(soil_op, 0, 0, 0, bmp.bmp_id)
            if msg != "OK"
              return msg
            end
          end
      end
    end
    if bmp.save
      return "OK"
    else
      return "bmp could not be saved"
    end
  end

  def upload_climate_new_version(node, bmp_id)
    climate = Climate.new
    climate.bmp_id = bmp_id
    node.elements.each do |p|
      case p.name
        when "max_temp"
          climate.max_temp = p.text
        when "min_temp"
          climate.min_temp = p.text
        when "month"
          climate.month = p.text
        when "precipitation"
          climate.precipitation = p.text
      end # case end
    end # each end
    if climate.save then
      return "OK"
    else
      return "climate could not be saved"
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
    begin
      control = ApexControl.new
      control.project_id = session[:project_id]
      node.elements.each do |p|
        case p.name
          when "Code"
            control.control_id = Control.find_by_code(p.text.strip).id
            case control.control_id
              when 1 # get number of years of simulation from weather
                weather = Weather.find_by_field_id(session[:field_id])
                control.value = weather.simulation_final_year - weather.simulation_initial_year + 1 + 5
                control.save
                # get the first year of simulation from weather
                control = ApexControl.new
                control.project_id = session[:project_id]
                control.control_id = Control.find_by_id(2).id
                control.value = weather.simulation_initial_year - 5
                control.save
                return "OK"
              when 2 # do nothing because the second value should be already be taken
                return "OK"
            end # end case control.control_id
          when "Value"
            control.value = p.text
        end #end case
      end ## end each
      if !control.save then
        return "Error saving control file"
      else
        return "OK"
      end
    rescue
      return "Control values could not be saved"
    end
  end

  def upload_control_values_new_version(node) 
    begin
	  control = ApexControl.new
      control.project_id = session[:project_id]
      node.elements.each do |p|
        case p.name
          when "control_id"
            control.control_id = p.text
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
      parameter.project_id = session[:project_id]
      node.elements.each do |p|
        case p.name
          when "Code"
            case p.text.length
              when 5
                parameter.parameter_id = p.text[4]
              when 6
                parameter.parameter_id = p.text[4] + p.text[5]
              when 7
                parameter.parameter_id = p.text[4] + p.text[5] + p.text[6]
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
      parameter.project_id = session[:project_id]
      node.elements.each do |p|
        case p.name
          when "parameter_id"
            parameter.parameter_id = p.text
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

  def upload_watershed_information_new_version(node)
    watershed = Watershed.new
    node.elements.each do |p|
      case p.name
        when "name"
          watershed.name = p.text
        when "watershed_scenarios"
          if watershed.save
            session[:watershed_id] = watershed.id
            p.elements.each do |node|
              msg = upload_watershed_scenario_information_new_version(node, watershed.id)
            end
          else
            return "Watershed could not be saved"
          end
      end # end case
    end # end each
  end

=begin <----Work in progress---->
  def upload_watershed_scenario_information_new_version(node, watershed_id)
    watershed_scenario = WatershedScenario.new
    watershed_scenario.watershed_id = watershed_id
    node.elements.each do |p|
      case p.name
        when ""
          = p.text
      end # end case
    end # end each element
  end
=end
end
