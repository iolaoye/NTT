class ScenariosController < ApplicationController
  #load_and_authorize_resource :field
  #load_and_authorize_resource :scenario, :through => :field

  include ScenariosHelper
  include SimulationsHelper
  include ProjectsHelper
  include ApplicationHelper
  include FemHelper
  include AplcatParametersHelper
  include DndcHelper
  #include NrcsHelper
  ##############################  scenario bmps #################################
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

################################  NEW   #################################
# GET /scenarios/new
# GET /scenarios/new.json
  def new
    @errors = Array.new
    @scenario = Scenario.new

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
    @scenario = Scenario.find(params[:id])
    add_breadcrumb t('menu.scenarios'), project_field_scenarios_path(@project, @field)
    add_breadcrumb t('general.editing') + " " +  t('scenario.scenario')
  end

################################  CREATE  #################################
# POST /scenarios
# POST /scenarios.json
  def create
    @errors = Array.new
    @scenario = Scenario.new(scenario_params)
    @scenario.field_id = @field.id
    @watershed = Watershed.new(scenario_params)
    @watershed.save
    respond_to do |format|
      if @scenario.save
        add_scenario_to_soils(@scenario, false)
        # Check if tiledrain exists in field
        if @field.depth != nil && @field.depth > 0
          # Save soil Tile Drain values into Bmp table
          values = {}
          values[:action] = "save_bmps_from_load"
          values[:project_id] = @project.id
          values[:button] = t('submit.savecontinue')
          values[:field_id] =  params[:field_id]
          values[:bmp_td] = {}
          values[:bmp_td][:depth] = @field.depth
          values[:scenario_id] = @scenario.id
          # Add irrigation_id
          @field.tile_bioreactors == "1" || @field.tile_bioreactors == true ? values[:irrigation_id] = 1 : values[:irrigation_id] = nil
          # Add crop_id
          @field.drainage_water_management == "1" || @field.drainage_water_management == true ? values[:crop_id] = 1 : values[:crop_id] = nil
          bmp_controller = BmpsController.new
          bmp_controller.request = request
          bmp_controller.response = response
          bmp_controller.save_bmps_from_load(values)
        end
        @scenarios = Scenario.where(:field_id => params[:field_id])
        #add new scenario to soils
        flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.created')
        format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('models.scenario') + " " + t('general.success') }
      else
      flash[:info] = t('scenario.scenario_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
        format.html { redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT") }
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
        format.html { redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT"), notice: t('models.scenario') + " " + @scenario.name + t('notices.updated') }
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
    @errors = Array.new
    if @scenario.destroy
      flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT") }
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
      @scenarios = Scenario.where(:field_id => params[:field_id])
      @project_name = Project.find(params[:project_id]).name
      @field_name = Field.find(params[:field_id]).field_name
      respond_to do |format|
        if msg.eql?("OK") then
        flash[:notice] = t('scenario.scenario') + " " + t('general.success')
        format.html { redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT") }
        else
        flash[:error] = "Error simulating scenario - " + msg
        format.html { render action: "list" }
        end # end if msg
      end
    end
  end

################################  simualte either NTT or APLCAT or FEM #################################
  def simulate
    msg = "OK"
    time_begin = Time.now
    session[:simulation] = 'scenario'
    #case true
    if @project.version.include? "special"
      ## fork do #comment when need to debugge.
        run_special_simulation()
      ## end
      flash[:notice] = "County Scenarios have been sent to run on background" + " " + (Time.now - time_begin).round(2).to_s + " " + t('datetime.prompts.second').downcase
      redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
      return
    else
      #when params[:commit].include?('NTT')
      if params[:select_ntt] != nil
        msg = simulate_ntt
      end 
      if params[:select_fem] != nil and msg == "OK"
      #when params[:commit].include?("APLCAT")
        msg = simulate_fem
      end
      if params[:select_aplcat] != nil and msg == "OK"
      #when params[:commit].include?("FEM")
        msg = simulate_aplcat
      end
      #when params[:commit].include?("DNDC")
        #msg = simulate_dndc
    end
    if msg.eql?("OK") then
      #@scenario = Scenario.find(params[:select_scenario])
      flash[:notice] = @scenarios_selected.count.to_s + " " + t('scenario.simulation_success') + " " + (Time.now - time_begin).round(2).to_s + " " + t('datetime.prompts.second').downcase if @scenarios_selected.count > 0
      case true
        when params[:commit].include?('NTT')
          redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
        when params[:commit].include?("APLCAT")
          redirect_to project_field_scenarios_path(@project, @field,:caller_id => "APLCAT")
        when params[:commit].include?("FEM")
          redirect_to project_field_scenarios_path(@project, @field,:caller_id => "FEM")
        #when params[:commit].include?("DNDC")
          #msg = simulate_dndc
        else
          redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
      end
    else
      @scenarios = Scenario.where(:field_id => @field.id)
      caller_id = ""
      case true
        when params[:commit].include?('NTT')
          caller_id = "NTT"
        when params[:commit].include?("APLCAT")
          caller_id = "APLCAT"
        when params[:commit].include?("FEM")
          caller_id = "FEM"
        else
          caller_id = "NTT"
      end
      render "index", :locals => { :caller_id => caller_id }, error: msg
    end # end if msg
  end

################################  Simulate NTT for selected scenarios  #################################
  def run_special_simulation
    require 'nokogiri'
    #create xml file and send the simulation to ntt.tft.cbntt.org server
    #read the coordinates for the county selected
    # State.find_by_id(@project.location.state_id).state_abbreviation
    c = County.find_by_id(@project.location.county_id).county_state_code
    file_name = "MD_013"
    #file_name = c[0..1] + "_" + c[2..]
    full_name = "public/NTTFiles/" + file_name + ".txt"
    #toto need to add all of the values in this inizialization in order to avoid nil errors.
    total_xml = {"total_runs" => 0,"total_errors" => 0,"organicn" => 0, "no3" => 0, "surface_n" => 0, "subsurface_n" => 0, "lateralsubsurfacen" => 0, "quickreturnn" => 0, "returnsubsurfacen" => 0, "tiledrainn" => 0, "volatilizedn" => 0, "nitrousoxide" => 0,"solublep" => 0, "leachedp" => 0, "tiledrainp" => 0, "flow" => 0, "surfaceflow" => 0, "subsurfaceflow" => 0, "lateralsubsurfaceflow" => 0, "quickreturnflow" => 0, "returnsubsurfaceflow" => 0, "tiledrainflow" => 0, "deeppercolation" => 0, "irrigationapplied" => 0, "irrigationapplied" => 0, "sediment" => 0, "sedimentsurface" => 0, "sedimentmanure" => 0, "carbon" => 0, "flow_ci" => 0, "sed_ci" => 0, "orgn_ci" => 0, "orgp_ci" => 0, "no3_ci" => 0, "po4_ci" => 0, "crop" => nil, "cropcode" => nil, "yield" => nil}
    crops_hash = nil
    File.open(full_name).each do |line|
      line.gsub! "\n",""
      line.gsub! "\r",""
      line_splited = line.split("|")
      next if line_splited[0].include? "State"
      #create xml file and send it to run
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.NTT {
          xml.StartInfo {
            #save start information
            xml.StateId line_splited[0]    #state abrevation.
            xml.CountyId file_name.split("_")[1]    #county code.
            xml.ProjectName @project.name
          } # end xml.StartInfo
          #save field information
          xml.FieldInfo {
            xml.Field_id @field.id.to_s + "_" + line_splited[2]
            xml.Area 100
            xml.SoilP 0
            xml.Coordinates line_splited[3]
            xml.ScenarioInfo {
              xml.Name Scenario.find_by_id(params[:select_ntt][0]).name #@scenario.name
              #create operations
              SoilOperation.where(:scenario_id => params[:select_ntt][0]).each do |soop|   # multiple soiloperations for each scenario_id
                xml.ManagementInfo {
                  xml.Operation soop.apex_operation
                  xml.Year soop.year
                  xml.Month soop.month
                  xml.Day soop.day
                  xml.Crop soop.apex_crop
                  xml.Opv1 soop.opv1
                  xml.Opv2 soop.opv2
                  xml.Opv3 soop.opv3
                  xml.Opv4 soop.opv4
                  xml.Opv5 soop.opv5
                }  # end operations
              end
              # Added by Jennifer 12/3/20
              Bmp.where(:scenario_id => params[:select_ntt][0]).each do |bmp|
                xml.BmpInfo {
                case bmp.bmpsublist_id
                when 1
                  xml.Autoirrigation {
                    xml.Code
                    xml.Efficiency bmp.irrigation_efficiency
                    xml.Frequency bmp.maximum_single_application
                    xml.Stress bmp.water_stress_factor
                    xml.Volume # in mm
                    xml.ApplicationRate bmp.dry_manure*LBS_AC_TO_T_HA # convert pounds/acre to kg/ha
                  }
                when 3
                  xml.TileDrain {
                    xml.Depth bmp.depth*FT_TO_MM # convert ft to mm
                  }
                when 8
                  xml.Wetland {
                    xml.Area bmp.area*AC_TO_HA # convert ac to ha
                  }
                when 9
                  xml.Pond {
                    xml.Fraction bmp.irrigation_efficiency
                  }
                when 13
                  xml.GrassBuffer {
                    xml.CropCode bmp.crop_id
                    xml.Area bmp.area*AC_TO_HA # convert ac to ha
                    xml.GrassStripWidth bmp.width * FT_TO_M # convert ft to m
                    xml.ForestStripWidth bmp.grass_field_portion * FT_TO_M # convert ft to m
                    xml.Fraction * bmp.slope_reduction
                  }
                when 14
                  xml.GrassWaterway {
                    xml.Width bmp.width
                    xml.Fraction bmp.slope_reduction
                  }
                when 16
                  xml.LandLeveling {
                    xml.SlopeReduction bmp.slope_reduction
                  }
                when 17
                  xml.TerraceSystem {
                    xml.Active
                  }
                end # end case statement
                } # end bmpinfo
              end
            } # end scenario
          } # end field
        } # end xml.start info
      end #builder do end
      xmlString = builder.to_xml
      xmlString.gsub! "<", "["
      xmlString.gsub! ">", "]"
      xmlString.gsub! "\n", ""
      xmlString.gsub! "[?xml version=\"1.0\"?]", ""
      xmlString.gsub! "]    [", "] ["
      #run simulation
      result = Net::HTTP.get(URI.parse('http://ntt.tft.cbntt.org/ntt_tft/NTT_Service.ashx?input=' + xmlString))
      xml = Hash.from_xml(result.gsub("\n","").downcase)
      if xml["summary"]["results"]["errorcode"] == "0" then
        #add all of the values because thereis not error
        total_xml["organicn"] += xml["summary"]["results"]["organicn"].to_f
        total_xml["no3"] += xml["summary"]["results"]["no3"].to_f
        total_xml["surface_n"] += xml["summary"]["results"]["surface_n"].to_f
        total_xml["subsurface_n"] += xml["summary"]["results"]["subsurface_n"].to_f
        total_xml["lateralsubsurfacen"] += xml["summary"]["results"]["lateralsubsurfacen"].to_f
        total_xml["quickreturnn"] += xml["summary"]["results"]["quickreturnn"].to_f
        total_xml["returnsubsurfacen"] += xml["summary"]["results"]["returnsubsurfacen"].to_f
        total_xml["tiledrainn"] += xml["summary"]["results"]["tiledrainn"].to_f
        total_xml["volatilizedn"] += xml["summary"]["results"]["volatilizedn"].to_f
        total_xml["nitrousoxide"] += xml["summary"]["results"]["nitrousoxide"].to_f
        total_xml["solublep"] += xml["summary"]["results"]["solublep"].to_f
        total_xml["leachedp"] += xml["summary"]["results"]["leachedp"].to_f
        total_xml["tiledrainp"] += xml["summary"]["results"]["tiledrainp"].to_f
        total_xml["flow"] += xml["summary"]["results"]["flow"].to_f
        total_xml["surfaceflow"] += xml["summary"]["results"]["surfaceflow"].to_f
        total_xml["subsurfaceflow"] += xml["summary"]["results"]["subsurfaceflow"].to_f
        total_xml["lateralsubsurfaceflow"] += xml["summary"]["results"]["lateralsubsurfaceflow"].to_f
        total_xml["quickreturnflow"] += xml["summary"]["results"]["quickreturnflow"].to_f
        total_xml["returnsubsurfaceflow"] += xml["summary"]["results"]["returnsubsurfaceflow"].to_f
        total_xml["tiledrainflow"] += xml["summary"]["results"]["tiledrainflow"].to_f
        total_xml["deeppercolation"] += xml["summary"]["results"]["deeppercolation"].to_f
        total_xml["irrigationapplied"] += xml["summary"]["results"]["irrigationapplied"].to_f
        total_xml["sediment"] += xml["summary"]["results"]["sediment"].to_f
        total_xml["sedimentsurface"] += xml["summary"]["results"]["sedimentsurface"].to_f
        total_xml["sedimentmanure"] += xml["summary"]["results"]["sedimentmanure"].to_f
        total_xml["carbon"] += xml["summary"]["results"]["carbon"].to_f
        total_xml["flow_ci"] += xml["summary"]["results"]["flow_ci"].to_f
        total_xml["sed_ci"] += xml["summary"]["results"]["sed_ci"].to_f
        total_xml["orgn_ci"] += xml["summary"]["results"]["orgn_ci"].to_f
        total_xml["orgp_ci"] += xml["summary"]["results"]["orgp_ci"].to_f
        total_xml["no3_ci"] += xml["summary"]["results"]["no3_ci"].to_f
        total_xml["po4_ci"] += xml["summary"]["results"]["po4_ci"].to_f
        crops_hash = xml["summary"]["crops"] # May have more than one crop
        total_xml["total_runs"] += 1
      else
        total_xml["total_errors"] += 1
      end
      #todo access every element in the xml hash for i.e.: xml["summary"]["results"]["no3"]
      #todo need to add any adddional node in the total_xml initialization statement at the begining of this funtion
    end   # end File.open
    File.open("public/NTTFiles/" + file_name + ".out", "w+") do |f|
      f.write(total_xml)
    end
    # average_all_xml = (total_xml["organicn"] + total_xml["no3"] + total_xml["surface_n"] + total_xml["subsurface_n"] + total_xml["lateralsubsurfacen"] + total_xml["quickreturnn"] + total_xml["returnsubsurfacen"] + total_xml["tiledrainn"] + total_xml["volatilizedn"] + total_xml["nitrousoxide"] + total_xml["solublep"] + total_xml["leachedp"] + total_xml["tiledrainp"] + total_xml["flow"] + total_xml["surfaceflow"] + total_xml["subsurfaceflow"] + total_xml["lateralsubsurfaceflow"] + total_xml["quickreturnflow"] + total_xml["returnsubsurfaceflow"] + total_xml["tiledrainflow"] + total_xml["deeppercolation"] + total_xml["irrigationapplied"] + total_xml["sediment"] + total_xml["sedimentsurface"] + total_xml["sedimentmanure"] + total_xml["carbon"] + total_xml["flow_ci"] + total_xml["sed_ci"] + total_xml["orgn_ci"] + total_xml["orgp_ci"] + total_xml["no3_ci"] + total_xml["po4_ci"])/32
     avg_organic = total_xml["organicn"] / total_xml["total_runs"]
     avg_no3 = total_xml["no3"]/ total_xml["total_runs"]
     avg_surface_n = total_xml["surface_n"] / total_xml["total_runs"]
     avg_subsurface_n = total_xml["subsurface_n"] / total_xml["total_runs"]
     avg_lateralsubsurfacen = total_xml["lateralsubsurfacen"] / total_xml["total_runs"]
     avg_quickreturnn = total_xml["quickreturnn"] / total_xml["total_runs"]
     avg_returnsubsurfacen = total_xml["returnsubsurfacen"]/ total_xml["total_runs"]
     avg_tiledrainn = total_xml["tiledrainn"] / total_xml["total_runs"]
     avg_volatilizedn = total_xml["volatilizedn"] / total_xml["total_runs"]
     avg_nitrousoxide = total_xml["nitrousoxide"] / total_xml["total_runs"]
     avg_solublep = total_xml["solublep"] / total_xml["total_runs"]
     avg_leachedp = total_xml["leachedp"] / total_xml["total_runs"]
     avg_tiledrainp = total_xml["tiledrainp"]/ total_xml["total_runs"]
     avg_flow = total_xml["flow"]/ total_xml["total_runs"]
     avg_surfaceflow = total_xml["surfaceflow"]/ total_xml["total_runs"]
     avg_subsurfaceflow = total_xml["subsurfaceflow"]/ total_xml["total_runs"]
     avg_lateralsubsurfaceflow = total_xml["lateralsubsurfaceflow"]/ total_xml["total_runs"]
     avg_quickreturnflow = total_xml["quickreturnflow"]/ total_xml["total_runs"]
     avg_returnsubsurfaceflow = total_xml["returnsubsurfaceflow"]/ total_xml["total_runs"]
     avg_tiledrainflow = total_xml["tiledrainflow"]/ total_xml["total_runs"]
     avg_deeppercolation = total_xml["deeppercolation"]/ total_xml["total_runs"]
     avg_irrigationapplied = total_xml["irrigationapplied"]/ total_xml["total_runs"]
     avg_sediment = total_xml["sediment"]/ total_xml["total_runs"]
     avg_sedimentsurface = total_xml["sedimentsurface"]/ total_xml["total_runs"]
     avg_sedimentmanure = total_xml["sedimentmanure"]/ total_xml["total_runs"]
     avg_carbon = total_xml["carbon"]/ total_xml["total_runs"]
     avg_flow_ci = total_xml["flow_ci"]/ total_xml["total_runs"]
     avg_sed_ci = total_xml["sed_ci"]/ total_xml["total_runs"]
     avg_orgn_ci = total_xml["orgn_ci"]/ total_xml["total_runs"]
     avg_orgp_ci = total_xml["orgp_ci"]/ total_xml["total_runs"]
     avg_no3_ci = total_xml["no3_ci"]/ total_xml["total_runs"]
     avg_po4_ci = total_xml["po4_ci"]/ total_xml["total_runs"]
     crop_code = total_xml["cropcode"]
     crop_name = total_xml["crop"]
     crop_yield = total_xml["yield"]
    #todo need to average all of the values in the total_xml hash. The result should be added to a record in the annual results and crop results table. If the record exist need to be replace/updated otherwise need to be created.

    AnnualResult.find_or_initialize_by(scenario_id: params[:select_ntt][0], no3: avg_no3, flow:avg_flow, sed: avg_sediment, irri: avg_irrigationapplied, n2o:avg_nitrousoxide, orgp:avg_orgp_ci, orgn: avg_orgn_ci, po4:avg_po4_ci, no3:avg_no3_ci, qdrn:avg_quickreturnn)
    # Note: Adding 'surface_flow: avg_surfaceflow' to hash produces SQL error

     crops_hash.each do |c|
       CropResult.find_or_initialize_by(scenario_id: params[:select_ntt][0], name: c["crop_name"], yldg: c["yield"])
     end
  end

################################  Simulate NTT for selected scenarios  #################################
  def simulate_ntt
    @errors = Array.new
    msg = "OK"
    @apex_version = 806
    if params[:select_ntt] == nil and params[:select_1501] == nil then msg = "Select at least one scenario to simulate " end
    if msg != "OK" then
      @errors.push(msg)
      return msg
    end
    if params[:select_ntt] == nil then
      @scenarios_selected = params[:select_1501]
      @apex_version = 1501
    else
      @scenarios_selected = params[:select_ntt]
      @apex_version = 806
    end
    ActiveRecord::Base.transaction do
      @scenarios_selected.each do |scenario_id|
        @scenario = Scenario.find(scenario_id)
        if @scenario.operations.count <= 0 then
          @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
          return
        end
        msg = run_scenario
        unless msg.eql?("OK")
           @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
           raise ActiveRecord::Rollback
        end # end unless msg
        if msg.eql?("OK") # Only create/update simulation time if no errors were encountered
         @scenario.last_simulation = Time.now
         @scenario.save!
        end
      end # end each do params loop
    end
    return msg
  end

################################  Simulate DNDC for selected scenarios  #################################
  def simulate_dndc
    msg = "OK"
    @errors = Array.new
    if params[:select_dndc] == nil then msg = "Select at least one scenario to simulate " end
    if msg != "OK" then
      @errors.push(msg)
      return msg
    end
    @scenarios_selected = params[:select_dndc]
    ActiveRecord::Base.transaction do
      @scenarios_selected.each do |scenario_id|
        @scenario = Scenario.find(scenario_id)
        if @scenario.operations.count <= 0 then
          @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
          return
        end
        msg = input_parameters
        unless msg.eql?("OK")
           @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
           raise ActiveRecord::Rollback
        end # end unless msg
      end # end each do params loop
    end
    return msg
  end

  ################################  aplcat - simulate the selected scenario for aplcat #################################
  def simulate_aplcat
    msg = "OK"
    @errors = Array.new
    if params[:select_aplcat] == nil then
      @errors.push("Select at least one Aplcat to simulate ")
      return "Select at least one Aplcat to simulate "
    end
    @scenarios_selected = params[:select_aplcat]
    ActiveRecord::Base.transaction do
      @scenarios_selected.each do |scenario_id|
        @scenario = Scenario.find(scenario_id)
        msg = get_file_from_APLCAT("APEX.wth")
        if msg.include? "Error" then
          msg = "OK"
          msg = run_scenario
          if msg != "OK" then 
            @errors.push("Error simulating NTT " + @scenario.name + " (You should run 'Simulate NTT' before simulating APLCAT)") 
            return "Error"
          end
        end
        msg = run_aplcat
        unless msg.eql?("OK")
          if msg.include?('cannot be null')
              @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
            else
            @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
          end
          raise ActiveRecord::Rollback
        end # end if msg
        if msg.eql?("OK")
            @scenario.aplcat_last_simulation = Time.now 
            @scenario.save!
        end
      end # end each do params loop
    end

    return msg
  end  # end method simulate_aplcat
  
################################  FEM - simulate the selected scenario for FEM #################################
  def simulate_fem
    @errors = Array.new
    msg = "OK"
    msg = fem_tables()
    if params[:select_fem] == nil then
      @errors.push("Select at least one scenario to simulate ")
      return "Select at least one scenario to simulate "
    end
    @scenarios_selected = params[:select_fem]
    ActiveRecord::Base.transaction do
      @scenarios_selected.each do |scenario_id|
        @scenario = Scenario.find(scenario_id)
        if @scenario.operations.count <= 0 then
          @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
          return
        end
        #if @scenario.crop_results.count <=0 then
          msg = run_scenario()
          if msg != "OK" then 
            @errors.push("Error simulating NTT " + @scenario.name)
            return
          end
        #end
        msg = run_fem
        unless msg.eql?("OK")
          @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
          raise ActiveRecord::Rollback
        end # end unless msg
        if msg.eql?("OK")
          @scenario.fem_last_simulation = Time.now
          @scenario.save!
        end
      end # end each do params loop
    end
    return msg
  end

################################  Update the FEM tables #################################
  def fem_tables
    feeds = FemFeed.where(:project_id => @project.id)
    if feeds == [] then
      load_feeds
      feeds = FemFeed.where(:project_id => @project.id)
    end

    machines = FemMachine.where(:project_id => @project.id)
    if machines == [] then
      load_machines
      machines = FemMachine.where(:project_id => @project.id)
    end

    facilities = FemFacility.where(:project_id => @project.id)
    if facilities == [] then
      load_facilities
      facilities = FemFacility.where(:project_id => @project.id)
    end

    generals = FemGeneral.where(:project_id => @project.id)
    if generals == [] then
      load_generals
      generals = FemGeneral.where(:project_id => @project.id)
    end

    send_file = true
    #i=0
    if send_file == true
      xmlBuilder = Nokogiri::XML::Builder.new do |xml|
        xml.send('FEM') {
          feeds.each do |feed|
            #i+=1
            if feed.updated then
              xml.send('feed') {
                xml.send("feed-name", feed.name.to_s)
                xml.send("selling-price", feed.selling_price.to_s)
                xml.send("purchase-price",feed.purchase_price.to_s)
                xml.send("concentrate", feed.concentrate.to_s)
                xml.send("forage",feed.forage.to_s)
                xml.send("grain",feed.grain.to_s)
                xml.send("hay",feed.hay.to_s)
                xml.send("pasture",feed.pasture.to_s)
                xml.send("silage",feed.silage.to_s)
                xml.send("supplement",feed.supplement.to_s)
                xml.send("codes",feed.codes.to_s)
              }
            end
            #if i >= 10 then
              #break
            #end
          end
        }
      end
      xmlString = xmlBuilder.to_xml
      if xmlString.include? "feed"
        xmlString.gsub! "<", "["
        xmlString.gsub! ">", "]"
        xmlString.gsub! "\n", ""
        xmlString.gsub! "[?xml version=\"1.0\"?]", ""
        xmlString.gsub! "]    [", "] ["
        msg = send_file_to_APEX(xmlString, "FEM_feed")
      end
    end

        #i=0
    if send_file == true
      xmlBuilder = Nokogiri::XML::Builder.new do |xml|
        xml.send('FEM') {
          machines.each do |equip|
            #i+=1
            if equip.updated then
              xml.send('machine') {
                xml.send("machine-name", equip.name.to_s)
                xml.send("lease_rate", equip.lease_rate.to_s)
                xml.send("new_price", equip.new_price.to_s)
                xml.send("new_hours", equip.new_hours.to_s)
                xml.send("current_price", equip.current_price.to_s)
                xml.send("hours_remaining", equip.hours_remaining.to_s )
                xml.send("width", equip.width.to_s)
                xml.send("speed", equip.speed.to_s)
                xml.send("field_efficiency", equip.field_efficiency.to_s)
                xml.send("horse_power", equip.horse_power.to_s)
                xml.send("rf1", equip.rf1.to_s)
                xml.send("rf2", equip.rf2.to_s)
                xml.send("ir_loan", equip.ir_loan.to_s)
                xml.send("l_loan", equip.l_loan.to_s)
                xml.send("ir_equity", equip.ir_equity.to_s)
                xml.send("p_debt", equip.p_debt.to_s)
                xml.send("year", equip.year.to_s )
                xml.send("rv1", equip.rv1.to_s)
                xml.send("rv2", equip.rv2.to_s)
                xml.send("codes", equip.codes.to_s)
                xml.send("ownership", equip.ownership.to_s)
              }
            end
            #if i >= 10 then
              #break
            #end
          end
        }
      end
      xmlString = xmlBuilder.to_xml
      if xmlString.include? "machine"
        xmlString.gsub! "<", "["
        xmlString.gsub! ">", "]"
        xmlString.gsub! "\n", ""
        xmlString.gsub! "[?xml version=\"1.0\"?]", ""
        xmlString.gsub! "]    [", "] ["
        msg = send_file_to_APEX(xmlString, "FEM_machine")
      end
    end
       #i=0
    if send_file == true
      xmlBuilder = Nokogiri::XML::Builder.new do |xml|
        xml.send('FEM') {
          facilities.each do |struct|
            #i+=1
            if struct.updated then
              xml.send('structure') {
                xml.send("struct-name", struct.name.to_s)
                xml.send("lease_rate", struct.lease_rate.to_s)
                xml.send("new_price", struct.new_price.to_s)
                xml.send("new_life", struct.new_life.to_s)
                xml.send("current_price", struct.current_price.to_s)
                xml.send("life_remaining", struct.life_remaining.to_s)
                xml.send("maintenance_coeff", struct.maintenance_coeff .to_s)
                xml.send("loan_interest_rate", struct.loan_interest_rate.to_s)
                xml.send("length_loan", struct.length_loan.to_s)
                xml.send("interest_rate_inequality", struct.interest_rate_equity.to_s)
                xml.send("proportion_debt", struct.proportion_debt.to_s)
                xml.send("year", struct.year.to_s)
                xml.send("codes", struct.codes.to_s)
                xml.send("ownership", struct.ownership.to_s)
              }
            end
            #if i >= 10 then
              #break
            #end
          end
        }
      end
      xmlString = xmlBuilder.to_xml
      if xmlString.include? "structure"
        xmlString.gsub! "<", "["
        xmlString.gsub! ">", "]"
        xmlString.gsub! "\n", ""
        xmlString.gsub! "[?xml version=\"1.0\"?]", ""
        xmlString.gsub! "]    [", "] ["
        msg = send_file_to_APEX(xmlString, "FEM_facility")
      end
    end
        #i=0
    if send_file == true
      xmlBuilder = Nokogiri::XML::Builder.new do |xml|
        xml.send('FEM') {
          generals.each do |other|
            #i+=1
            if other.updated then
              xml.send("other") {
                xml.send("other-name", other.name.to_s)
                xml.send("value", other.value.to_s)
              }
            end
            #if i >= 10 then
              #break
            #end
          end
        }
      end
      xmlString = xmlBuilder.to_xml
      if xmlString.include? "other"
        xmlString.gsub! "<", "["
        xmlString.gsub! ">", "]"
        xmlString.gsub! "\n", ""
        xmlString.gsub! "[?xml version=\"1.0\"?]", ""
        xmlString.gsub! "]    [", "] ["
        msg = send_file_to_APEX(xmlString, "FEM_farm")
      end
    end
    #puts xmlString
  end

################################  RUN-FEM - simulate the selected scenario for FEM #################################
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
    ntt_fem_Options += "Scenario|" + @scenario.name + "\n"
    #find if there are bmps with area taken from the field
    bmps_area = @scenario.bmps.where("area>0").sum(:area)
    #find the crops in the scenario a take crop, yield, unit, field area, field area without bmps.
    crops = @scenario.crop_results.group(:name).average("yldf+yldg")
    crops.each do |c|
      crop = Crop.find_by_code(c[0])
      if crop.code.include?("COT") then
        c[1] = @scenario.crop_results.where(:name => crop.code).average("yldg")
      end
      crop_yield = (crop.conversion_factor * AC_TO_HA) / (crop.dry_matter/100) * c[1]
      ntt_fem_Options +=  "CROP|" + c[0] + "|" + crop_yield.round(2).to_s + "|" + crop.yield_unit + "|" + @field.field_area.round(2).to_s + "|" + (@field.field_area-bmps_area).round(2).to_s + "\n"
    end
    ntt_fem_Options += "APEXFolder|" + drive + "\\NTTHTML5Files\\APEX" + session[:session_id] + "\n"
    #send the file to server
    msg = send_file_to_APEX(ntt_fem_Options, "NTT_FEMOptions.txt")
    #create fembat01.bat file
    ntt_fem_Options = drive + "\n"
    ntt_fem_Options += "cd " + folder + "\\" + "\n"
    ntt_fem_Options += drive + "\\NTT_FEM\\new2.exe" + "\n"
    #send the file to server
    msg = send_file_to_APEX(ntt_fem_Options, "fembat01.bat")
    state = State.find(@project.location.state_id).state_abbreviation

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.additions {
        xml.operations {
          @scenario.operations.each do |op|
            get_operations(op, state, xml)
          end
        }
        xml.bmps {
          @scenario.bmps.each do |bmp|
            get_bmps(bmp, state, xml)
          end
        }
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

  ################################  get_operations - get operations and send them to server and simulate fem #################################
  def get_bmps(bmp, state, xml)
    items = Array.new
    values = Array.new
    apex_op = ''
    operation_name = ""
    for i in 0..(8 - 1)
      items[i] = ""
      values[i] = 0
    end

    case bmp.bmpsublist_id
      when 1 #autoirrigation or autofertigation
        operation_name = "Autoirrigation"
        items[0] = "Type"
        values[0] = Irrigation.find(bmp.irrigation_id).name
        items[1] = "Efficiency"
        values[1] = bmp.irrigation_efficiency
        items[2] = "Frequency"

        values[2] = bmp.days

        items[3] = "Water Stress Factor"
        values[3] = bmp.water_stress_factor
        items[4] = "Maximum Single Application"
        items[4] = bmp.maximum_single_application
        apex_op = "AI"

        if bmp.depth == 2 then   #autofertigaation
          operation_name = "Autofertigation"
          items[5] = "Application Depth"
          values[5] = bmp.dry_manure
          apex_op = "AF"
        end
      when 3 #Tile Drain
        operation_name = "Tile_Drain"
        items[0] = "Depth"
        values[0] = bmp.depth
        apex_op = "TD"
      when 4 #Pads and Pipes
        apex_op = "PP"
      when 5 #Pads and Pipes
        apex_op = "PP"
      when 6 #Pads and Pipes
        apex_op = "PP"
      when 7 # Pads and Pipes              #Grazing - kind and number of animals
        apex_op = "PP"
      when 8 #wetland
        operation_name = "Wetlands"
        items[0] = "Area"
        values[0] = bmp.area
        apex_op = "WL"
      when 9 #Ponds
        operation_name = "Ponds"
        items[0] = "Fraction"
        values[0] = bmp.irrigation_efficiency
        apex_op = "PND"
      when 10   #stream Fencing
        operation_name = "Stream_Fencing"
        items[0] = "Fence Width"
        values[0] = bmp.width
        apex_op = "SF"
      when 11 # Streambank stabilization
        operation_name = "Streambank_Stabilization"
        apex_op = "SB"
      when 13   #Riparian forest (12) or Filter StrIp (13)
        operation_name = "Grass_Buffer"
        items[0] = "Area"
        values[0] = bmp.area
        items[1] = "Grass Width"
        values[1] = bmp.width
        items[3] = "Fraction treated by buffer"
        values[3] = bmp.slope_reduction
        if bmp.depth == 12
          operation_name = "Forest_Buffer"
          items[2] = "Forest width"
          values[2] = bmp.grass_field_portion
          apex_op = "RF"
        else
          items[4] = "Crop"
          values[4] = Crop.find(bmp.crop_id).name
          apex_op = "FS"
        end

      when 12  # Filter Strip

      when 14  #waterways
        operation_name = "Grass_Waterway"
        items[4] = "Crop"
        values[4] = Crop.find(bmp.crop_id).name
        items[1] = "Width"
        items[1] = bmp.width
        items[3] = "Fraction treated by buffer"
        values[3] = bmp.slope_reduction
        apex_op = "WW"
      when 15  #contour buffer
        operation_name = "Contour_Buffer"
        items[4] = "Crop"
        values[4] = Crop.find(bmp.crop_id).name
        items[1] =  "Grass Buffer"
        values[1] = bmp.width
        items[2] = "Crop Buffer"
        values[2] = bmp.crop_width
        apex_op = "CF"
      when 16   #Land Leveling
        operation_name = "Land_Leveling"
        items[0] = "Slope Reduction"
        values[0] = bmp.slope_reduction
        apex_op = "LL"
      when 17  #Terrace System
        operation_name = "Terrace_System"
        apex_op = "TS"
      when 18  #Manure nutrient change
        operation_name = "Manure_Nutrient_Change"
        apex_op = "MA"
      when 28  #future climate
        items[0] = "Scenario Simulated"
        values[0] = bmp.depth   #1=Best, 2=Normal, 3=Worst
        apex_op = "FC"

      else #No entry need
    end #end case true
    xml.bmp {
      #save operation information
      xml.composite @scenario.name
      xml.applies_to @scenario.name
      xml.state state
      xml.year 0
      xml.month 0
      xml.day 0
      xml.apex_operation apex_op
      #xml.operation_name Bmpsublist.find(bmp.bmpsublist_id).name
      xml.operation_name operation_name
      xml.apex_crop 0
      xml.crop_name 'None'
      xml.year_in_rotation 0
      xml.rotation_length 0
      xml.frequency 0
      xml.item1 items[0]
      xml.value1 values[0]
      xml.item2 items[1]
      xml.value2 values[1]
      xml.item3 items[2]
      xml.value3 values[2]
      xml.item4 items[3]
      xml.value4 values[3]
      xml.item5 items[4]
      xml.value5 values[4]
      xml.item6 items[5]
      xml.value6 values[5]
      xml.item7 items[6]
      xml.value7 values[6]
      xml.item8 items[7]
      xml.value8 values[7]
      xml.item9 items[8]
      xml.value9 values[8]
    } # end xml.operation
  end  # end get_operations method

  ################################  get_operations - get operations and send them to server and simulate fem #################################
  def get_operations(op, state, xml)
    operation = SoilOperation.where(:operation_id => op.id).first
    items = Array.new
    values = Array.new
    crop_ant = 0
    oper_ant = 799
    found = false
    heta_units = 0.0
    crop_name = ""
    for i in 0..(8 - 1)
      items[i] = ""
      values[i] = 0
    end
    items[7] = "LATITUDE"
    items[8] = "LONGITUDE"
    apex_string = ""
    if crop_ant != op.crop_id then
      crop = Crop.find(op.crop_id)
      if crop != nil then
        lu_number = crop.lu_number
        harvest_code = crop.harvest_code
        heat_units = crop.type1
        crop_name = crop.code
      end
      crop_ant = operation.apex_crop
    end
    case op.activity_id
      when 1 #planting
        items[0] = "Heat Units"
        values[0] = operation.opv1
        items[1] = "Curve Number"
        values[1] = operation.opv2
        #check if crop is cover crop and add the speciat information in item2
        if Operation.find(operation.operation_id).subtype_id == 1 then
          items[2] = "Special"
          values[2] = "Cover_Crop"
        end
      when 2 # fertilizer            #fertilizer or fertilizer(folier)
        items[0] = op.type_id   #fertilizer code'
        values[0] = op.amount * AC_TO_HA
        items[1] = "Depth"
        values[1] = op.depth * IN_TO_MM
      when 3 #tillage
        items[0] = "Tillage"
        values[0] = 0
      when 4 #harvest
        items[1] = "Curve Number"
        values[1] = operation.opv2
      when 5 #kill
        items[0] = "Curve Number"
        values[0] = operation.opv2
        items[1] = "Time of Operation"
        values[1] = operation.opv2
      when 6 #irrigation
        items[0] = "Irrigation"
        values[0] = op.amount
      when 7 # grazing              #Grazing - kind and number of animals
        if @grazingb == false then
          items[3] = "DryMatterIntake"
          #create_herd file and send to APEX
          current_oper = Operation.find(operation.operation_id)
          values[3] = create_herd_file(current_oper.amount, current_oper.depth, current_oper.type_id, soil_percentage)
          #animalB = operation.ApexTillCode
          @grazingb = true
          if current_oper.no3_n != 0 || current_oper.po4_p != 0 || current_oper.org_n != 0 || current_oper.org_p != 0 || current_oper.nh3 != 0 then
            #animal_code = get_animal_code(operation.type_id)
            change_fert_for_grazing(current_oper.no3_n, current_oper.po4_p, current_oper.org_n, current_oper.org_p, current_oper.type_id, current_oper.nh3)
          end
        end
        items[0] = "Kind"
        values[0] = operation.type_id
        items[1] = "Animals"
        values[1] = operation.opv1
        items[2] = "Hours"
        values[2] = operation.opv2
      when 8 #stopGrazing
        items[0] = "Stop Grazing"
        values[0] = 0
      when 11 # liming
        items[0] = "Liming"
        values[0] = op.amount
      else #No entry needed.
    end #end case true
    operation_name = ""
    case operation.activity_id
      when 1, 3
        operation_name = Tillage.find_by_code(operation.apex_operation).name
      else
        operation_name = Activity.find(operation.activity_id).name
    end

        xml.operation {
          #save operation information
          xml.composite @scenario.name
          xml.applies_to @scenario.name
          xml.state state
          xml.year operation.year
          xml.month operation.month
          xml.day operation.day
          xml.apex_operation operation.apex_operation
          xml.operation_name operation_name
          xml.apex_crop operation.apex_crop
          xml.crop_name crop_name
          xml.year_in_rotation @scenario.soil_operations.last.year
          xml.rotation_length 0
          xml.frequency 0
          xml.item1 items[0]
          xml.value1 values[0]
          xml.item2 items[1]
          xml.value2 values[1]
          xml.item3 items[2]
          xml.value3 values[2]
          xml.item4 items[3]
          xml.value4 values[3]
          xml.item5 items[4]
          xml.value5 values[4]
          xml.item6 items[5]
          xml.value6 values[5]
          xml.item7 items[6]
          xml.value7 values[6]
          xml.item8 items[7]
          xml.value8 values[7]
          xml.item9 items[8]
          xml.value9 values[8]
        } # end xml.operation
      #} #end xml operations
    #end #builder do end

    #@fem_list.push(@scenario.name + COMA + @scenario.name + COMA + state + COMA + operation.year.to_s + COMA + operation.month.to_s + COMA + operation.day.to_s + COMA + operation.apex_operation.to_s + COMA + operation_name + COMA + operation.apex_crop.to_s +
                   #COMA + crop_name + COMA + @scenario.soil_operations.last.year.to_s + COMA + "0" + COMA + "0" + COMA + items[0].to_s + COMA + values[0].to_s + COMA + items[1].to_s + COMA + values[1].to_s + COMA + items[2].to_s + COMA + values[2].to_s + COMA + items[3].to_s + COMA + values[3].to_s + COMA + items[4].to_s + COMA +
                   #values[4].to_s + COMA + items[5] + COMA + values[5].to_s + COMA + items[6] + COMA + values[6].to_s + COMA + items[7] + COMA + values[7].to_s + COMA + items[8] + COMA + values[8].to_s)
  end  # end get_operations method

  ################################  copy scenario selected  #################################
  def copy_scenario
    @use_old_soil = false
    @scenarios = Scenario.where(:field_id => @field.id)
    scenario = Scenario.find(params[:id])
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    if check_dup_scenario(params[:field_id], scenario.name)
      flash.now[:alert] = "ERROR: '" + scenario.name + " copy' already exists. Please delete or rename the existing '" + scenario.name + " copy'"
    else
      msg = duplicate_scenario(params[:id], " copy", params[:field_id])
      if msg == "OK" 
        flash.now[:notice] = scenario.name + " " + t('notices.copied')
      else
        flash.now[:notice] = msg
      end
    end
    add_breadcrumb 'Scenarios'
    render "index"
  end

  def check_dup_scenario(field_id, scen_name)
    all_scen = Scenario.where(:field_id => @field.id)
    existing_scenarios = Array.new
    all_scen.each do |s|
      existing_scenarios << s.name
    end
    if existing_scenarios.include? scen_name + " copy"
      return true
    else
      return false
    end
  end
  ####### update subareas after they have been created in case BMPs have been applied ######
  def update_subareas(new_scenario, scenario)
    subarea = scenario.subareas[0]
    bmp = scenario.bmps.find_by_bmpsublist_id(16)
    new_scenario.subareas.each do |s|
      if bmp != nil
        s.slp = s.slp * (100-bmp.slope_reduction) / 100
      end
      s.pcof = subarea.pcof
      s.bcof = subarea.bcof
      s.bffl = subarea.bffl
      s.nirr = subarea.nirr
      s.iri = subarea.iri
      s.ira = subarea.ira
      s.lm = subarea.lm
      s.ifd = subarea.ifd
      s.idr = subarea.idr
      s.idf1 = subarea.idf1
      s.idf2 = subarea.idf2
      s.idf3 = subarea.idf3
      s.idf4 = subarea.idf4
      s.idf5 = subarea.idf5
      s.bir = subarea.bir
      s.efi = subarea.efi
      s.vimx = subarea.vimx
      s.armn = subarea.armn
      s.armx = subarea.armx
      s.bft = subarea.bft
      s.fnp4 = subarea.fnp4
      s.fmx = subarea.fmx
      s.drt = subarea.drt
      s.fdsf = subarea.fdsf
      s.pec = subarea.pec
      s.dalg = subarea.dalg
      s.vlgn = subarea.vlgn
      s.coww = subarea.coww
      s.ddlg = subarea.ddlg
      s.solq = subarea.solq
      s.sflg = subarea.sflg
      s.fnp2 = subarea.fnp2
      s.fnp5 = subarea.fnp5
      s.firg = subarea.firg
      s.ny1 = subarea.ny1
      s.ny2 = subarea.ny2
      s.ny3 = subarea.ny3
      s.ny4 = subarea.ny4
      s.ny5 = subarea.ny5
      s.ny6 = subarea.ny6
      s.ny7 = subarea.ny7
      s.ny8 = subarea.ny8
      s.ny9 = subarea.ny9
      s.ny10 = subarea.ny10
      s.xtp1 = subarea.xtp1
      s.xtp2 = subarea.xtp2
      s.xtp3 = subarea.xtp3
      s.xtp4 = subarea.xtp4
      s.xtp5 = subarea.xtp5
      s.xtp6 = subarea.xtp6
      s.xtp7 = subarea.xtp7
      s.xtp8 = subarea.xtp8
      s.xtp9 = subarea.xtp9
      s.xtp10 = subarea.xtp10
      s.save
    end #soils each do end
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
      add_scenario_to_soils(new_scenario, false)
      #3A. Update subarea with bmps informaiton
      update_subareas(new_scenario, scenario)
      #4. Copy operations info
      scenario.operations.each do |operation|
        new_op = operation.dup
        new_op.scenario_id = new_scenario.id
        new_op.save
        add_soil_operation(new_op,0)
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

  def upload_scenarios
    @errors = Array.new
    @scenarios = Scenario.where(:field_id => @field.id)
    if params[:type] != nil then
      case params[:type][:file]
      when "1"
      when "2"
        file_name = params[:scenarios]
        if file_name.respond_to?(:read)
          @data = file_name.read
        elsif file_name.respond_to?(:path)
          @data = File.read(file_name.path)
        else
          @erros.push "Bad file_data: #{@filename.class.name}: # {@filename.inspect}"
          return
        end
        msg = upload_scenarios_txt
      when "3"
        original_data = params[:scenarios].read
        @data = Nokogiri::XML(original_data.gsub("[","<").gsub("]",">")) 
        if @data.elements[0].name.downcase == "navigation"  #this is a comet project
          @data.root.elements.each do |node|
            if node.name == "FieldInfo"
              msg = upload_scenarios_comet(node)
            end
          end          
        else
          msg = upload_scenarios_xml
        end
        if msg.include? "Error"
          return
        end
      end # end case
    else
      @errors.push "Please select file type to upload"
    end
    add_breadcrumb t('menu.scenarios')

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @scenarios }
    end
  end

  def upload_scenarios_comet(node)
    #@data.xpath("//OperationInfo").each do |scn|
      ActiveRecord::Base.transaction do
        begin
          scenario = Scenario.new
          #scenario.name = scn.xpath("name").text
          scenario.name = @field.scenarios.last.name + "_1"
          scenario.field_id = @field.id
          if scenario.save
            #Copy subareas info by scenario
            add_scenario_to_soils(scenario, false)
            @graz_oper_id = 0
            node.elements.each do |opr|
              if opr.name == "OperationInfo"
                msg = upload_operation_comet_version(scenario.id, opr.elements)
              end
              if opr.name == "BmpInfo"
                msg = upload_bmp_comet_version(scenario.id, opr.elements)
              end
            end   # end node cicle
          end  # if scenario.save
        rescue => e
          @errors.push = "Failed, Error: " + e.inspect
          raise ActiveRecord::Rollback
        ensure
          next
        end   #end begin/rescue/ensure
      end  # end transaction
    #end  # end reading data elements.
    return "OK"
  end

  def upload_scenarios_txt
    ActiveRecord::Base.transaction do
      begin
        operations = @data.split(/\n/)
        if operations.count <= 0 then return "The file does not contain operations" end
        first = true
        operations.each do |operation|
          opr = operation.split(",")
          if opr.count <= 0 then return "The file does not contain operations" end
          if !first then if @scenario.name != opr[0] then first = true end end
          if first then
            @scenario = Scenario.new
            @scenario.name = opr[0]
            @scenario.field_id = @field.id
            first = false
            if !@scenario.save then return "Error saving new scenario" end
            #Copy subareas info by scenario
            add_scenario_to_soils(@scenario, false)
          end
          operation = Operation.new
          operation.scenario_id = @scenario.id
          operation.crop_id = opr[1]
          operation.year = opr[2]
          operation.month_id = opr[3]
          operation.day = opr[4]
          operation.rotation = opr[5]
          operation.activity_id = opr[6]

          case operation.activity_id
            when 1   #planting
              operation.type_id = opr[7]  #planting code 
              operation.amount = opr[8]  #seeding/ft2
            when 2   #fertilizer
              operation.type_id = opr[7]  #fertilizer category (commercial - manure)
              operation.subtype_id = opr[8]  #fertilizewr id
              operation.amount = opr[9]  #amount pallied lbs/ac
              operation.depth = opr[10]  #application depth
              operation.no3_n = opr[11]  #N %
              operation.po4_p = opr[12]  #P %
              operation.moisture = opr[13]
              if operation.type_id != 1 then  #for manure application
                calculate_nutrients(operation.no3_n, operation.moisture, operation.po4_p, operation.activity_id, operation.type_id, operation.subtype_id)
                operation.no3_n = params[:operation][:no3_n]
                operation.po4_p = params[:operation][:po4_p]
                operation.org_n = params[:operation][:org_n]
                operation.org_p = params[:operation][:org_p]
              end
            when 3   #Tillage
              operation.type_id = opr[7]  #tillage code
            when 4   #Harvest
            when 5   #Killing
            when 6   #irrigation
              operation.type_id = opr[7]  #irrigation code
              operation.amount = opr[8]  #volume
              operation.depth = opr[9]  #irrigation efficiency
            when 7   #Continues grazing
              operation.type_id = opr[7]  #animal code
              operation.subtype_id = (Date.new(params[:year1].to_i,params[:month_id1].to_i,params[:day1].to_i) - Date.new(operation.year,operation.month_id,operation.day)).to_i + 1
              operation.org_c = opr[9]  #access to strea? yes=1
              operation.depth = opr[11] #hours in field
              operation.nh3 = opr[10]   #hours in stream
            when 9   #Rotational grazing
              operation.type_id = opr[7]  #animal code
              operation.subtype_id = (Date.new(params[:year1].to_i,params[:month_id1].to_i,params[:day1].to_i) - Date.new(operation.year,operation.month_id,operation.day)).to_i + 1
              operation.org_c = opr[9]  #access to strea? yes=1
              operation.depth = opr[11] #hours in field
              operation.nh3 = opr[10]   #hours in stream
              operation.moisture = opr[12]
              operation.nh4_n = opr[13]
            when 11  #burn
            when 12  #Lime
              operation.amount = opr[7]  #application rate
          end
          if operation.save
            #saves start grazing operation in SoilOperation table
            if operation.activity_id != 9 && operation.activity_id != 10 then
              msg = add_soil_operation(operation,0)
            end
            saved = true
            #operations should be created in soils too. but not for rotational grazing
            if msg.eql?("OK")
              soil_op_saved = true
            else
              soil_op_saved = false
              raise ActiveRecord::Rollback
            end
            if operation.activity_id == 7 || operation.activity_id == 9 then
              operation_id = operation.id
              operation1 = Operation.new
              if operation.activity_id == 7 then
                operation1.activity_id = 8
                operation1.year = opr[12]
                operation1.month_id = opr[13]
                operation1.day = opr[14]
              else
                operation1.activity_id = 10
                operation1.year = opr[14]
                operation1.month_id = opr[15]
                operation1.day = opr[16]
              end
              operation1.type_id = operation_id
              operation1.scenario_id = operation.scenario_id
              operation1.amount = 0
              operation1.depth = 0
              operation1.no3_n = 0
              operation1.po4_p = 0
              operation1.org_n = 0
              operation1.org_p = 0
              operation1.nh3 = 0
              operation1.subtype_id = 0
              operation1.rotation = operation.rotation
              operation1.save
              if operation1.activity_id == 8 then
                msg = add_soil_operation(operation1,0)
                if msg.eql?("OK")
                  soil_op_saved = true
                else
                  soil_op_saved = false
                  raise ActiveRecord::Rollback
                end
              end
            end
          end
        end. # end operations.each
        msg = "Scenario " + @scenario.name + " created succesfully"
      rescue => e
        @errors.push = "Failed, Error: " + e.inspect
        raise ActiveRecord::Rollback
      ensure
        next
      end
    end  # end transaction
  end

  def upload_scenarios_xml
    # validates the xml file
    case true
      when @data.elements.length <= 0
        msg = "XML files does not have nodes"
        @errors.push msg
        return msg
      when @data.elements[0].name.downcase != "ntt" 
        msg = "Element[0] is not NTT - Please fix the xml file and try again."
        @errors.push msg
        return msg
      when @data.elements[0].elements.length <= 0
        msg = "XML files does not have scenarios"
        @errors.push msg
        return msg
      when @data.elements[0].elements[0].name != "scenario"
        msg = "XML files does not have ScenarioInfo node"
        @errors.push msg
        return msg
    end
    @data.xpath("//scenario").each do |scn|
      ActiveRecord::Base.transaction do
        begin
          scenario = Scenario.new
          scenario.name = scn.xpath("name").text
          scenario.field_id = @field.id
          if scenario.save
            #Copy subareas info by scenario
            add_scenario_to_soils(scenario, false)
            if scn.xpath("operation").length == 0 then 
              xscn = scn.xpath("operations")
            else
              xscn = scn
            end
            xscn.xpath("operation").each do |opr|
              operation = Operation.new
              operation.scenario_id = scenario.id
              operation.activity_id = opr.xpath("activity_id").text
              operation.crop_id = opr.xpath("crop_id").text
              operation.day = opr.xpath("day").text
              operation.month_id = opr.xpath("month").text
              operation.year = opr.xpath("year").text
              operation.rotation = opr.xpath("rotation").text
              case operation.activity_id
                when 1   #planting
                  operation.type_id = opr.xpath("type_id").text #planting method
                  operation.amount = opr.xpath("amount").text #seeding/ft2
                when 2   #fertilizer
                  operation.type_id = opr.xpath("type_id").text.  #fertilizer category (commercial/manure)
                  operation.subtype_id = opr.xpath("subtype_id").text  #fertilizer code
                  operation.amount = opr.xpath("amount").text #lbs/ac
                  operation.depth = opr.xpath("depth").text 
                  operation.no3_n = opr.xpath("no3_n").text #elemtn N %
                  operation.po4_p = opr.xpath("po4_p").text #elemt p %
                  if operation.moisture != nil then operation.moisture = opr[13] end
                  if operation.type_id != 1 then #manure application (solid or liquid)
                    calculate_nutrients(operation.no3_n, operation.moisture, operation.po4_p, operation.activity_id, operation.type_id, operation.subtype_id)
                    operation.no3_n = params[:operation][:no3_n]
                    operation.po4_p = params[:operation][:po4_p]
                    operation.org_n = params[:operation][:org_n]
                    operation.org_p = params[:operation][:org_p]
                  end
                when 3   #Tillage
                  operation.type_id = opr.xpath("type_id").text
                when 4   #Harvest
                when 5   #Killing
                when 6   #irrigation
                  operation.type_id = opr.xpath("type_id").text
                  operation.amount = opr.xpath("amount").text #volume in.
                  operation.depth = opr.xpath("depth").text #efficiency
                when 7   #Continues grazing
                  operation.type_id = opr.xpath("type_id").text #animal type
                  operation.amount = opr.xpath("amount").text #number of animals
                  operation.subtype_id = (Date.new(opr.xpath("year_end").text.to_i,opr.xpath("month_end").text.to_i,opr.xpath("day_end").text.to_i) - Date.new(operation.year,operation.month_id,operation.day)).to_i + 1
                  operation.org_c = opr.xpath("access_stream").text  #access to strea? yes=1 no=gallego
                  operation.depth = opr.xpath("hours_field").text #hours in field
                  operation.nh3 = opr.xpath("hours_stream").text   #hours in stream
                when 9   #Rotational grazing
                  operation.type_id = opr.xpath("type_id").text
                  operation.amount = opr.xpath("amount").text
                  operation.subtype_id = (Date.new(opr.xpath("year_end").text.to_i,opr.xpath("month_end").text.to_i,opr.xpath("day_end").text.to_i) - Date.new(operation.year,operation.month_id,operation.day)).to_i + 1
                  operation.org_c = opr.xpath("access_stream").text  #access to strea? yes=1
                  operation.depth = opr.xpath("hours_field").text #hours in field
                  operation.nh3 = opr.xpath("hours_stream").text   #hours in stream
                  operation.moisture = opr.xpath("days_per_padock").text   ## of consecutive days grazed in each paddock
                  operation.nh4_n = opr.xpath("rest_time").text   #paddock rest time between grazing (days)
                when 11  #burn
                when 12  #Lime
                  operation.amount = opr[7]
              end   #end case
              if operation.save
                #saves start grazing operation in SoilOperation table
                if operation.activity_id != 9 && operation.activity_id != 10 then
                  msg = add_soil_operation(operation,0)
                end
                saved = true
                #operations should be created in soils too. but not for rotational grazing
                if msg.eql?("OK")
                  soil_op_saved = true
                else
                  soil_op_saved = false
                  raise ActiveRecord::Rollback
                end
                if operation.activity_id == 7 || operation.activity_id == 9 then
                  operation_id = operation.id
                  operation1 = Operation.new
                  if operation.activity_id == 7 then
                    operation1.activity_id = 8
                    operation1.year = opr[12]
                    operation1.month_id = opr[13]
                    operation1.day = opr[14]
                  else
                    operation1.activity_id = 10
                    operation1.year = opr[14]
                    operation1.month_id = opr[15]
                    operation1.day = opr[16]
                  end
                  operation1.type_id = operation_id
                  operation1.scenario_id = operation.scenario_id
                  operation1.amount = 0
                  operation1.depth = 0
                  operation1.no3_n = 0
                  operation1.po4_p = 0
                  operation1.org_n = 0
                  operation1.org_p = 0
                  operation1.nh3 = 0
                  operation1.subtype_id = 0
                  operation1.rotation = operation.rotation
                  operation1.save
                  if operation1.activity_id == 8 then
                    msg = add_soil_operation(operation1,0)
                    if msg.eql?("OK")
                      soil_op_saved = true
                    else
                      soil_op_saved = false
                      raise ActiveRecord::Rollback
                    end
                  end
                end
                @scen = scenario.id
              end
              msg = "Scenario " + scenario.name + " created succesfully"
            end   # end node cicle
          end  # if scenario.save
        rescue => e
          @errors.push = "Failed, Error: " + e.inspect
          raise ActiveRecord::Rollback
        ensure
          next
        end   #end begin/rescue/ensure
      end  # end transaction
      scn.xpath("bmps").xpath("bmp").each do |new_bmp|
        upload_bmp_info_new_version(@scen, new_bmp)
      end
    end  # end reading data elements.
    return "OK"
  end


  def download
    download_apex_files()
  end

  def download_aplcat
    download_aplcat_files()
  end

  def download_fem
    download_fem_files()
  end

  def download_dndc
    download_dndc_files()
  end

  private
# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def scenario_params
    params.require(:scenario).permit(:name, :field_id, :scenario_select)
  end

end  #end class