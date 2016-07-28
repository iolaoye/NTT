class ScenariosController < ApplicationController
  include ScenariosHelper	
  include SimulationsHelper
################################  list of bmps #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_bmps

    session[:scenario_id] = params[:id]
    redirect_to list_bmp_path(params[:id])	
  end
################################  list of operations   #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_operations
    session[:scenario_id] = params[:id]
    redirect_to list_operation_path(params[:id])	
  end
################################  scenarios list  #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def list  
    @scenarios = Scenario.where(:field_id => params[:id])
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(params[:id]).field_name
	respond_to do |format|
		format.html # list.html.erb
		format.json { render json: @scenarios }
	end
  end
################################  index  #################################
  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.where(:field_id => session[:field_id])
    render "list"
  end

################################  NEW   #################################
  # GET /scenarios/new
  # GET /scenarios/new.json
  def new
     @scenario = Scenario.new
	 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scenario }
    end
  end

################################  EDIT   #################################
  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

################################  CREATE  #################################
  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
	@scenario.field_id = session[:field_id]
	respond_to do |format|
      if @scenario.save
		@scenarios = Scenario.where(:field_id => session[:field_id])
		#add new scenario to soils
        flash[:notice] = t('scenario.scenario') + " " + @scenario.name + " " + t('general.success')
		add_scenario_to_soils(@scenario)
		format.html { render action: "list" }
      else
        format.html { render action: "new" }
        format.json { render json: scenario.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      if @scenario.update_attributes(scenario_params)
        format.html { redirect_to list_scenario_path(session[:field_id]), notice: "Scenario was successfully updated." }
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
	Subarea.where(:scenario_id => @scenario.id).delete_all
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to scenarios_url }
      format.json { head :no_content }
    end
  end

