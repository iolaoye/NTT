class ScenariosController < ApplicationController
  #load_and_authorize_resource :field
  #load_and_authorize_resource :scenario, :through => :field

  include ScenariosHelper
  include SimulationsHelper
  include ProjectsHelper
  include ApplicationHelper
  include FemHelper
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

################################  simualte either NTT or APLCAT or FEM #################################
  def simulate
  	msg = "OK"
  	time_begin = Time.now
  	session[:simulation] = 'scenario'
  	case true
  		when params[:commit].include?('NTT')
  			msg = simulate_ntt
  		when params[:commit].include?("APLCAT")
  			msg = simulate_aplcat
      when params[:commit].include?("FEM")
        msg = simulate_fem
  	end
    if msg.eql?("OK") then
      #@scenario = Scenario.find(params[:select_scenario])
      flash[:notice] = @scenarios_selected.count.to_s + " " + t('scenario.simulation_success') + " " + (Time.now - time_begin).round(2).to_s + " " + t('datetime.prompts.second').downcase if @scenarios_selected.count > 0
      redirect_to project_field_scenarios_path(@project, @field)
    else
      render "index", error: msg
    end # end if msg
  end

################################  Simulate NTT for selected scenarios  #################################
  def simulate_ntt
    @errors = Array.new
    msg = "OK"
    @apex_version = 806
    if params[:select_scenario] == nil and params[:select_1501] == nil then msg = "Select at least one scenario to simulate " end
  	if msg != "OK" then
  		@errors.push(msg)
  		return msg
  	end
    if params[:select_scenario] == nil then
      @scenarios_selected = params[:select_1501]
      @apex_version = 1501
    else

      @scenarios_selected = params[:select_scenario]
      apex_version = 806
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
      end # end each do params loop
    end
  	return msg
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
        @scenarios = Scenario.where(:field_id => params[:field_id])
        #add new scenario to soils
        flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.created')
        add_scenario_to_soils(@scenario, false)
        format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('models.scenario') + " " + t('general.success') }
      else
	    flash[:info] = t('scenario.scenario_name') + " " + t('errors.messages.blank') + " / " + t('errors.messages.taken') + "."
        format.html { redirect_to project_field_scenarios_path(@project, @field) }
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
        format.html { redirect_to project_field_scenarios_path(@project, @field), notice: t('models.scenario') + " " + @scenario.name + t('notices.updated') }
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
    if @scenario.destroy
      flash[:notice] = t('models.scenario') + " " + @scenario.name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to project_field_scenarios_path(@project, @field) }
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
  			format.html { redirect_to project_field_scenarios_path(@project, @field) }
  		  else
  			flash[:error] = "Error simulating scenario - " + msg
  			format.html { render action: "list" }
  		  end # end if msg
  		end
  	end
  end

