
class WatershedsController < ApplicationController
  include ProjectsHelper
  include SimulationsHelper
  include ApplicationHelper

  before_action :set_notifications

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
    msg = "OK"
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
    				watershed_scenarios = WatershedScenario.where(:watershed_id => watershed_id).order(:field_id)
    				msg = create_control_file()			#this prepares the apexcont.dat file
    				if msg.eql?("OK") then msg = create_parameter_file() else return msg end			#this prepares the parms.dat file
    				#todo weather is created just from the first field at this time. and @scenario too. It should be for each field/scenario
    				@scenario = Scenario.find(watershed_scenarios[0].scenario_id)
    				#if msg.eql?("OK") then msg = create_weather_file(dir_name, watershed_scenarios[0].field_id) else return msg end			#this prepares the apex.wth file
            if msg.eql?("OK") then msg = create_site_file(Field.find_by_location_id(@project.location.id)) else return msg end		#this prepares the apex.sit file
            @field = watershed_scenarios[0].field
            if @project.location.state_id == 0 then 
              if msg.eql?("OK") then msg = send_files_to_APEX("APEX" + "  ") end  #this operation will create apexcont.dat, parms.dat, apex.sit, apex.wth files and the APEX folder from APEX1 folder
            else
              if msg.eql?("OK") then msg = send_files_to_APEX("APEX" + State.find(@project.location.state_id).state_abbreviation) else return msg end #this operation will create apexcont.dat, parms.dat, apex.sit, apex.wth files and the APEX folder from APEX1 folder  
            end
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
    			  state_id = @project.location.state_id
    			  @state_abbreviation = "**"
  			  	if state_id != 0 and state_id != nil then
  			  		@state_abbreviation = State.find(state_id).state_abbreviation
  			  	end
            if msg.eql?("OK") then msg = create_wind_wp1_files() else return msg end
            fields = ""
            watershed_scenarios.each do |p|
              fields += "(" + p.field_id.to_s + ":" + p.field.coordinates + ")"   #generate the string to send to R program
            end
            j=0