################################  SHOW - simulate the selected scenario  #################################
  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
	session[:scenario_id] = params[:id]	
    #@doc = "Nothing"
    @scenario = Scenario.find(params[:id])
	dir_name = APEX + "/APEX" + session[:session_id]
	#dir_name2 = "#{Rails.root}/data/#{session[:session_id]}"
	#if !File.exists?(dir_name)
	#	FileUtils.mkdir_p(dir_name)
	#end
	#FileUtils.cp_r(Dir[APEX_ORIGINAL + '/*'], Dir[dir_name])
	msg = send_file_to_APEX("APEX", session[:session_id])  #this operation will create APEX folder from APEX1 folder
	#CREATE structure for nutrients that go with fert file
	@nutrients_structure = Struct.new(:code, :no3, :po4, :orgn, :orgp)
	@current_nutrients = Array.new
	@new_fert_line = Array.new
	@change_fert_for_grazing_line = Array.new
	@fem_list = Array.new
	@dtNow1  = Time.now.to_s
	@opcs_list_file = Array.new
	@depth_ant = Array.new
	@opers = Array.new
	@change_till_depth = Array.new
	@last_soil_sub = 0
	@last_subarea = 0
	if msg = "OK" then msg = create_control_file() end
	if msg = "OK" then msg = create_parameter_file() end
	if msg = "OK" then msg = create_site_file(@scenario.field_id) end
	if msg = "OK" then msg = create_weather_file(dir_name, @scenario.field_id) end
	if msg = "OK" then msg = create_wind_wp1_files(dir_name) end
	@last_soil = 0
	@soils = Soil.where(:field_id => @scenario.field_id).where(:selected => true)
	@soil_list = Array.new
	if msg = "OK" then msg = create_soils() end
	if msg = "OK" then msg = send_file_to_APEX(@soil_list, "soil.dat") end
	#print_array_to_file(@soil_list, "soil.dat")
	@subarea_file = Array.new
	@soil_number = 0
	if msg = "OK" then msg = create_subareas(1) end
	if msg = "OK" then msg = send_file_to_APEX(@opcs_list_file, "opcs.dat") end
	#print_array_to_file(@opcs_list_file, "OPCS.dat")	
	if msg = "OK" then msg = send_file_to_APEX("RUN", session[:session]) end  #this operation will run a simulation
	read_apex_results(msg)
	@scenarios = Scenario.where(:field_id => session[:field_id])
	render "list"
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def scenario_params
      params.require(:scenario).permit(:name, :field_id)
    end

    def update_hash(climate, climate_array)
        hash = Hash.new
        hash["max"] = climate.max_temp
        hash["min"] = climate.min_temp
        hash["pcp"] = climate.precipitation
        climate_array.push(hash)
        return climate_array
    end

	def read_file(file)
		return File.read(File.join(APEX, "APEX" + session[:session_id], file))
	end

	def read_apex_results(msg)
        ntt_apex_results = Array.new
		#todo check this with new projects. Check if the simulatin_initial_year has the 5 years controled.
        start_year = Weather.find_by_field_id(Scenario.find(params[:id]).field_id).simulation_initial_year - 5

        apex_start_year = start_year + 1
        #take results from .NTT file for all but crops
        msg = load_results(apex_start_year, msg)
        
		msg = load_crop_results(apex_start_year)
    end

	def load_crop_results(apex_start_year)
		msg = "OK"
		crops_data = Array.new
		oneCrop = Struct.new(:sub1,:name,:year,:yield,:ws,:ts,:ns,:ps,:as1)
		data = send_file_to_APEX("ACY", session[:session_id])  #this operation will ask for ACY file
		#todo validate that the file was uploaded correctly
		#data = read_file("APEX001.acy")   #Anual values for crop yield
		j = 1
        data.each_line do |tempa|
			if j >= 10 then				
				year1 = tempa[18, 4].to_i
				subs = tempa[5, 5].to_i
				next if year1 < apex_start_year #take years greater or equal than ApexStartYear.
				one_crop = oneCrop.new
				one_crop.sub1 = subs
				one_crop.year = year1
				one_crop.name = tempa[28,4]
				one_crop.yield = tempa[33,9].to_f
				one_crop.yield += tempa[43,9].to_f unless (one_crop.name == "COTS" || one_crop.name == "COTP")
				one_crop.ws = tempa[63,9].to_f 
				one_crop.ns = tempa[73,9].to_f
				one_crop.ps = tempa[83,9].to_f
				one_crop.ts = tempa[93,9].to_f
				one_crop.as1 = tempa[103,9].to_f

				crops_data.push(one_crop)
			end # end if j>=10
			j+=1
		end #end data.each
		crops_data_by_crop_year = crops_data.group_by { |s| [s.name, s.year] } .map { |k,v| [k, v.map(&:yield).mean]}
		average_crops_result(crops_data_by_crop_year)
    end  #end method

	def average_crops_result(items)		
		yield_by_name = Array.new
		description_id = 70
		items.each do |item|
			found = false
			yield_by_name.each do |array|
				if array["name"] == item[0][0] then
					found = true
					array["yield"] += item[1]
					array["total"] += 1
					add_value_to_chart_table(item[1] * array["conversion"], description_id, 0, item[0][1])
					break
				end # end if same crop
			end  # end each name
			if found == false then
				description_id += 1				
				yield_by_name.push(create_hash_by_name(item, description_id))
			end  # end if found
			#first = false
		end

		yield_by_name.each do |crop|
			crop_ci = Chart.select("value, month_year").where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => 0, :description_id => crop["description_id"])
			ci = Array.new
			crop_ci.each do |c|
				ci.push c.value
			end 
			crop["yield"] = (crop["yield"] * crop["conversion"]) / crop["total"]
			add_summary(crop["yield"], crop["description_id"], 0, ci.confidence_interval, crop["crop_id"])
		end
		add_summary(0, 70,0,0,0)
	end

	def create_hash_by_name(item, crop_count)
        conversion_factor = 1 * AC_TO_HA
        dry_matter = 100
		#find the crop to take conversion_factor and dry_matter
		crop = Crop.find_by_code(item[0][0])
		if crop != nil then
			conversion_factor = crop.conversion_factor * AC_TO_HA
			dry_matter = crop.dry_matter
		end #end if crop != nil
		new_hash = Hash.new
		new_hash["name"] = item[0][0]
		new_hash["yield"] = item[1]
		new_hash["conversion"] = conversion_factor / (dry_matter/100)
		new_hash["total"] = 1
		new_hash["description_id"] = crop_count
		new_hash["crop_id"] = crop.id
		return new_hash
	end

	def fixed_array(size, other)
		Array.new(size) { |i| other[i] }
	end

	def load_monthly_values(apex_start_year)
		data = send_file_to_APEX("MSW", session[:session_id])  #this operation will ask for MSW file  
		#todo validate that the file was uploaded correctly
		#data = read_file("APEX001.msw")   #annual values for sediment, flow, and nutrients

        annual_flow = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_sediment = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_orgn = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_orgp = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_no3 = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_po4 = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_precipitation = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
        annual_crop_yield = fixed_array(12, [0,0,0,0,0,0,0,0,0,0,0,0])
		last_year = 0
        #read titles 10 lines
        #calculate monthly averages starting after first rotation.
		j=1
		data.each_line do |tempa|
			if j >= 11 then
				year = tempa[1, 4].to_i
				if year > 0 && year >= apex_start_year then
					#accumulate the monthly values of simulation for graphs.
					i = tempa[6, 4].to_i
					annual_flow[i-1] += tempa[12, 10].to_f * MM_TO_IN
					annual_sediment[i-1] += tempa[23, 10].to_f * THA_TO_TAC
					annual_orgn[i-1] += tempa[34, 10].to_f * 10 * KG_TO_LBS / HA_TO_AC  #this values is multiply by 10 because the MSW file does this total divided by 10 comparing withthe value in the output file.
					annual_orgp[i-1] += tempa[45, 10].to_f * 20 * KG_TO_LBS / HA_TO_AC  #this values is multiply by 20 because the MSW file does this total divided by 20 comparing withthe value in the output file.
					annual_no3[i-1] += tempa[56, 10].to_f * KG_TO_LBS / HA_TO_AC
					annual_po4[i-1] += tempa[67, 10].to_f * KG_TO_LBS / HA_TO_AC
					last_year = year
				end # end if not end of data
			end #end if 
			j+=1
		end # end data.each

        last_year -= apex_start_year + 1

		data = send_file_to_APEX("MWS", session[:session_id])  #this operation will ask for MWS file  
		#todo validate that the file was uploaded correctly
		#data = read_file("APEX001.mws")   #monthly values for precipitation
		i=1
		data.each_line do |tempa|
			if i > 9 then
				if not tempa.nil? and tempa.strip.empty? then
					break
				else
					month = 1
					current_column = 5
					output = tempa.strip.split /\s+/
					if output[0].is_a? Numeric then
						year = output[0].to_i
						if year > 0 && year >= apex_start_year then
							for i in 0..annual_precipitation.size - 1
								annual_precipitation[i] += output[i+1].to_f								 
							end 
						end  # end if year ok
						
					end  # end if valid year
				end  # end if tempa nil or empty
			end #end if i>9
			i += 1
		end # end data.each file apex001.mws

		for i in 0..11
            annual_flow[i] /= last_year
			add_value_to_chart_table(annual_flow[i], 41, 0, i+1)
            annual_sediment[i] /= last_year
			add_value_to_chart_table(annual_sediment[i], 61, 0, i+1)
            annual_orgn[i] /= last_year
			add_value_to_chart_table(annual_orgn[i], 21, 0, i+1)
            annual_orgp[i] /= last_year
			add_value_to_chart_table(annual_orgp[i], 31, 0, i+1)
            annual_no3[i] /= last_year
			add_value_to_chart_table(annual_no3[i], 22, 0, i+1)
            annual_po4[i] /= last_year
			add_value_to_chart_table(annual_po4[i], 32, 0, i+1)
            annual_precipitation[i] /= last_year
			add_value_to_chart_table(annual_precipitation[i], 100, 0, i+1)
        end  # end for
    end
	
	def load_results(apex_start_year, data)
		msg = "OK"
		results_data = Array.new
        oneResult = Struct.new(:sub1,:year,:flow,:qdr,:surface_flow,:sed,:ymnu,:orgp,:po4,:orgn,:no3,:qdrn,:qdrp,:qn,:dprk,:irri,:pcp)
		sub_ant = 99
        irri_sum = 0
        dprk_sum = 0
		pcp = 0
        total_subs = 0
		#data = read_file("APEX001.ntt")
		i=1
		apex_control = ApexControl.where(:project_id => session[:project_id])
		initial_chart_year = apex_control[0].value - 12 + apex_control[1].value
        data.each_line do |tempa|
			if i > 3 then
				year = tempa[7, 4].to_i
				subs = tempa[0, 5].to_i

				next if year < apex_start_year #take years greater or equal than ApexStartYear.
				next if subs == sub_ant   #if subs and subant equal means there are more than one CROP. So info is going to be duplicated. Just one record saved
				sub_ant = subs
				one_result = oneResult.new
				one_result.sub1 = subs
				one_result.year = year
				one_result.flow = tempa[31, 9].to_f * MM_TO_IN
				one_result.qdr = tempa[126, 9].to_f * MM_TO_IN
				one_result.surface_flow = tempa[254, 9].to_f * MM_TO_IN
				one_result.sed = tempa[40, 9].to_f * THA_TO_TAC
				one_result.ymnu = tempa[180, 9].to_f * THA_TO_TAC
				one_result.orgp = tempa[58, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.po4 = tempa[76, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.orgn = tempa[49, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.no3 = tempa[67, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.qdrn = tempa[144, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.qdrp = tempa[263, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.qn = tempa[245, 9].to_f * (KG_TO_LBS / HA_TO_AC)
				one_result.dprk = tempa[135, 9].to_f * MM_TO_IN
				one_result.irri = tempa[237, 8].to_f * MM_TO_IN
				one_result.pcp = tempa[229, 8].to_f * MM_TO_IN
				if subs == 0 then
					one_result.dprk = dprk_sum / total_subs
					one_result.irri = irri_sum / total_subs
					one_result.pcp = pcp / total_subs
					irri_sum = 0
					dprk_sum = 0
					pcp = 0
					total_subs = 0
					if initial_chart_year <= year then
						add_value_to_chart_table(one_result.orgn, 21, 0, year)
						add_value_to_chart_table(one_result.qn, 22, 0, year)
						add_value_to_chart_table(one_result.no3, 23, 0, year)
						add_value_to_chart_table(one_result.qdrn, 24, 0, year)
						add_value_to_chart_table(one_result.qn+one_result.qdrn+one_result.no3+one_result.orgn, 20, 0, year)
						add_value_to_chart_table(one_result.orgp, 31, 0, year)
						add_value_to_chart_table(one_result.po4, 32, 0, year)
						add_value_to_chart_table(one_result.qdrp, 33, 0, year)
						add_value_to_chart_table(one_result.po4+one_result.qdrp+one_result.orgp, 30, 0, year)
						add_value_to_chart_table(one_result.surface_flow, 41, 0, year)
						add_value_to_chart_table(one_result.flow - one_result.surface_flow, 42, 0, year)
						add_value_to_chart_table(one_result.qdr, 33, 0, year)
						add_value_to_chart_table(one_result.flow  + one_result.qdr, 40, 0, year)
						add_value_to_chart_table(one_result.irri, 51, 0, year)
						add_value_to_chart_table(one_result.dprk, 52, 0, year)
						add_value_to_chart_table(one_result.irri + one_result.dprk, 50, 0, year)
						add_value_to_chart_table(one_result.sed, 61, 0, year)
						add_value_to_chart_table(one_result.ymnu, 62, 0, year)
						add_value_to_chart_table(one_result.sed + one_result.ymnu, 60, 0, year)
						add_value_to_chart_table(one_result.pcp, 100, 0, year)
					end 
				else
					irri_sum += one_result.irri
					dprk_sum += one_result.dprk
					pcp += one_result.pcp
					total_subs += 1
				end

				results_data.push(one_result)
			else
				i+=1
			end
        end
		msg = average_totals(results_data, 0)   # average totals
		load_monthly_values(apex_start_year)
		return msg

		update_results_table
	end

	def update_results_table
		bmp = Bmp.where(:scenario_id => session[:scenario_id], :bmpsublist_id => 10)
	
		total_manure = bmp.number_of_animals * bmp.hours / 24 * bmp.dry_manure
		no3 = total_manure * bmp.days * bmp.no3_n
		po4 = total_manure * bmp.days * bmp.po4_p
		org_n = total_manure * bmp.days * bmp.org_n
		org_p = total_manure * bmp.days * bmp.org_p

		soils = Soil.where(:field_id => session[:field_id], :soil_selected => true)
		soils.each do |soil|
			results = Result.where(:field_id => session[:field_id], :scenario_id => session[:scenario_id])
			results.each do |result|
				update_value_of_results(result, false)
			end
		end
		results = Result.where(:soil_id => 0, :field_id => session[:field_id], :scenario_id => session[:scenario_id])
        results.each do |result|
            update_value_of_results(result, true)
        end
	end

	def update_value_of_results(result, is_total)
		if is_total
			percentage = 1
		else
			percentage = soil.percentage / 100
		end
		case result.description_id
			when 20
				result.value += no3 * percentage + org_n * percentage
			when 21
				result.value += org_n * percentage
			when 22
				result.value += no3 * percentage
			when 30
				result.value += po4 * percentage + org_p * percentage
			when 31
				result.value += org_p * percentage
			when 32
				result.value += po4 * percentage
		end
	end

	def add_value_to_chart_table(value, description_id, soil_id, year)
		chart = Chart.where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => soil_id, :description_id => description_id, :month_year => year ).first
        if chart == nil then
			chart = Chart.new
			chart.month_year = year
			chart.field_id = @scenario.field_id
			chart.soil_id = soil_id
			chart.watershed_id = 0
			chart.scenario_id = @scenario.id
			chart.description_id = description_id
		end
		if value == nil then
			ooo
		end
		chart.value = value
		chart.save
	end

	def average_totals(results_data, i)
	    #0:sub1,1:year,2:flow,3:qdr,4:surface_flow,5:sed,6:ymnu,7:orgp,8:po4,9:orgn,10:no3,11:qdrn,12:qdrp,13:qn,14:dprk,15:irri,16:pcp)
		#Results description_ids
		require 'enumerable/confidence_interval'
		#calculate average and confidence interval
		orgn = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:orgn).mean]}
		orgn_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:orgn).confidence_interval]}
		add_summary_to_results_table(orgn, 21, orgn_ci)
		runoff_n = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qn).mean]}
		runoff_n_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qn).confidence_interval]}
		add_summary_to_results_table(runoff_n,  22, runoff_n_ci)
		sub_surface_n = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:no3).mean - v.map(&:qn).mean]}
		sub_surface_n_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:no3).confidence_interval - v.map(&:qn).confidence_interval]}		
		add_summary_to_results_table(sub_surface_n, 23, sub_surface_n_ci)
		tile_drain_n = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdrn).mean]}
		tile_drain_n_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdrn).confidence_interval]}
		add_summary_to_results_table(tile_drain_n, 24, tile_drain_n_ci)
		orgp = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:orgp).mean]}
		orgp_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:orgp).confidence_interval]}
		add_summary_to_results_table(orgp, 31, orgp_ci)
		po4 = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:po4).mean]}
		po4_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:po4).confidence_interval]}
		add_summary_to_results_table(po4, 32, po4_ci)
		tile_drain_p = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdrp).mean]}
		tile_drain_p_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdrp).confidence_interval]}
		add_summary_to_results_table(tile_drain_p, 33, tile_drain_p_ci)
		runoff = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:surface_flow).mean]}
		runoff_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:surface_flow).confidence_interval]}
		add_summary_to_results_table(runoff, 41, runoff_ci)
		sub_surface_flow= results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:flow).mean - v.map(&:surface_flow).mean]}
		sub_surface_flow_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:flow).confidence_interval - v.map(&:surface_flow).confidence_interval]}
		#sub_surface_flow = flow - runoff
		#sub_surface_flow_ci = flow_ci - runoff_ci
		add_summary_to_results_table(sub_surface_flow, 42, sub_surface_flow_ci)
		tile_drain_flow = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdr).mean]}
		tile_drain_flow_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:qdr).confidence_interval]}
		add_summary_to_results_table(tile_drain_flow, 43, tile_drain_flow_ci)
		irrigation = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:irri).mean]}
		irrigation_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:irri).confidence_interval]}
		add_summary_to_results_table(irrigation, 51, irrigation_ci)
		deep_percolation_flow = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:dprk).mean]}
		deep_percolation_flow_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:dprk).confidence_interval]}
		add_summary_to_results_table(deep_percolation_flow, 52, deep_percolation_flow_ci)
		sediment = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:sed).mean]}
		sediment_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:sed).confidence_interval]}
		add_summary_to_results_table(sediment, 61, sediment_ci)		
		manure_erosion = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:ymnu).mean]}
		manure_erosion_ci = results_data.group_by(&:sub1).map { |k,v| [k, v.map(&:ymnu).confidence_interval]}
		add_summary_to_results_table(manure_erosion, 62, manure_erosion_ci)
		return "OK"
	end

	def add_summary(value, description_id, soil_id, ci, crop_id)
		result = Result.where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => soil_id, :description_id => description_id).first
        if result == nil then
			result = Result.new
			result.field_id = @scenario.field_id
			result.scenario_id = @scenario.id
			result.soil_id = soil_id
			result.description_id = description_id
			result.crop_id = crop_id
		end

		result.watershed_id = 0
		result.value = value
		result.ci_value = ci
    	result.crop_id = crop_id
		if result.save then 
			return "OK"
		else
			return "Results couldn't be saved"
		end
	end

	def add_summary_to_results_table(values, description_id, cis)
		#total Area =10, main area= 11, additional area 12..19
		#total N = 20, orgn=21, runoffn=22, subsurface n=23, tile drain n = 24
		#total p = 30, orgp=31, po4_p=32, tile drain p = 33
		#total Flow = 40, surface runoff = 41, subsurface runoff = 42, tile drain flow = 43
		#other water info = 50, irrigation = 51, deep percolation = 52
		#total sediment = 60, sediment = 61, manure erosion = 62		
		
		for i in 0..values.count-1
			values[i][0] == 0  ? soil_id = 0 : soil_id = @soils[values[i][0]-1].id
			add_summary(values[i][1], description_id, soil_id, cis[i][1], 0)
			case description_id    #Total area for summary report is beeing calculated
				when 4  #calculate total area
					#todo	
				when 24  #calculate total N		
					add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 20"), 20, soil_id)
				when 33  #calculate total P
					add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 30"), 30, soil_id)
				when 43 #calculate total flow
					add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 40"), 40, soil_id)
				when 52 #calculate total other water info
					add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 50"), 50, soil_id)
				when 62 #calculate total sediment
					add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 60"), 60, soil_id)
			end #end case when
		end #end for i
		return "OK"
	end
	
	def add_totals(results, description_id, soil_id)					
		msg = add_summary(results.sum(:value), description_id, soil_id, results.sum(:ci_value), 0)		
	end
end  #end class