################################  FEM - simulate the selected scenario for FEM #################################
  def simulate_fem
    @errors = Array.new
    msg = "OK"
    msg = fem_tables()
    if params[:select_scenario] == nil then
      @errors.push("Select at least one scenario to simulate ")
      return "Select at least one scenario to simulate "
    end
    @scenarios_selected = params[:select_scenario]
    ActiveRecord::Base.transaction do
      @scenarios_selected.each do |scenario_id|
        @scenario = Scenario.find(scenario_id)
        if @scenario.operations.count <= 0 then
          @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
          return
        end
        if @scenario.crop_results.count <=0 then
          @errors.push("Error simulating scenario " + @scenario.name + " (You should run 'Simulate NTT' before simulating FEM )")
          return
        end
        msg = run_fem
        unless msg.eql?("OK")
          @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
          raise ActiveRecord::Rollback
        end # end unless msg
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
      if xmlString.include? "feed"
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
      if xmlString.include? "feed"
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
      if xmlString.include? "feed"
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
          @scenario.operations.each do |op|
            get_operations(op, state, xml)
          end
        }
        #todo add bmps

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
    for i in 0..(8 - 1)
      items[i] = ""
      values[i] = 0
    end

    case bmp.bmpsublist_id
      when 1 #autoirrigation or autofertigation
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

          items[5] = "Application Depth"
          values[5] = bmp.dry_manure
          apex_op = "AF"
        end
      when 3 #Tile Drain
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
        items[0] = "Area"
        values[0] = bmp.area
        apex_op = "WL"
      when 9 #Ponds
        items[0] = "Fraction"
        values[0] = bmp.irrigation_efficiency
        apex_op = "PND"
      when 10   #stream Fencing
        items[0] = "Fence Width"
        values[0] = bmp.width
        apex_op = "SF"
      when 11 # Streambank stabilization
        apex_op = "SB"
      when 13   #Riparian forest (12) or Filter StrIp (13)
        items[0] = "Area"
        values[0] = bmp.area
        items[1] = "Grass Width"
        values[1] = bmp.width
        items[3] = "Fraction treated by buffer"
        values[3] = bmp.slope_reduction
        if bmp.depth == 12
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
        items[4] = "Crop"
        values[4] = Crop.find(bmp.crop_id).name
        items[1] = "Width"
        items[1] = bmp.width
        items[3] = "Fraction treated by buffer"
        values[3] = bmp.slop
        apex_op = "PP"
      when 15  #contour buffer
        items[4] = "Crop"
        values[4] = Crop.find(bmp.crop_id).name
        items[1] =  "Grass Buffer"
        values[1] = bmp.width
        items[2] = "Crop Buffer"
        values[2] = bmp.crop_width
        apex_op = "CF"
      when 16   #Land Leveling
        items[0] = "Slope Reduction"
        values[0] = bmp.slope_reduction
        apex_op = "LL"
      when 17  #Terrace System
        apex_op = "TS"
      when 18  #Manure nutrient change
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
      xml.operation_name Bmpsublist.find(bmp.bmpsublist_id).name
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

  ################################  aplcat - simulate the selected scenario for aplcat #################################
  def simulate_aplcat
    @errors = Array.new
  	if params[:select_scenario] == nil then
  		@errors.push("Select at least one Aplcat to simulate ")
  		return "Select at least one Aplcat to simulate "
  	end
    @scenarios_selected = params[:select_scenario]
    ActiveRecord::Base.transaction do
  	  @scenarios_selected.each do |scenario_id|
  		  @scenario = Scenario.find(scenario_id)
  		  msg = run_aplcat
  		  unless msg.eql?("OK")
    			if msg.include?('cannot be null')
    		  	  @errors.push(@scenario.name + " " + t('scenario.add_crop_rotation'))
    		  	else
    			  @errors.push("Error simulating scenario " + @scenario.name + " (" + msg + ")")
    			end
    			raise ActiveRecord::Rollback
  	    end # end if msg
      end # end each do params loop
  	end
  end  # end method simulate_aplcat

  ################################  aplcat - run the selected scenario for aplcat #################################
  def run_aplcat
	    msg = "OK"
	    #find the aplcat parameters for the sceanrio selected
		aplcat = AplcatParameter.find_by_scenario_id(@scenario.id)
		grazing = GrazingParameter.where(:scenario_id => @scenario.id)
		supplement = SupplementParameter.where(:scenario_id => @scenario.id)
    aplcatresult = AplcatResult.where(:scenario_id => @scenario.id)
		if aplcat == nil then
			aplcat = AplcatParameter.new
			aplcat.scenario_id = params[:select_scenario][0]
			aplcat.save
		end
	    msg = send_file_to_APEX("APLCAT", "APLCAT")  #this operation will create APLCAT+session folder from APLCAT folder

    apex_string = "General data on cow-calf system" + "\n"
    apex_string += "\n"		# create string for the CowCalfProductionData.txt file
		apex_string += aplcat.noc.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += aplcat.nomb.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += aplcat.norh.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    apex_string += aplcat.nocrh.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    apex_string += aplcat.prh.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    apex_string += aplcat.prb.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    apex_string += aplcat.abwc.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    apex_string += aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.parameter8') + "\n"   #average body weight of mature cows
    apex_string += aplcat.abwh.to_s + "\t" + "! " + t('aplcat.parameter9') + "\n"
    apex_string += aplcat.abwrh.to_s + "\t" + "! " + t('aplcat.parameter10') + "\n"
    apex_string += aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.parameter11') + "\n"
    apex_string += aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.parameter12') + "\n"
    apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.parameter13') + "\n"
    apex_string += aplcat.gpc.to_s + "\t" + "! " + t('aplcat.parameter14') + "\n"
    apex_string += aplcat.tpwg.to_s + "\t" + "! " + t('aplcat.parameter15') + "\n"
    apex_string += aplcat.csefa.to_s + "\t" + "! " + t('aplcat.parameter16') + "\n"
    apex_string += aplcat.srop.to_s + "\t" + "! " + t('aplcat.parameter17') + "\n"
    apex_string += aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.parameter18') + "\n"
    apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.parameter19') + "\n"
    apex_string += aplcat.abc.to_s + "\t" + "! " + t('aplcat.parameter20') + "\n"
    apex_string += "\n"
		apex_string += "PARAMETER DETAILS" + "\n"
		apex_string += "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Numbers and proportions" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + t('aplcat.noc') + "\n"
    apex_string += "Parameter 2" + "\t" + t('aplcat.nomb') + "\n"
    apex_string += "Parameter 3" + "\t" + t('aplcat.norh') + "\n"
    apex_string += "Parameter 4" + "\t" + t('aplcat.nocrh') + "\n"
    apex_string += "Parameter 5" + "\t" + t('aplcat.prh') + "\n"
    apex_string += "Parameter 6" + "\t" + t('aplcat.prb') + "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Animal weights and rate of weight gain (Unit: lb)" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 7" + "\t" + t('aplcat.abwc') + "\n"
    apex_string += "Parameter 8" + "\t" + t('aplcat.abwmb') + "\n"
    apex_string += "Parameter 9" + "\t" + t('aplcat.abwh') + "\n"
    apex_string += "Parameter 10" + "\t" + t('aplcat.abwrh') + "\n"
    apex_string += "Parameter 11" + "\t" + t('aplcat.adwgbc') + "\n"
    apex_string += "Parameter 12" + "\t" + t('aplcat.adwgbh') + "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Breed, Pregnancy, calving, and weaning" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 13" + "\t" + t('aplcat.jdcc') + "\n"
    apex_string += "Parameter 14" + "\t" + t('aplcat.gpc') + "\n"
    apex_string += "Parameter 15" + "\t" + t('aplcat.tpwg') + "\n"
    apex_string += "Parameter 16" + "\t" + t('aplcat.csefa') + "\n"
    apex_string += "Parameter 17" + "\t" + t('aplcat.srop') + "\n"
    apex_string += "Parameter 18" + "\t" + t('aplcat.bwoc') + "\n"
    apex_string += "Parameter 19" + "\t" + t('aplcat.jdbs') + "\n"
    apex_string += "Parameter 20" + "\t" + t('aplcat.abc') + "\n"
    apex_string += "\n"
		apex_string += "FORMAT AND RANGE" + "\n"
		apex_string += "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Numbers and proportions" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + "integer" + "\n"
    apex_string += "Parameter 2" + "\t" + "integer" + "\n"
    apex_string += "Parameter 3" + "\t" + "integer" + "\n"
    apex_string += "Parameter 4" + "\t" + "integer" + "\n"
    apex_string += "Parameter 5" + "\t" + "real" + "(Range 0.1 to 99.9  typical 10 to 20)" + "\n"
    apex_string += "Parameter 6" + "\t" + "real" + "(Range 0.1 to 99.9  typical 10 to 30)" + "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Animal weights and rate of weight gain (Unit: lb)" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 7" + "\t" + "real" + "(Range 800.0 to 1400.00)" + "\n"
    apex_string += "Parameter 8" + "\t" + "real" + "(Range 1000.0 to 1800.0)" + "\n"
    apex_string += "Parameter 9" + "\t" + "real" + "(Range 900.0 to 1200.00)" + "\n"
    apex_string += "Parameter 10" + "\t" + "real" + "(Range 400.0  to 900.0)" + "\n"
    apex_string += "Parameter 11" + "\t" + "real" + "(Range 0.0 to 3.0)" + "\n"
    apex_string += "Parameter 12" + "\t" + "real" + "(Range 0.0 to 3.0)" + "\n"
    apex_string += "\n"
		apex_string += "Animal production data: Breed, Pregnancy, calving, and weaning" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 13" + "\t" + "integer" + "(Range 1 to 366)" + "\n"
    apex_string += "Parameter 14" + "\t" + "integer" + "(Range 1 to 366)" + "\n"
    apex_string += "Parameter 15" + "\t" + "real" + "(Range 80.0 to 120.0)" + "\n"
    apex_string += "Parameter 16" + "\t" + "integer" + "(Range 80 to 120)" + "\n"
    apex_string += "Parameter 17" + "\t" + "real" + "(Range 0.7 to 1.0)" + "\n"
    apex_string += "Parameter 18" + "\t" + "real" + "(Range 50.0 to 80.0)" + "\n"
    apex_string += "Parameter 19" + "\t" + "integer" + "(1 to 366)" + "\n"
    apex_string += "Parameter 20" + "\t" + "integer" + "(1 to 31)" + "\n"
    apex_string += "\n"
		#***** send file to server "
		msg = send_file_to_APEX(apex_string, "CowCalfProductionData.txt")

    # create string for the SimulParms.txt file

    apex_string += aplcat.mrgauh.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += aplcat.plac.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += aplcat.pcbb.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    apex_string += aplcat.fmbmm.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    apex_string += aplcat.domd.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    apex_string += aplcat.vsim.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    apex_string += aplcat.faueea.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    apex_string += aplcat.acim.to_s + "\t" + "! " + t('aplcat.parameter8') + "\n"
    apex_string += aplcat.mmppm.to_s + "\t" + "! " + t('aplcat.parameter9') + "\n"
    apex_string += aplcat.cffm.to_s + "\t" + "! " + t('aplcat.parameter10') + "\n"
    apex_string += aplcat.fnemm.to_s + "\t" + "! " + t('aplcat.parameter11') + "\n"
    apex_string += aplcat.effd.to_s + "\t" + "! " + t('aplcat.parameter12') + "\n"
    apex_string += aplcat.ptbd.to_s + "\t" + "! " + t('aplcat.parameter13') + "\n"
    apex_string += aplcat.pocib.to_s + "\t" + "! " + t('aplcat.parameter14') + "\n"
    apex_string += aplcat.bneap.to_s + "\t" + "! " + t('aplcat.parameter15') + "\n"
    apex_string += aplcat.cneap.to_s + "\t" + "! " + t('aplcat.parameter16') + "\n"
    apex_string += aplcat.hneap.to_s + "\t" + "! " + t('aplcat.parameter17') + "\n"
    apex_string += aplcat.pobw.to_s + "\t" + "! " + t('aplcat.parameter18') + "\n"
    apex_string += aplcat.posw.to_s + "\t" + "! " + t('aplcat.parameter19') + "\n"
    apex_string += aplcat.posb.to_s + "\t" + "! " + t('aplcat.parameter20') + "\n"
    apex_string += aplcat.poad.to_s + "\t" + "! " + t('aplcat.parameter21') + "\n"
    apex_string += aplcat.poada.to_s + "\t" + "! " + t('aplcat.parameter22') + "\n"
    apex_string += aplcat.cibo.to_s + "\t" + "! " + t('aplcat.parameter23') + "\n"
    apex_string += "\n"
		apex_string += "Simulation Parameters" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + t('aplcat.mrgauh') + "\n"
    apex_string += "Parameter 2" + "\t" + t('aplcat.plac') + "\n"
    apex_string += "Parameter 3" + "\t" + t('aplcat.pcbb') + "\n"
    apex_string += "Parameter 4" + "\t" + t('aplcat.fmbmm') + "\n"
    apex_string += "Parameter 5" + "\t" + t('aplcat.domd') + "\n"
    apex_string += "Parameter 6" + "\t" + t('aplcat.vsim') + "\n"
    apex_string += "Parameter 7" + "\t" + t('aplcat.faueea') + "\n"
    apex_string += "Parameter 8" + "\t" + t('aplcat.acim') + "\n"
    apex_string += "Parameter 9" + "\t" + t('aplcat.mmppm') + "\n"
    apex_string += "Parameter 10" + "\t" + t('aplcat.cffm') + "\n"
    apex_string += "Parameter 11" + "\t" + t('aplcat.fnemm') + "\n"
    apex_string += "Parameter 12" + "\t" + t('aplcat.effd') + "\n"
    apex_string += "Parameter 13" + "\t" + t('aplcat.ptbd') + "\n"
    apex_string += "Parameter 14" + "\t" + t('aplcat.pocib') + "\n"
    apex_string += "Parameter 15" + "\t" + t('aplcat.bneap') + "\n"
    apex_string += "Parameter 16" + "\t" + t('aplcat.cneap') + "\n"
    apex_string += "Parameter 17" + "\t" + t('aplcat.hneap') + "\n"
    apex_string += "Parameter 18" + "\t" + t('aplcat.pobw') + "\n"
    apex_string += "Parameter 19" + "\t" + t('aplcat.posw') + "\n"
    apex_string += "Parameter 20" + "\t" + t('aplcat.posb') + "\n"
    apex_string += "Parameter 21" + "\t" + t('aplcat.poad') + "\n"
    apex_string += "Parameter 22" + "\t" + t('aplcat.poada') + "\n"
    apex_string += "Parameter 23" + "\t" + t('aplcat.cibo') + "\n"
    apex_string += "\n"
		apex_string += "PARAMETER FORMAT AND RANGE" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + "real" + "0.0 to 7.0" + "\n"
    apex_string += "Parameter 2" + "\t" + "real" + "45 to 65" + "\n"
    apex_string += "Parameter 3" + "\t" + "real" + "45 to 65" + "\n"
    apex_string += "Parameter 4" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 5" + "\t" + "real" + "0 to 100" + "\n"
    apex_string += "Parameter 6" + "\t" + "real" + "> 0" + "\n"
    apex_string += "Parameter 7" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 8" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 9" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 10" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 11" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 12" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 13" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 14" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 15" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 16" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 17" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 18" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 19" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "\n"
		#***** send file to server "
		msg = send_file_to_APEX(apex_string, "SimulParms.txt")

    apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += aplcat.nit.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += aplcat.fqd.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    apex_string += aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    apex_string += aplcat.srwc.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    apex_string += aplcat.byos.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    apex_string += aplcat.eyos.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    apex_string += "\n"
		apex_string += "Details of model parameters on simulation methods" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + t('aplcat.mm_type') + "\n"
    apex_string += "Parameter 2" + "\t" + t('aplcat.nit') + "\n"
    apex_string += "Parameter 3" + "\t" + t('aplcat.fqd') + "\n"
    apex_string += "Parameter 4" + "\t" + t('aplcat.uovfi') + "\n"
    apex_string += "Parameter 5" + "\t" + t('aplcat.srwc') + "\n"
    apex_string += "Parameter 6" + "\t" + t('aplcat.byos') + "\n"
    apex_string += "Parameter 7" + "\t" + t('aplcat.eyos') + "\n"
    apex_string += "\n"
		apex_string += "PARAMETER FORMAT AND RANGE" + "\n"
		apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + "integer" + "1 or 2" + "\n"
    apex_string += "Parameter 2" + "\t" + "integer" + "1,2, or 3" + "\n"
    apex_string += "Parameter 3" + "\t" + "integer" + "1 or 0" + "\n"
    apex_string += "Parameter 4" + "\t" + "integer" + "1 or 0" + "\n"
    apex_string += "Parameter 5" + "\t" + "integer" + "1 or 0" + "\n"
    apex_string += "Parameter 6" + "\t" + "integer" + "Four digit year" + "\n"
    apex_string += "Parameter 7" + "\t" + "integer" + "Four digit year" + "\n"
    apex_string += "\n"
		#***** send file to server "
		msg = send_file_to_APEX(apex_string, "SimulMethods.txt")

    apex_string += aplcat.mdogfc.to_s + "\t" + "! " + t('aplcat.mdogfc') + "\n"
    apex_string += aplcat.mxdogfc.to_s + "\t" + "! " + t('aplcat.mxdogfc') + "\n"
    apex_string += aplcat.cwsoj.to_s + "\t" + "! " + t('aplcat.cwsoj') + "\n"
    apex_string += aplcat.cweoj.to_s + "\t" + "! " + t('aplcat.cweoj') + "\n"
    #apex_string += sprintf("%.2f", aplcat.ewc) + "\t" + "! " + t('aplcat.ewc') + "\n"
    apex_string += aplcat.nodew.to_s + "\t" + "! " + t('aplcat.nodew') + "\n"
    #***** send file to server "
		msg = send_file_to_APEX(apex_string, "SimFileAPLCAT.txt")

    apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
		apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
    #apex_string += aplcat.vsim_gp.to_s + "\t" + "! " + t('aplcat.vsim') + "\n"
		apex_string += aplcat.foue.to_s + "\t" + "! " + t('aplcat.foue') + "\n"
		apex_string += aplcat.ash.to_s + "\t" + "! " + t('aplcat.ash') + "\n"
		apex_string += aplcat.mmppfm.to_s + "\t" + "! " + t('aplcat.mmppfm') + "\n"
		apex_string += aplcat.cfmms.to_s + "\t" + "! " + t('aplcat.cfmms') + "\n"
		apex_string += aplcat.fnemimms.to_s + "\t" + "! " + t('aplcat.fnemimms') + "\n"
		apex_string += aplcat.effn2ofmms.to_s + "\t" + "! " + t('aplcat.effn2ofmms') + "\n"
		apex_string += aplcat.ptdife.to_s + "\t" + "! " + t('aplcat.ptdife') + "\n"
    apex_string += aplcat.byosm.to_s + "\t" + "! " + t('aplcat.byosm') + "\n"
		apex_string += "\n"
		apex_string += "Data on animalfeed (grasses, hay and concentrates)" + "\n"
		apex_string += "\n"
		apex_string += sprintf("%d", grazing.count)
		for i in 0..grazing.count-1
			apex_string += "\t"
		end
		apex_string += "| " + t('graze.total') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].code) + "\t"
		end
		apex_string += "| " + t('graze.code_for') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].starting_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.sjd') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].ending_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.ejd') + "\n"
		#for i in 0..grazing.count-1
			#apex_string += sprintf("%d", grazing[i].for_button) + "\t"
	#	end
		#apex_string += "| " + t('graze.dmi_code') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].for_dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
		for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].green_water_footprint) + "\t"
		end
		apex_string += "| " + t('graze.gwff') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_code) + "\t"
    end
    apex_string += "| " + t('graze.code_supp') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%.2f", grazing[i].dmi_rheifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for i in 0..grazing.count-1
			apex_string += sprintf("%d", grazing[i].green_water_footprint_supplement) + "\t"
		end
		apex_string += "| " + t('graze.gwfs') + "\n"
    apex_string += "\n"
		apex_string += "Data on animalfeed (Supplement/Concentrate)" + "\n"
		apex_string += "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].code) + "\t"
		end
		apex_string += "| " + t('supplement.code') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].starting_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.sjd') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].ending_julian_day) + "\t"
		end
		apex_string += "| " + t('graze.ejd') + "\n"
		#for j in 0..supplement.count-1
			#apex_string += sprintf("%d", supplement[j].for_button) + "\t"
		#end
	#	apex_string += "| " + t('graze.dmi_code') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].for_dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for j in 0..supplement.count-1
      apex_string += sprintf("%.2f", supplement[j].for_dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
		for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].green_water_footprint) + "\t"
		end
		apex_string += "| " + t('graze.gwff') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].dmi_code) + "\t"
		end
		apex_string += "| " + t('graze.code_supp') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_cows) + "\t"
		end
		apex_string += "| " + t('graze.dmi_cows') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_bulls) + "\t"
		end
		apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_heifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_calves) + "\t"
		end
		apex_string += "| " + t('graze.dmi_calves') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%.2f", supplement[j].dmi_rheifers) + "\t"
		end
		apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for j in 0..supplement.count-1
			apex_string += sprintf("%d", supplement[j].green_water_footprint_supplement) + "\t"
		end
		apex_string += "| " + t('graze.gwfs') + "\n"
		apex_string += "\n"
		apex_string += "IMPORTANT NOTE: Details of parameters defined in the above 11 lines:" + "\n"
		apex_string += "\n"
		apex_string += "Line 1: " + t('graze.total') + "\n"
		apex_string += "Line 2: " + t('graze.code_for') + "\n"
		apex_string += "Line 3: " + t('graze.sjd') + "\n"
		apex_string += "Line 4: " + t('graze.ejd') + "\n"
		apex_string += "Line 5: " + t('graze.ln5') + "\n"
		apex_string += "Line 6: " + t('graze.dmi_cows') + "\n"
		apex_string += "Line 7: " + t('graze.dmi_bulls') + "\n"
		apex_string += "Line 8: " + t('graze.dmi_heifers') + "\n"
		apex_string += "Line 9: " + t('graze.dmi_calves') + "\n"
    apex_string += "Line 10: " + t('graze.dmi_rheifers') + "\n"
    apex_string += "Line 11: " + t('graze.ln10') + "\n"
		apex_string += "\n"
		#***** send file to server "
		msg = send_file_to_APEX(apex_string, "EmissionInputCowCalf.txt")
		# create string for the DRINKIGWATER.txt file
		apex_string = "Input file for estimating drinking water requirement of cattle" + "\n"
		apex_string += "\n"
		apex_string += aplcat.noc.to_s + "\t" + "! " + t('aplcat.noc') + "\n"
		apex_string += aplcat.abwc.to_s + "\t" + "! " + t('aplcat.abwc') + "\n"
		apex_string += aplcat.norh.to_s + "\t" + "! " + t('aplcat.norh') + "\n"
		apex_string += aplcat.abwh.to_s + "\t" + "! " + t('aplcat.abwh') + "\n"
		apex_string += aplcat.nomb.to_s + "\t" + "! " + t('aplcat.nomb') + "\n"
		apex_string += aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.abwmb') + "\n"
		apex_string += aplcat.dwawfga.to_s + "\t" + "! " + t('aplcat.dwawfga') + "\n"
		apex_string += aplcat.dwawflc.to_s + "\t" + "! " + t('aplcat.dwawflc') + "\n"
		apex_string += aplcat.dwawfmb.to_s + "\t" + "! " + t('aplcat.dwawfmb') + "\n"
		# take monthly avg max and min temp and get an average of those two
		# take monthly rh to add to dringking water.
		#county = County.find(Location.find(session[:location_id]).county_id)
		county = County.find(@project.location.county_id)
	 if county != nil then
	    client = Savon.client(wsdl: URL_SoilsInfo)
	    response = client.call(:create_wp1_from_weather, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => county.wind_wp1_name, "pgm" => ApexControl.find_by_control_description_id(6).value.to_i.to_s})

      #response = client.call(:create_wp1_from_weather2, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => county.wind_wp1_name, "code" => county.county_state_code})
      #weather_data = response.body[:create_wp1_from_weather2_response][:create_wp1_from_weather2_result]


	    weather_data = response.body[:create_wp1_from_weather_response][:create_wp1_from_weather_result][:string]
		  max_temp = weather_data[2].split
		  min_temp = weather_data[3].split
		  rh = weather_data[14].split
		  for i in 0..max_temp.count-1
			min_temp[i] = sprintf("%5.1f",((max_temp[i].to_f + min_temp[i].to_f) / 2) * 9/5 + 32)
			rh[i] = 100 * (Math.exp((17.625 * rh[i].to_f) / (243.04 + rh[i].to_f)) / Math.exp((17.625 * min_temp[i].to_f) / (243.04 + min_temp[i].to_f)))
			apex_string += sprintf("%.1f", min_temp[i]) + "  "
		  end
		  apex_string += "\t" + "! " + t('aplcat.avg_temp') + "\n"
		  for i in 0..rh.count-1
			apex_string += sprintf("%.1f", rh[i]) + "  "
		  end
		  apex_string += "\t" + "! " + t('aplcat.avg_rh') + "\n"
		end
    apex_string += aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.adwgbc') + "\n"
		apex_string += aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.adwgbh') + "\n"
		apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
		apex_string += aplcat.prh.to_s + "\t" + "! " + t('aplcat.prh') + "\n"
		apex_string += aplcat.prb.to_s + "\t" + "! " + t('aplcat.prb') + "\n"
		apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.jdcc') + "\n"
		apex_string += aplcat.gpc.to_s + "\t" + "! " + t('aplcat.gpc') + "\n"
    apex_string += aplcat.tpwg.to_s + "\t" + "! " + t('aplcat.tpwg') + "\n"
    apex_string += aplcat.csefa.to_s + "\t" + "! " + t('aplcat.csefa') + "\n"
		apex_string += aplcat.srop.to_s + "\t" + "! " + t('aplcat.srop') + "\n"
		apex_string += aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.bwoc') + "\n"
		apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.jdbs') + "\n"
		apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
		apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
		apex_string += aplcat.rhaeba.to_s + "\t" + "! " + t('aplcat.rhaeba') + "\n"
		apex_string += aplcat.toaboba.to_s + "\t" + "! " + t('aplcat.toaboba') + "\n"
		apex_string += aplcat.dmi.to_s + "\t" + "! " + t('aplcat.dmi') + "\n"
		apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
		apex_string += aplcat.mpsm.to_s + "\t" + "! " + t('aplcat.mpsm') + "\n"
		apex_string += aplcat.splm.to_s + "\t" + "! " + t('aplcat.splm') + "\n"
		apex_string += aplcat.pmme.to_s + "\t" + "! " + t('aplcat.pmme') + "\n"
		apex_string += aplcat.napanr.to_s + "\t" + "! " + t('aplcat.napanr') + "\n"
		apex_string += aplcat.napaip.to_s + "\t" + "! " + t('aplcat.napaip') + "\n"
		apex_string += aplcat.pgu.to_s + "\t" + "! " + t('aplcat.pgu') + "\n"
		apex_string += aplcat.ada.to_s + "\t" + "! " + t('aplcat.ada') + "\n"
		apex_string += aplcat.ape.to_s + "\t" + "! " + t('aplcat.ape') + "\n"
    apex_string += aplcat.ape.to_s + "\t" + "! " + t('aplcat.ape') + "\n"
    apex_string += aplcat.drinkg.to_s + "\t" + "! " + t('aplcat.drinkg') + "\n"
    apex_string += aplcat.drinkl.to_s + "\t" + "! " + t('aplcat.drinkl') + "\n"
    apex_string += aplcat.drinkm.to_s + "\t" + "! " + t('aplcat.drinkm') + "\n"
    #apex_string += aplcat.avghm.to_s + "\t" + "! " + t('aplcat.avghm') + "\n"
    apex_string += "\n"
    apex_string = "Daily Average Temperature for each months" + "\n"
		apex_string += "\n"
    apex_string += aplcat.tjan.to_s + "\t" + "! " + t("January") + "\n"
    apex_string += aplcat.tfeb.to_s + "\t" + "! " + t("February") + "\n"
    apex_string += aplcat.tmar.to_s + "\t" + "! " + t("March") + "\n"
    apex_string += aplcat.tapr.to_s + "\t" + "! " + t("April") + "\n"
    apex_string += aplcat.tmay.to_s + "\t" + "! " + t("May") + "\n"
    apex_string += aplcat.tjun.to_s + "\t" + "! " + t("June") + "\n"
    apex_string += aplcat.tjul.to_s + "\t" + "! " + t("July") + "\n"
    apex_string += aplcat.taug.to_s + "\t" + "! " + t("August") + "\n"
    apex_string += aplcat.tsep.to_s + "\t" + "! " + t("September") + "\n"
    apex_string += aplcat.toct.to_s + "\t" + "! " + t("October") + "\n"
    apex_string += aplcat.tnov.to_s + "\t" + "! " + t("November") + "\n"
    apex_string += aplcat.tdec.to_s + "\t" + "! " + t("December") + "\n"
    apex_string += "\n"
    apex_string = "Daily Average Humidity for each months" + "\n"
		apex_string += "\n"
    apex_string += aplcat.hjan.to_s + "\t" + "! " + t("January") + "\n"
    apex_string += aplcat.hfeb.to_s + "\t" + "! " + t("February") + "\n"
    apex_string += aplcat.hmar.to_s + "\t" + "! " + t("March") + "\n"
    apex_string += aplcat.hapr.to_s + "\t" + "! " + t("April") + "\n"
    apex_string += aplcat.hmay.to_s + "\t" + "! " + t("May") + "\n"
    apex_string += aplcat.hjun.to_s + "\t" + "! " + t("June") + "\n"
    apex_string += aplcat.hjul.to_s + "\t" + "! " + t("July") + "\n"
    apex_string += aplcat.haug.to_s + "\t" + "! " + t("August") + "\n"
    apex_string += aplcat.hsep.to_s + "\t" + "! " + t("September") + "\n"
    apex_string += aplcat.hoct.to_s + "\t" + "! " + t("October") + "\n"
    apex_string += aplcat.hnov.to_s + "\t" + "! " + t("November") + "\n"
    apex_string += aplcat.hdec.to_s + "\t" + "! " + t("December") + "\n"
    apex_string += "\n"
    #apex_string += aplcat.avgtm.to_s + "\t" + "! " + t('aplcat.avgtm') + "\n"
    apex_string += aplcat.rhae.to_s + "\t" + "! " + t('aplcat.rhae') + "\n"
    apex_string += aplcat.tabo.to_s + "\t" + "! " + t('aplcat.tabo') + "\n"
    apex_string += aplcat.mpism.to_s + "\t" + "! " + t('aplcat.mpism') + "\n"
    apex_string += aplcat.spilm.to_s + "\t" + "! " + t('aplcat.spilm') + "\n"
    apex_string += aplcat.pom.to_s + "\t" + "! " + t('aplcat.pom') + "\n"
    #apex_string += sprintf("%.2f", aplcat.srinl) + "\t" + "! " + t('aplcat.srinl') + "\n"
    apex_string += aplcat.sriip.to_s + "\t" + "! " + t('aplcat.sriip') + "\n"
    apex_string += aplcat.pogu.to_s + "\t" + "! " + t('aplcat.pogu') + "\n"
    apex_string += aplcat.adoa.to_s + "\t" + "! " + t('aplcat.adoa') + "\n"
		msg = send_file_to_APEX(apex_string, "WaterEnergyInputCowCalf.txt")
    apex_string += "\n"
    apex_string = "Input file for estimating CO2 Balance Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.n_tfa.to_s + "\t" + "! " + t('aplcat.n_tfa') + "\n"
    apex_string += aplcat.n_sr.to_s + "\t" + "! " + t('aplcat.n_sr') + "\n"
    apex_string += aplcat.n_arnfa.to_s + "\t" + "! " + t('aplcat.n_arnfa') + "\n"
    apex_string += aplcat.n_arpfa.to_s + "\t" + "! " + t('aplcat.n_arpfa') + "\n"
    apex_string += aplcat.n_nfar.to_s + "\t" + "! " + t('aplcat.n_nfar') + "\n"
    apex_string += aplcat.n_npfar.to_s + "\t" + "! " + t('aplcat.n_npfar') + "\n"
    apex_string += aplcat.n_co2enfp.to_s + "\t" + "! " + t('aplcat.n_co2enfp') + "\n"
    apex_string += aplcat.n_co2enfa.to_s + "\t" + "! " + t('aplcat.n_co2enfa') + "\n"
    apex_string += aplcat.n_lamf.to_s + "\t" + "! " + t('aplcat.n_lamf') + "\n"
    apex_string += aplcat.n_lan2of.to_s + "\t" + "! " + t('aplcat.n_lan2of') + "\n"
    apex_string += aplcat.n_laco2f.to_s + "\t" + "! " + t('aplcat.n_laco2f') + "\n"
    apex_string += aplcat.n_socc.to_s + "\t" + "! " + t('aplcat.n_socc') + "\n"
    apex_string += aplcat.i_tfa.to_s + "\t" + "! " + t('aplcat.i_tfa') + "\n"
    apex_string += aplcat.i_sr.to_s + "\t" + "! " + t('aplcat.i_sr') + "\n"
    apex_string += aplcat.i_arnfa.to_s + "\t" + "! " + t('aplcat.i_arnfa') + "\n"
    apex_string += aplcat.i_arpfa.to_s + "\t" + "! " + t('aplcat.i_arpfa') + "\n"
    apex_string += aplcat.i_nfar.to_s + "\t" + "! " + t('aplcat.i_nfar') + "\n"
    apex_string += aplcat.i_npfar.to_s + "\t" + "! " + t('aplcat.i_npfar') + "\n"
    apex_string += aplcat.i_co2enfp.to_s + "\t" + "! " + t('aplcat.i_co2enfp') + "\n"
    apex_string += aplcat.i_co2enfa.to_s + "\t" + "! " + t('aplcat.i_co2enfa') + "\n"
    apex_string += aplcat.i_lamf.to_s + "\t" + "! " + t('aplcat.i_lamf') + "\n"
    apex_string += aplcat.i_lan2of.to_s + "\t" + "! " + t('aplcat.i_lan2of') + "\n"
    apex_string += aplcat.i_laco2f.to_s + "\t" + "! " + t('aplcat.i_laco2f') + "\n"
    apex_string += aplcat.i_socc.to_s + "\t" + "! " + t('aplcat.i_socc') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Forage Quantity Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.forage_id.to_s + "\t" + "! " + t('aplcat.forage_id') + "\n"
    apex_string += aplcat.jincrease.to_s + "\t" + "! " + t('aplcat.jincrease') + "\n"
    apex_string += aplcat.stabilization.to_s + "\t" + "! " + t('aplcat.stabilization') + "\n"
    apex_string += aplcat.decline.to_s + "\t" + "! " + t('aplcat.decline') + "\n"
    apex_string += aplcat.opt4.to_s + "\t" + "! " + t('aplcat.opt4') + "\n"
    apex_string += aplcat.cpl_lowest.to_s + "\t" + "! " + t('aplcat.cpl_lowest') + "\n"
    apex_string += aplcat.cpl_highest.to_s + "\t" + "! " + t('aplcat.cpl_highest') + "\n"
    apex_string += aplcat.tdn_lowest.to_s + "\t" + "! " + t('aplcat.tdn_lowest') + "\n"
    apex_string += aplcat.tdn_highest.to_s + "\t" + "! " + t('aplcat.tdn_highest') + "\n"
    apex_string += aplcat.ndf_lowest.to_s + "\t" + "! " + t('aplcat.ndf_lowest') + "\n"
    apex_string += aplcat.ndf_highest.to_s + "\t" + "! " + t('aplcat.ndf_highest') + "\n"
    apex_string += aplcat.adf_lowest.to_s + "\t" + "! " + t('aplcat.adf_lowest') + "\n"
    apex_string += aplcat.adf_highest.to_s + "\t" + "! " + t('aplcat.adf_highest') + "\n"
    apex_string += aplcat.fir_lowest.to_s + "\t" + "! " + t('aplcat.fir_lowest') + "\n"
    apex_string += aplcat.fir_highest.to_s + "\t" + "! " + t('aplcat.fir_highest') + "\n"
    apex_string += "\n"
    msg = send_file_to_APEX(apex_string, "Co2AndForageQuantityInputCowCalf.txt")
    apex_string = "Input file for estimating Secondary Emmission Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.theta.to_s + "\t" + "! " + t('aplcat.theta') + "\n"
    apex_string += aplcat.fge.to_s + "\t" + "! " + t('aplcat.fge') + "\n"
    apex_string += aplcat.fde.to_s + "\t" + "! " + t('aplcat.fde') + "\n"
    apex_string += aplcat.first_area.to_s + "\t" + "! " + t('aplcat.first_area') + "\n"
    apex_string += aplcat.first_fuel.to_s + "\t" + "! " + t('aplcat.first_fuel') + "\n"
    apex_string += aplcat.first_equip.to_s + "\t" + "! " + t('aplcat.first_equip') + "\n"
    apex_string += aplcat.second_area.to_s + "\t" + "! " + t('aplcat.second_area') + "\n"
    apex_string += aplcat.second_fuel.to_s + "\t" + "! " + t('aplcat.second_fuel') + "\n"
    apex_string += aplcat.second_equip.to_s + "\t" + "! " + t('aplcat.second_equip') + "\n"
    apex_string += aplcat.third_area.to_s + "\t" + "! " + t('aplcat.third_area') + "\n"
    apex_string += aplcat.third_fuel.to_s + "\t" + "! " + t('aplcat.third_fuel') + "\n"
    apex_string += aplcat.third_equip.to_s + "\t" + "! " + t('aplcat.third_equip') + "\n"
    apex_string += aplcat.fourth_area.to_s + "\t" + "! " + t('aplcat.fourth_area') + "\n"
    apex_string += aplcat.fourth_fuel.to_s + "\t" + "! " + t('aplcat.fourth_fuel') + "\n"
    apex_string += aplcat.fourth_equip.to_s + "\t" + "! " + t('aplcat.fourth_equip') + "\n"
    apex_string += aplcat.fifth_area.to_s + "\t" + "! " + t('aplcat.fifth_area') + "\n"
    apex_string += aplcat.fifth_fuel.to_s + "\t" + "! " + t('aplcat.fifth_fuel') + "\n"
    apex_string += aplcat.fifth_equip.to_s + "\t" + "! " + t('aplcat.fifth_equip') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Animal Transport Input" + "\n"
		apex_string += "\n"
    apex_string += aplcat.tripn.to_s + "\t" + "! " + t('aplcat.tripn') + "\n"
    apex_string += "\n"
    apex_string = "This is the First Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_1.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_1.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_1.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_1.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_1.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_1.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_1.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_1.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_1.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_1.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_1.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_1.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_1.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_1.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_1.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_1.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Second Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_2.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_2.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_2.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_2.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_2.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_2.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_2.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_2.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_2.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_2.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_2.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_2.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_2.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_2.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_2.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_2.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Third Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_3.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_3.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_3.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_3.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_3.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_3.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_3.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_3.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_3.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_3.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_3.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_3.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_3.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_3.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_3.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_3.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string = "This is the Fourth Trip of Animal Transport Input" + "\n"
    apex_string += "\n"
    apex_string += aplcat.trans_4.to_s + "\t" + "! " + t("Transportation") + "\n"
    apex_string += aplcat.categories_trans_4.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
    apex_string += aplcat.categories_slaug_4.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
    apex_string += aplcat.avg_marweight_4.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.num_animal_4.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.second_avg_marweight_4.to_s + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
    apex_string += aplcat.second_num_animal_4.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
    apex_string += aplcat.mortality_rate_4.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
    apex_string += aplcat.distance_4.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
    apex_string += aplcat.trailer_4.to_s + "\t" + "! " + t('aplcat.trailer') + "\n"
    apex_string += aplcat.trucks_4.to_s + "\t" + "! " + t('aplcat.trucks') + "\n"
    apex_string += aplcat.fuel_type_4.to_s + "\t" + "! " + t('aplcat.fuel_type') + "\n"
    apex_string += aplcat.same_vehicle_4.to_s + "\t" + "! " + t('aplcat.same_vehicle') + "\n"
    apex_string += aplcat.loading_4.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
    apex_string += aplcat.carcass_4.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
    apex_string += aplcat.boneless_beef_4.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
    apex_string += "\n"
    apex_string += aplcat.freqtrip.to_s + "\t" + "! " + t('aplcat.freqtrip') + "\n"
    apex_string += aplcat.filedetails.to_s + "\t" + "! " + t('aplcat.filedetails') + "\n"
    apex_string += aplcat.cattlepro.to_s + "\t" + "! " + t('aplcat.cattlepro') + "\n"
    apex_string += aplcat.purpose.to_s + "\t" + "! " + t('aplcat.purpose') + "\n"
    apex_string += aplcat.codepurpose.to_s + "\t" + "! " + t('aplcat.codepurpose') + "\n"
    apex_string += "\n"
    apex_string = "Input file for estimating Simulation Methods" + "\n"
		apex_string += "\n"
    apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
    apex_string += aplcat.fmbmm.to_s + "\t" + "! " + t('aplcat.fmbmm') + "\n"
    #apex_string += aplcat.nit.to_s + "\t" + "! " + t('aplcat.nit') + "\n"
    #apex_string += aplcat.fqd.to_s + "\t" + "! " + t('aplcat.fqd') + "\n"
    #apex_string += aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.uovfi') + "\n"
    #apex_string += aplcat.srwc.to_s + "\t" + "! " + t('aplcat.srwc') + "\n"
    apex_string += "\n"
    msg = send_file_to_APEX(apex_string, "EmmisionTransportAndSimulationCowCalf.txt")

    #input file for APLCAT Results
      apex_string += "Calf" + "\t" + "Repl_hef" + "\t" + "FC_hef" + "\t" + "Cow" + "\t" + "Bull" + "|" + "Calf" + "\t" + "Repl_hef" + "\t" + "FC_hef" + "\t" + "Cow" + "\t" + "Bull" + "\t" + "Results per animal" + "\n"
      apex_string = "\n"
      apex_string = "Animal growth Resuls" + "\n"
      apex_string += aplcatresult.calf_aws.to_s + "\t" + aplcatresult.rh_aws.to_s + "\t" + aplcatresult.fch_aws.to_s + "\t" + aplcatresult.cow_aws.to_s + "\t" + aplcatresult.bull_aws.to_s + "|" + aplcatresult.calf_aws.to_s + "\t" + aplcatresult.rh_aws.to_s + "\t" + aplcatresult.fch_aws.to_s + "\t" + aplcatresult.cow_aws.to_s + "\t" + aplcatresult.bull_aws.to_s + "\t" + "Animal weights (lb | kg)" + "\n"
      apex_string = "\n"
      apex_string = "Feed Intake Rates" + "\n"
      apex_string += aplcatresult.calf_dmi.to_s + "\t" + aplcatresult.rh_dmi.to_s + "\t" + aplcatresult.fch_dmi.to_s + "\t" + aplcatresult.cow_dmi.to_s + "\t" + aplcatresult.bull_dmi.to_s + "|" + aplcatresult.calf_dmi.to_s + "\t" + aplcatresult.rh_dmi.to_s + "\t" + aplcatresult.fch_dmi.to_s + "\t" + aplcatresult.cow_dmi.to_s + "\t" + aplcatresult.bull_dmi.to_s + "\t" + "Dry Matter Intake ('kg',daily | annual)" + "\n"
      apex_string += aplcatresult.calf_gei.to_s + "\t" + aplcatresult.rh_gei.to_s + "\t" + aplcatresult.fch_gei.to_s + "\t" + aplcatresult.cow_gei.to_s + "\t" + aplcatresult.bull_gei.to_s + "|" + aplcatresult.calf_gei.to_s + "\t" + aplcatresult.rh_gei.to_s + "\t" + aplcatresult.fch_gei.to_s + "\t" + aplcatresult.cow_gei.to_s + "\t" + aplcatresult.bull_gei.to_s + "\t" + "Gross Energy Intake ('daily',Mcal | MJ)" + "\n"
      apex_string = "\n"
      apex_string = "Water Intake Results" + "\n"
      apex_string += aplcatresult.calf_wi.to_s + "\t" + aplcatresult.rh_wi.to_s + "\t" + aplcatresult.fch_wi.to_s + "\t" + aplcatresult.cow_wi.to_s + "\t" + aplcatresult.bull_wi.to_s + "|" + aplcatresult.calf_wi.to_s + "\t" + aplcatresult.rh_wi.to_s + "\t" + aplcatresult.fch_wi.to_s + "\t" + aplcatresult.cow_wi.to_s + "\t" + aplcatresult.bull_wi.to_s + "\t" + "Water Intake ('L/year',Emb_feed | drinking)" + "\n"
      apex_string = "\n"
      apex_string = "Manure Excretion Results" + "\n"
      apex_string += aplcatresult.calf_sme.to_s + "\t" + aplcatresult.rh_sme.to_s + "\t" + aplcatresult.fch_sme.to_s + "\t" + aplcatresult.cow_sme.to_s + "\t" + aplcatresult.bull_sme.to_s + "|" + aplcatresult.calf_sme.to_s + "\t" + aplcatresult.rh_sme.to_s + "\t" + aplcatresult.fch_sme.to_s + "\t" + aplcatresult.cow_sme.to_s + "\t" + aplcatresult.bull_sme.to_s + "\t" + "Solid manure excr. ('kg/year',manu | manu_N)" + "\n"
      apex_string = "\n"
      apex_string = "Nitrogen Balance Results" + "\n"
      apex_string += aplcatresult.calf_ni.to_s + "\t" + aplcatresult.rh_ni.to_s + "\t" + aplcatresult.fch_ni.to_s + "\t" + aplcatresult.cow_ni.to_s + "\t" + aplcatresult.bull_ni.to_s + "|" + aplcatresult.calf_ni.to_s + "\t" + aplcatresult.rh_ni.to_s + "\t" + aplcatresult.fch_ni.to_s + "\t" + aplcatresult.cow_ni.to_s + "\t" + aplcatresult.bull_ni.to_s + "\t" + "Nitrogen Intake (g/day | kg/year)" + "\n"
      apex_string += aplcatresult.calf_tne.to_s + "\t" + aplcatresult.rh_tne.to_s + "\t" + aplcatresult.fch_tne.to_s + "\t" + aplcatresult.cow_tne.to_s + "\t" + aplcatresult.bull_tne.to_s + "|" + aplcatresult.calf_tne.to_s + "\t" + aplcatresult.rh_tne.to_s + "\t" + aplcatresult.fch_tne.to_s + "\t" + aplcatresult.cow_tne.to_s + "\t" + aplcatresult.bull_tne.to_s + "\t" + "Total Nitrogen excretion (g/day | kg/year)" + "\n"
      apex_string += aplcatresult.calf_tnr.to_s + "\t" + aplcatresult.rh_tnr.to_s + "\t" + aplcatresult.fch_tnr.to_s + "\t" + aplcatresult.cow_tnr.to_s + "\t" + aplcatresult.bull_tnr.to_s + "|" + aplcatresult.calf_tnr.to_s + "\t" + aplcatresult.rh_tnr.to_s + "\t" + aplcatresult.fch_tnr.to_s + "\t" + aplcatresult.cow_tnr.to_s + "\t" + aplcatresult.bull_tnr.to_s + "\t" + "Total Nitrogen retained (g/day | kg/year)" + "\n"
      apex_string += aplcatresult.calf_fne.to_s + "\t" + aplcatresult.rh_fne.to_s + "\t" + aplcatresult.fch_fne.to_s + "\t" + aplcatresult.cow_fne.to_s + "\t" + aplcatresult.bull_fne.to_s + "|" + aplcatresult.calf_fne.to_s + "\t" + aplcatresult.rh_fne.to_s + "\t" + aplcatresult.fch_fne.to_s + "\t" + aplcatresult.cow_fne.to_s + "\t" + aplcatresult.bull_fne.to_s + "\t" + "Fecal Nitrogen excretion (g/day | kg/year)" + "\n"
      apex_string += aplcatresult.calf_une.to_s + "\t" + aplcatresult.rh_une.to_s + "\t" + aplcatresult.fch_une.to_s + "\t" + aplcatresult.cow_une.to_s + "\t" + aplcatresult.bull_une.to_s + "|" + aplcatresult.calf_une.to_s + "\t" + aplcatresult.rh_une.to_s + "\t" + aplcatresult.fch_une.to_s + "\t" + aplcatresult.cow_une.to_s + "\t" + aplcatresult.bull_une.to_s + "\t" + "Urine Nitrogen excretion (g/day | kg/year)" + "\n"
      apex_string = "\n"
      apex_string = "Greenhouse Gas Emission" + "\n"
      apex_string += aplcatresult.calf_eme.to_s + "\t" + aplcatresult.rh_eme.to_s + "\t" + aplcatresult.fch_eme.to_s + "\t" + aplcatresult.cow_eme.to_s + "\t" + aplcatresult.bull_eme.to_s + "|" + aplcatresult.calf_eme.to_s + "\t" + aplcatresult.rh_eme.to_s + "\t" + aplcatresult.fch_eme.to_s + "\t" + aplcatresult.cow_eme.to_s + "\t" + aplcatresult.bull_eme.to_s + "\t" + "AEnteric methane emission ('daily', g | Mcal)" + "\n"
      apex_string += aplcatresult.calf_mme.to_s + "\t" + aplcatresult.rh_mme.to_s + "\t" + aplcatresult.fch_mme.to_s + "\t" + aplcatresult.cow_mme.to_s + "\t" + aplcatresult.bull_mme.to_s + "|" + aplcatresult.calf_mme.to_s + "\t" + aplcatresult.rh_mme.to_s + "\t" + aplcatresult.fch_mme.to_s + "\t" + aplcatresult.cow_mme.to_s + "\t" + aplcatresult.bull_mme.to_s + "\t" + "Manure methane emission (g/day | kg/year)" + "\n"
      apex_string = "\n"
      msg = send_file_to_APEX(apex_string, "AplcatResults.txt")
	    if msg.eql?("OK") then msg = send_file_to_APEX("RUNAPLCAT", session[:session_id]) else return msg  end  #this operation will run a simulation and return ntt file.
	    if msg.include?("Bull output file") then msg="OK" end
		return msg
  	end

  ################################  copy scenario selected  #################################
  def copy_scenario
	@use_old_soil = false
	msg = duplicate_scenario(params[:id], " copy", params[:field_id])
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    @scenarios = Scenario.where(:field_id => @field.id)
    add_breadcrumb 'Scenarios'
	render "index"
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
  			add_soil_operation(new_op)
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

  def download
    download_apex_files()
  end

  def download_aplcat
    download_aplcat_files()
  end

  def download_fem
    download_fem_files()
  end

  private
# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def scenario_params
    params.require(:scenario).permit(:name, :field_id, :scenario_select)
  end

end  #end class