#todo remove this condition when move to production.
        if !(request.url.include?("ntt.bk.cbntt.org") || request.url.include?("localhost"))
            #############  this block for the old way of simulating watersheds ##########################
            watershed_scenarios.each do |p|
              @scenario = Scenario.find(p.scenario_id)
              @field = Field.find(p.field_id)
              @grazing = @scenario.operations.find_by_activity_id([7, 9])
              if @grazing == nil then
                @soils = Soil.where(:field_id => p.field_id).limit(1)
              else
                @soils = Soil.where(:field_id => p.field_id).limit(1)
              end
                if msg.eql?("OK") then msg = create_apex_soils() else return msg end
                if msg.eql?("OK") then msg = create_subareas(j+1) else return msg end
                j+=1
            end # en
            #############  this block for the old way of simulating watersheds ##########################
        

        else


            #############  this block for the new way of simulating watersheds ##########################
            #call R program. read results and create the new watershed_scnearios hash to run scenarios

              define_routing(fields)
              nn0 = @io.count-1
              i = 1
              while i <= nn0
                chl = 0
                rchl = 0
                if nn0 > 1 then
                  i1 = [1, @io[i]].max
                else
                  i1 = i
                  @ix[i1] = 1
                end
                field = Field.find(@nbsa[i1])
                field_area = field.field_area * AC_TO_HA
                xx = Math.sqrt(field_area)
                chl = xx * 0.1732
                if @ix[i1] > 0 then
                  if chl > 0 then 
                    rchl = chl
                  else  
                    if rchl > 0 then
                      chl = rchl
                    else   
                      chl = 0.1732 * xx
                      rchl = chl
                    end
                  end
                else  
                  if rchl < 0.000000000001 then
                    rchl = 0.1 * xx
                  else          
                    if chl < 0.000000000001 then
                      chl = 0.1732 * xx
                    else 
                      if (chl - rchl).abs < 1.E-5 then chl = 1.732 * rchl end
                    end
                  end
                end
                
                if @ia[i1] > 0 then field_area = field_area * -1 end
                @scenario = Scenario.find(field.watershed_scenarios.first.scenario_id)
                grazing = @scenario.operations.find_by_activity_id([7, 9])
                if @grazing == nil then
                  @soils = Soil.where(:field_id => field.id).limit(1)
                else
                  @soils = Soil.where(:field_id => field.id).limit(1)
                end
                if msg.eql?("OK") then msg = create_apex_soils() else return msg end

                if msg.eql?("OK") then msg = create_subareas_watershed(i, field_area, chl, rchl, field.id) else return msg end
                j+=1
                i+=1
              end  # end for i 1 to nn0
            #############  this block for the new way of simulating watersheds ##########################
        end


    				print_array_to_file(@soil_list, "soil.dat")
    				print_array_to_file(@opcs_list_file, "OPCS.dat")
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

  ################################ defibne_routing #################################
  # Read results from R routing program and order the fields accordingly
  def define_routing(fields)
    client = Savon.client(wsdl: URL_SoilsInfoDev)
    ###### Get the fields routing from R program########
    response = client.call(:get_routing, message: {"field_coordinates" => fields, "session" => session[:session_id]})
    if response.body[:get_routing_response][:get_routing_result].include? "Error" then
      return response.body[:get_routing_response][:get_routing_result]
    end
    rec = response.body[:get_routing_response][:get_routing_result].split(",")
    ie = Array.new
    @io = Array.new
    @nbsa = Array.new
    icmo = Array.new
    @ki = Array.new
    ir = Array.new
    iy = Array.new
    @ix = Array.new
    @ia = Array.new

    chl = Array.new
    rchl = Array.new
    wsa = Array.new
    chl = Array.new
    rchl = Array.new

    @io.push(0)
    ie.push(0)
    icmo.push(0)
    wsa.push(0)
    chl.push(0)
    rchl.push(0)
    @ia.push(0)
    @ix.push(0)
    ir.push(0)
    rec.each do |r|
      field = r.split(" ")
      ie.push(field[0])
      @io.push(field[1])
      icmo.push(0)
      chl.push(0)
      rchl.push(0)
      @ia.push(0)
      @ix.push(0)
      ir.push(0)
    end
    nn = ie.count - 1
    for i in 1..nn
      @nbsa[i] = ie[i]  #nbsa keep the entering fields
      ie[i]=i          #ie will keep the sequence 1,2,3..etc
      if @io[i] == "0" then icmo[i] = ie[i] end   #if io is the oulet it goes to icmo
      @ki[i]=i         # @ki will contain a sequence as in ie
    end
    nn0 = nn
    if nn >= 2 then
      for i in 1..nn
        #ir[i] = 0
        for j in 1..nn
          if @nbsa[i] != @io[j] then next end
            ir[j] = ie[i]
        end
      end
      for i in 1..nn
        ii = ie[i] - i
        iy[ie[i]] = ii
        ie[i] = i
      end
      for i in 1..nn
        debugger
        if ir[i] < 2 then next end
        ir[i] = ir[i] - iy[ir[i]]
      end
      for i in 1..nn
        ir[ie[i]] = ir[i]
      end
      for i in (nn..1).step(-1)
        if ir[@ki[i]] > 0 then next end
        @io[nn] = ie[@ki[i]]
        nn=elim(nn,i)
        break
      end
      i = nn0
      while nn > 0
        j = 1
        while j <= nn
          if ir[@ki[j]] == @io[i] then break end
          j += 1
        end
        if j > nn then
          @ix[@io[i]] = 1
          k = @io[i]
          loop do
            j = 1
            while j <= nn
              if ir[@ki[j]] == ir[k] then break end
              j += 1
            end
            if j <= nn then break end
            k = ir[k]
          end
          i = i - 1
          @io[i] = ie[@ki[j]]
        else
          i = i - 1
          @io[i] = ie[@ki[j]]
        end
        nn = elim(nn,j)
      end
      @ix[@io[1]] = 1
      for i in 1..nn0
        ii = ir[@io[i]]
        i1 = i + 1
        for j in i1..nn0
          if ir[@io[j]] == ii then @ia[@io[j]] = 1 end
        end
      end
    end   # end if > 2
  end  # end method

  def elim(nn,i)
    nn = nn - 1
    for j in i..nn
      @ki[j] = @ki[j+1]
    end
    return nn
  end

  #this is the new subarea creation method for watershed simulatons
  def create_subareas_watershed(operation_number, area, chl, rchl, field_id)  # operation_number is used for subprojects. for simple scenarios is 1
    last_owner1 = 0
    i=0
    nirr = 0
    if @grazing == nil and @soils.count > 1 then
      subareas = @scenario.subareas.where("soil_id > 0 AND (bmp_id = 0 OR bmp_id is NULL)")
    else
      subareas = @scenario.subareas.where("soil_id = " + @soils[0].id.to_s + " AND (bmp_id = 0 OR bmp_id is NULL)")
      subareas[0].wsa = @field.field_area * AC_TO_HA
    end
    subareas.each do |subarea|
      soil = subarea.soil
      #if soil.selected then
      create_operations(soil.id, soil.percentage, operation_number, 0)   # 0 for subarea from soil. Subarea_type = Soil
      add_subarea_file_watershed(field_id, area, chl, rchl, subarea, operation_number, last_owner1, i, nirr, false, @soils.count)
      i+=1
      @soil_number += 1
      #end  # end if soil.selected
    end  # end subareas.each for soil_id > 0
    #add subareas and operations for buffer BMPs.
    subareas = @scenario.subareas.where("bmp_id > 0")
    buffer_type = 2
    bmp = 1
    subareas.each do |subarea|

      add_subarea_file_watershed(field_id, subarea.wsa, subarea.chl, subarea.rchl, subarea, operation_number, last_owner1, i, nirr, true, @soils.count)

      if !(subarea.subarea_type == "PPDE" || subarea.subarea_type == "PPTW") then
        if subarea.subarea_type == "RF" then
          buffer_type = 1
        end
        if !(subarea.subarea_type == "CB" and bmp > 1) then
           create_operations(subarea.bmp_id, 0, operation_number, buffer_type)
           bmp += 1
        end


        @soil_number += 1
      end # end if bmp types PPDE and PPTW
    end  # end subareas.each for buffers
    msg = send_file_to_APEX(@subarea_file, "APEX.sub")
    return msg
  end   # end create_subareas
  
  #This add single subarea information for watershed simulations
  def add_subarea_file_watershed(field_id, area, chl, rchl, _subarea_info, operation_number, last_owner1, i, nirr, buffer, total_soils)
    j = i + 1
    #/line 1
    if buffer then
      @subarea_file.push(sprintf("%8d", field_id) + "0000000000000000   " + _subarea_info.description + "\n")
    else
      @subarea_file.push(sprintf("%8d", field_id) + _subarea_info.description + "\n")
    end
    #/line 2
    @last_soil2 = j + @last_soil_sub
    last_owner1 = @last_soil2
    if buffer then

      sLine = sprintf("%4d", operation_number)  #soil

      if (_subarea_info.subarea_type == "PPDE" || _subarea_info.subarea_type == "PPTW") then
        sLine += sprintf("%4d", _subarea_info.iops) #operation
      else
        #when @grazing the operation number should be the following because the subareas are reduce to 1
        if @grazing != nil then
          if session[:simulation] != "scenario" then
            _subarea_info.iops = @soil_number + 1 
          else
            _subarea_info.iops = i + 1
          end
        end
        if session[:simulation] != "scenario" then
          _subarea_info.iops = @soil_number + 1
        end
        sLine += sprintf("%4d", _subarea_info.iops)   #operation

      end
      sLine += sprintf("%4d", _subarea_info.iow) #owner id. Should change for each field
    else
      if session[:simulation] == "scenario" then
        sLine = sprintf("%4d", _subarea_info.inps)  #soil
        sLine += sprintf("%4d", _subarea_info.iops)   #operation
      else
        #sLine = sprintf("%4d", @soil_number+1)  #soil
        sLine = sprintf("%4d", operation_number)  #soil
        sLine += sprintf("%4d", @soil_number+1)   #operation
      end
      sLine += sprintf("%4d", _subarea_info.iow) #owner id. Should change for each field

    end
    if _subarea_info.iow == 0 then
      _subarea_info.iow = 1
    end
    sLine += sprintf("%4d", _subarea_info.ii)
    sLine += sprintf("%4d", _subarea_info.iapl)
    sLine += sprintf("%4d", 0) #column 6 line 1 is not used
    sLine += sprintf("%4d", _subarea_info.nvcn)
    sLine += sprintf("%4d", _subarea_info.iwth)
    sLine += sprintf("%4d", _subarea_info.ipts)
    sLine += sprintf("%4d", _subarea_info.isao)
    sLine += sprintf("%4d", _subarea_info.luns)
    sLine += sprintf("%4d", _subarea_info.imw)
    @subarea_file.push(sLine + "\n")
    #/line 3
    sLine = sprintf("%8.2f", _subarea_info.sno)
    sLine += sprintf("%8.2f", _subarea_info.stdo)
    sLine += sprintf("%8.2f", _subarea_info.yct)
    sLine += sprintf("%8.2f", _subarea_info.xct)
    sLine += sprintf("%8.2f", _subarea_info.azm)
    if @apex_version == 1501 then
      sLine += sprintf("%8.2f", 0)   #add SAEL column
    end
    sLine += sprintf("%8.2f", _subarea_info.fl)
    sLine += sprintf("%8.2f", _subarea_info.fw)
    sLine += sprintf("%8.2f", _subarea_info.angl)
    @subarea_file.push(sLine + "\n")
    #/line 4

    _subarea_info.wsa = area.round(2)
    if _subarea_info.wsa == 0.00 then
      _subarea_info.wsa = 0.01
    end
    if _subarea_info.wsa > 0 && i > 0 && !buffer then
      sLine = sprintf("%8.2f", _subarea_info.wsa * -1)
    else
      sLine = sprintf("%8.2f", _subarea_info.wsa)
    end
    sLine = sprintf("%8.2f", _subarea_info.wsa)

    sLine += sprintf("%8.4f", chl)
    sLine += sprintf("%8.2f", _subarea_info.chd)
    sLine += sprintf("%8.2f", _subarea_info.chs)
    sLine += sprintf("%8.2f", _subarea_info.chn)
    sLine += sprintf("%8.4f", _subarea_info.slp)
    sLine += sprintf("%8.2f", _subarea_info.splg)
    sLine += sprintf("%8.2f", _subarea_info.upn)
    sLine += sprintf("%8.2f", _subarea_info.ffpq)
    sLine += sprintf("%8.2f", _subarea_info.urbf)
    @subarea_file.push(sLine + "\n")
    #/line 5
    sLine = sprintf("%8.4f", rchl)
    sLine += sprintf("%8.2f", _subarea_info.rchd)
    sLine += sprintf("%8.2f", _subarea_info.rcbw)
    sLine += sprintf("%8.2f", _subarea_info.rctw)
    sLine += sprintf("%8.2f", _subarea_info.rchs)
    sLine += sprintf("%8.2f", _subarea_info.rchn)
    sLine += sprintf("%8.4f", _subarea_info.rchc)
    sLine += sprintf("%8.4f", _subarea_info.rchk)
    sLine += sprintf("%8.0f", _subarea_info.rfpw)
    sLine += sprintf("%8.4f", _subarea_info.rfpl)
    if @apex_version == 1501 then
      sLine += sprintf("%8.2f", 0)   #add SAT1 column
      sLine += sprintf("%8.2f", 0)   #add FPS1 column
    end    
    @subarea_file.push(sLine + "\n")
    #/line 6
    sLine = sprintf("%8.2f", _subarea_info.rsee)
    sLine += sprintf("%8.2f", _subarea_info.rsae)
    sLine += sprintf("%8.2f", _subarea_info.rsve)
    sLine += sprintf("%8.2f", _subarea_info.rsep)
    sLine += sprintf("%8.2f", _subarea_info.rsap)
    sLine += sprintf("%8.2f", _subarea_info.rsvp)
    sLine += sprintf("%8.2f", _subarea_info.rsv)
    sLine += sprintf("%8.2f", _subarea_info.rsrr)
    sLine += sprintf("%8.2f", _subarea_info.rsys)
    sLine += sprintf("%8.2f", _subarea_info.rsyn)
    @subarea_file.push(sLine + "\n")
    #/line 7
    sLine = sprintf("%8.3f", _subarea_info.rshc)
    sLine += sprintf("%8.2f", _subarea_info.rsdp)
    sLine += sprintf("%8.2f", _subarea_info.rsbd)
    if _subarea_info.pcof == nil then
      _subarea_info.pcof = 0
    end
    sLine += sprintf("%8.2f", _subarea_info.pcof)
    if _subarea_info.bcof == nil then
      _subarea_info.bcof = 0
    end
    sLine += sprintf("%8.2f", _subarea_info.bcof)
    sLine += sprintf("%8.2f", _subarea_info.bffl)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    sLine += sprintf("%8.2f", 0.00)
    @subarea_file.push(sLine + "\n")
      #/line 8
    sLine = "  0"
    if _subarea_info.nirr > 0 then
      sLine += sprintf("%1d", _subarea_info.nirr)
    else
      #if not check if there is manual irrigaiton in the operations.
      irrigation_op = _subarea_info.scenario.operations.find_by_activity_id(6)
      if irrigation_op != nil then
        sLine += sprintf("%1d", irrigation_op.type_id.to_s)
      else
        sLine += sprintf("%1d", _subarea_info.nirr)
      end
    end
    sLine += sprintf("%4d", _subarea_info.iri)
    sLine += sprintf("%4d", _subarea_info.ira)
    sLine += sprintf("%4d", _subarea_info.lm)
    sLine += sprintf("%4d", _subarea_info.ifd)
    sLine += sprintf("%4d", _subarea_info.idr)
    sLine += sprintf("%4d", _subarea_info.idf1)
    sLine += sprintf("%4d", _subarea_info.idf2)
    sLine += sprintf("%4d", _subarea_info.idf3)
    sLine += sprintf("%4d", _subarea_info.idf4)
    sLine += sprintf("%4d", _subarea_info.idf5)
    if @apex_version == 1501 then
      sLine += sprintf("%4d", 0)   #add idf6 column
      sLine += sprintf("%4d", 0)   #add irrs column
      sLine += sprintf("%4d", 0)   #add irrw column
    end    
    @subarea_file.push(sLine + "\n")
    #/line 9
    if _subarea_info.nirr > 0 then
      sLine = sprintf("%8.2f", _subarea_info.bir)
    else
      sLine = sprintf("%8.2f", 0)
    end
    sLine += sprintf("%8.2f", _subarea_info.efi)
    if _subarea_info.nirr > 0 then
      sLine += sprintf("%8.2f", _subarea_info.vimx)
    else
      sLine += sprintf("%8.2f", 0)
    end
    sLine += sprintf("%8.2f", _subarea_info.armn)
    if _subarea_info.nirr > 0 then
      sLine += sprintf("%8.2f", _subarea_info.armx)
      sLine += sprintf("%8.2f", _subarea_info.bft)
    else
      sLine += sprintf("%8.2f", 0)
      sLine += sprintf("%8.2f", 0)
    end
    sLine += sprintf("%8.2f", _subarea_info.fnp4)
    sLine += sprintf("%8.2f", _subarea_info.fmx)
    sLine += sprintf("%8.2f", _subarea_info.drt)
    sLine += sprintf("%8.2f", _subarea_info.fdsf)
    @subarea_file.push(sLine + "\n")
    #/line 10
    if !buffer && @c_cs then
      _subarea_info.pec -= 0.20
    end
    sLine = sprintf("%8.2f", _subarea_info.pec)
    sLine += sprintf("%8.2f", _subarea_info.dalg)
    sLine += sprintf("%8.2f", _subarea_info.vlgn)
    sLine += sprintf("%8.2f", _subarea_info.coww)
    sLine += sprintf("%8.2f", _subarea_info.ddlg)
    sLine += sprintf("%8.2f", _subarea_info.solq)
    sLine += sprintf("%8.2f", _subarea_info.sflg)
    sLine += sprintf("%8.2f", _subarea_info.fnp2)
    sLine += sprintf("%8.2f", _subarea_info.fnp5)
    sLine += sprintf("%8.2f", _subarea_info.firg)
    @subarea_file.push(sLine + "\n")
    #/line 11
    if @grazingb == true and _subarea_info.xtp1 == 0 then
      sLine = sprintf("%4d", 1)
    else
      sLine = sprintf("%4d", _subarea_info.ny1)
    end
    sLine += sprintf("%4d", _subarea_info.ny2)
    sLine += sprintf("%4d", _subarea_info.ny3)
    sLine += sprintf("%4d", _subarea_info.ny4)
    @subarea_file.push(sLine + "\n")
    #/line 12
    if @grazingb == true and _subarea_info.xtp1 == 0 then
      sLine = sprintf("%8.2f", 0.01)
    else
      sLine = sprintf("%8.2f", _subarea_info.xtp1)
    end
    sLine += sprintf("%8.2f", _subarea_info.xtp2)
    sLine += sprintf("%8.2f", _subarea_info.xtp3)
    sLine += sprintf("%8.2f", _subarea_info.xtp4)
    @subarea_file.push(sLine + "\n")

    return "OK"
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
