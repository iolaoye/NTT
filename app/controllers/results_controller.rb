class ResultsController < ApplicationController
  include OperationsHelper
  ###############################  MONTHLY CHART  ###################################
  def monthly_charts
  	@type = t("general.view") + " " + t('result.monthly') + "-" + t('result.charts')
  	index
  	#render "index"
  end
  ###############################  ANNUAL CHART  ###################################
  def annual_charts
  	@type = t("general.view") + " " + t('result.annual') + "-" + t('result.charts') 
  	index
  	#render "index"
  end
  ###############################  BY SOIL  ###################################
  def by_soils
  	@type = t("result.summary") + " " + t("result.by_soil")
  	index
  	#render "index"
  end

  ###############################  SUMMARY ###################################
  def summary
    @project = Project.find(params[:project_id])
  	@type = t("general.view")
  	index
  	#render "index"
  end

  ###############################  INDEX  ###################################
  # GET /results
  # GET /results.json
  def index
  	if params[:simulation] != nil then
  		session[:simulation] = params[:simulation]
  	end
    if params[:language] != nil then
      if params[:language][:language].eql?("es")
        I18n.locale = :es
      else
        I18n.locale = :en
      end
    end
    @before_button_clicked = true
    @present1 = false
    @present2 = false
    @present3 = false
    @description = 0
    @title = ""
    @total_area = 0
    @field_name = ""
    @descriptions = Description.select("id, description, spanish_description").where("id < 71 or (id > 80 and id < 200)")
    #@project = Project.find(params[:project_id])
    add_breadcrumb t('menu.results')
	
	@scenario1 = "0"
	if params[:result1] != nil then
		if params[:result1][:scenario_id] == nil then
			@scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == ""
		else
			@scenario1 = params[:result1][:scenario_id]
		end
	else
		@scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == ""
	end
	@scenario2 ="0"
	if params[:result2] != nil then
		if params[:result2][:scenario_id] == nil then
			@scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == ""
		else
			@scenario2 = params[:result2][:scenario_id]
		end
	else
		@scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == ""
	end
	@scenario3="0"
	if params[:result3] != nil then
		if params[:result3][:scenario_id] == nil then
			@scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == ""
		else
			@scenario3 = params[:result3][:scenario_id]
		end
	else
		@scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == ""
	end
    if session[:simulation].eql?('scenario') then
        @total_area = Field.find(params[:field_id]).field_area
        @field_name = Field.find(params[:field_id]).field_name
	else
	    @total_area = 0
	    if params[:result1] != nil 
		    if !params[:result1][:scenario_id].empty? then
	    		watershed_scenarios = WatershedScenario.where(:watershed_id => Watershed.find(params[:result1][:scenario_id]).id)
	    		watershed_scenarios.each do |ws|
	    			@total_area += Field.find(ws.field_id).field_area
	    		end
		    end
		end
    end
  	if !(params[:field_id] == "0")
  		@field = Field.find(params[:field_id])
	  else
	    @field = 0
  	end
  	
    @soil = "0"
    #load crop for each scenario selected
    i = 70
    #if params[:result1] != nil then
    if @scenario1 > "0" then
      @present = true
      @before_button_clicked = false
      @errors = Array.new
      results = Result.new
	  #if params[:result1][:scenario_id] == nil or params[:result1][:scenario_id] == "" then @scenario1 = 0 else @scenario1 = params[:result1][:scenario_id] end
  	  #if params[:result2][:scenario_id] == nil or params[:result2][:scenario_id] == "" then @scenario2 = 0 else @scenario2 = params[:result2][:scenario_id] end
  	  #if params[:result3][:scenario_id] == nil or params[:result3][:scenario_id] == "" then @scenario3 = 0 else @scenario3 = params[:result3][:scenario_id] end
      if session[:simulation] == 'scenario' then
        case true
          #when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != "" && params[:result3][:scenario_id] != ""
            #results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id], :scenario_id => params[:result2][:scenario_id], :scenario_id => params[:result3][:scenario_id], :soil_id => 0).where("crop_id > 0")
          #when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != ""
            #results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id], :scenario_id => params[:result2][:scenario_id]).where("crop_id > 0")
          #when params[:result1][:scenario_id] != ""
            #results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id]).where("crop_id > 0")

          when @scenario1 > "0" && @scenario2 > "0" && @scenario3 > "0"
            results = Result.where(:field_id => params[:field_id], :scenario_id => [@scenario1, @scenario2, @scenario3], :soil_id => 0).where("crop_id > 0")
          when @scenario1 > "0" && @scenario2 > "0"
            results = Result.where(:field_id => params[:field_id], :scenario_id => [@scenario1, @scenario2]).where("crop_id > 0")
          when @scenario1 > "0"
            results = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1).where("crop_id > 0")
        end # end case true
      else
        case true
          when @scenario1 > "0" && @scenario2 > "0" && @scenario3 > "0"
            results = Result.where(:watershed_id => [@scenario1, @scenario2, @scenario3]).where("crop_id > 0")
          when @scenario1 > "0" && @scenario2 > "0" && @scenario3 > "0"
            results = Result.where(:watershed_id => [@scenario1, @scenario2]).where("crop_id > 0")
          when @scenario1 > "0"
            results = Result.where(:watershed_id => @scenario1).where("crop_id > 0")
        end # end case true
      end
      results.each do |result|
        i+=1
        #get crops name for each result to add to description list
        crop = Crop.find(result.crop_id)
      end # end results.each
    end # end if params[:result1] != nil
  	if params[:button] != nil
  		@type = params[:button]
  	else
  		if params[:button_annual] != nil
  			@type = t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
  			@title = t('result.upto12')
  		end
   		if params[:button_monthly] != nil
  			@type = t("general.view") + " " + t('result.monthly') + "-" + t('result.charts')
  		end 
  	end
  	if @type == nil then
  		@type = t("general.view")
  	end
	@crop_results = []
	@stress_ws_results = []
    @stress_ns_results = []
    @stress_ps_results = []
    @stress_ts_results = []
    if @type != nil
      (@type.eql?(t("general.view") + " " + t("result.by_soil")) && params[:result4]!=nil)? @soil = params[:result4][:soil_id] : @soil = "0"
      case @type
        when t("general.view"), t("result.summary") + " " + t("result.by_soil"), t("general.view") + " " + t("result.by_soil")
			if @type.include? t('general.view') then
				#if params[:result1] != nil
					#if !params[:result1][:scenario_id].eql?("") then
					if @scenario1 > "0" then
						#@scenario1 = params[:result1][:scenario_id]
						session[:scenario1] = @scenario1
						if session[:simulation] == 'scenario'
							@results1 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("crop_id = 0 or crop_id is null").includes(:description)
							@crop_results1 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("description_id > ? and description_id < ?", 70, 80).order("crop_id asc")
							@crop_stress1_ns = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress1_ps = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress1_ts = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress1_ws = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil).where("description_id > ? and description_id < ?", 230, 241)
						else
							@results1 = Result.where(:watershed_id => @scenario1, :crop_id => 0).includes(:description).includes(:description)
							@crop_results1 = Result.where(:watershed_id => @scenario1).where("description_id > ? and description_id < ?", 70, 80)
							@crop_stress1_ns = Result.where(:watershed_id => @scenario1).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress1_ps = Result.where(:watershed_id => @scenario1).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress1_ts = Result.where(:watershed_id => @scenario1).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress1_ws = Result.where(:watershed_id => @scenario1).where("description_id > ? and description_id < ?", 230, 241)
						end
						@crop_results1.each do |cr|
							crop_result = []
							crop_result[0] = cr.crop_id
							crop_result[1] = cr.value
							crop_result[2] = cr.ci_value
							crop_result[3] = 0
							crop_result[4] = 0
							crop_result[5] = 0
							crop_result[6] = 0
							@crop_results.push(crop_result)
						end
						@crop_stress1_ws.each do |ws|
						  water_stress = []
						  water_stress[0] = ws.crop_id
						  water_stress[1] = ws.value
						  water_stress[2] = ws.ci_value
						  water_stress[3] = 0
						  water_stress[4] = 0
						  water_stress[5] = 0
						  water_stress[6] = 0
						  @stress_ws_results.push(water_stress)
						end
						@crop_stress1_ps.each do |ps|
						  p_stress = []
						  p_stress[0] = ps.crop_id
						  p_stress[1] = ps.value
						  p_stress[2] = ps.ci_value
						  p_stress[3] = 0
						  p_stress[4] = 0
						  p_stress[5] = 0
						  p_stress[6] = 0
						  @stress_ps_results.push(p_stress)
						end
						@crop_stress1_ns.each do |ns|
						  n_stress = []
						  n_stress[0] = ns.crop_id
						  n_stress[1] = ns.value
						  n_stress[2] = ns.ci_value
						  n_stress[3] = 0
						  n_stress[4] = 0
						  n_stress[5] = 0
						  n_stress[6] = 0
						  @stress_ns_results.push(n_stress)
						end
						@crop_stress1_ts.each do |ts|
						  temp_stress = []
						  temp_stress[0] = ts.crop_id
						  temp_stress[1] = ts.value
						  temp_stress[2] = ts.ci_value
						  temp_stress[3] = 0
						  temp_stress[4] = 0
						  temp_stress[5] = 0
						  temp_stress[6] = 0
						  @stress_ts_results.push(temp_stress)
						end
						if @results1.count > 0
							@present1 = true
						else
							if params[:result1] != nil then @errors.push(t('result.first_scenario_error') + " " + t('result.result').pluralize.downcase) end
						    @results1 = nil
						end
						session[:scenario2] = ""
						session[:scenario3] = ""
					end
					#if params[:result2][:scenario_id] != "" then
					if @scenario2 > "0" then
						#@scenario2 = params[:result2][:scenario_id]
						session[:scenario2] = @scenario2
						if session[:simulation] == 'scenario'
							@results2 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("crop_id = 0 or crop_id is null").includes(:description)
							@crop_results2 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("description_id > ? and description_id < ?", 70, 80).order("crop_id asc")
							@crop_stress2_ns = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress2_ps = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress2_ts = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress2_ws = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil).where("description_id > ? and description_id < ?", 230, 241)
						else
							@results2 = Result.where(:watershed_id => @scenario2, :crop_id => 0).includes(:description).includes(:description)
							@crop_results2 = Result.where(:watershed_id => @scenario2).where("description_id > ? and description_id < ?", 70, 80)
							@crop_stress2_ns = Result.where(:watershed_id => @scenario2).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress2_ps = Result.where(:watershed_id => @scenario2).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress2_ts = Result.where(:watershed_id => @scenario2).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress2_ws = Result.where(:watershed_id => @scenario2).where("description_id > ? and description_id < ?", 230, 241)
						end
						found = false
						@crop_results2.each do |crop2|
							@crop_results.each do |crop|
								if crop2.crop_id == crop[0] then
									crop[3] = crop2.value
									crop[4] = crop2.ci_value
									found = true
									break
								end
							end
							if found == false then
								crop_result = []
								crop_result[0] = crop2.crop_id
								crop_result[1] = 0
								crop_result[2] = 0
								crop_result[3] = crop2.value
								crop_result[4] = crop2.ci_value
								crop_result[5] = 0
								crop_result[6] = 0
								@crop_results.push(crop_result)
							end
						end
						@crop_stress2_ws.each do |ws2|
						  @stress_ws_results.each do |ws|
							if ws2.crop_id == ws[0]
							  ws[3] = ws2.value
							  ws[4] = ws2.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							water_stress = []
							water_stress[0] = ws2.crop_id
							water_stress[1] = 0
							water_stress[2] = 0
							water_stress[3] = ws2.value
							water_stress[4] = ws2.ci_value
							water_stress[5] = 0
							water_stress[6] = 0
							@stress_ws_results.push(water_stress)
						  end
						end
						@crop_stress2_ps.each do |ps2|
						  @stress_ps_results.each do |ps|
							if ps2.crop_id == ps[0]
							  ps[3] = ps2.value
							  ps[4] = ps2.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							p_stress = []
							p_stress[0] = ps2.crop_id
							p_stress[1] = 0
							p_stress[2] = 0
							p_stress[3] = ps2.value
							p_stress[4] = ps2.ci_value
							p_stress[5] = 0
							p_stress[6] = 0
							@stress_ps_results.push(p_stress)
						  end
						end
						@crop_stress2_ns.each do |ns2|
						  @stress_ns_results.each do |ns|
							if ns2.crop_id == ns[0]
							  ns[3] = ns2.value
							  ns[4] = ns2.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							n_stress = []
							n_stress[0] = ns2.crop_id
							n_stress[1] = 0
							n_stress[2] = 0
							n_stress[3] = ns2.value
							n_stress[4] = ns2.ci_value
							n_stress[5] = 0
							n_stress[6] = 0
							@stress_ns_results.push(n_stress)
						  end
						end
						@crop_stress2_ts.each do |ts2|
						  @stress_ts_results.each do |ts|
							if ts2.crop_id == ts[0]
							  ts[3] = ts2.value
							  ts[4] = ts2.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							temp_stress = []
							temp_stress[0] = ts2.crop_id
							temp_stress[1] = 0
							temp_stress[2] = 0
							temp_stress[3] = ts2.value
							temp_stress[4] = ts2.ci_value
							temp_stress[5] = 0
							temp_stress[6] = 0
							@stress_ts_results.push(temp_stress)
						  end
						end
						if @results2.count > 0
							@present2 = true
						else
							if params[:result2] != nil then @errors.push(t('result.second_scenario_error') + " " + t('result.result').pluralize.downcase) end
						    @results2 = nil
						end
						session[:scenario3] = ""
					end
					#if params[:result3][:scenario_id] != "" then
					if @scenario3 > "0" then
						#@scenario3 = params[:result3][:scenario_id]
						session[:scenario3] = @scenario3
						if session[:simulation] == 'scenario'
							@results3 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("crop_id = 0 or crop_id is null").includes(:description)
							#@crop_results3 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("crop_id > 0")
							@crop_results3 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("description_id > ? and description_id < ?", 70, 80).order("crop_id asc")
							@crop_stress3_ns = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress3_ps = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress3_ts = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress3_ws = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil).where("description_id > ? and description_id < ?", 230, 241)
						else
							@results3 = Result.where(:watershed_id => @scenario3, :crop_id => 0).includes(:description).includes(:description)
							@crop_results3 = Result.where(:watershed_id => @scenario3).where("description_id > ? and description_id < ?", 70, 80)
							@crop_stress3_ns = Result.where(:watershed_id => @scenario3).where("description_id > ? and description_id < ?", 200, 211)
							@crop_stress3_ps = Result.where(:watershed_id => @scenario3).where("description_id > ? and description_id < ?", 210, 221)
							@crop_stress3_ts = Result.where(:watershed_id => @scenario3).where("description_id > ? and description_id < ?", 220, 231)
							@crop_stress3_ws = Result.where(:watershed_id => @scenario3).where("description_id > ? and description_id < ?", 230, 241)
						end
						found = false
						found = false
						@crop_results3.each do |crop3|
							@crop_results.each do |crop|
								if crop3.crop_id == crop[0] then
									crop[5] = crop3.value
									crop[6] = crop3.ci_value
									found = true
									break
								end
							end
							if found == false then
								crop_result = []
								crop_result[0] = crop3.crop_id
								crop_result[1] = 0
								crop_result[2] = 0
								crop_result[3] = 0
								crop_result[4] = 0
								crop_result[5] = crop3.value
								crop_result[6] = crop3.ci_value
								@crop_results.push(crop_result)
							end
						end
						@crop_stress3_ws.each do |ws3|
						  @stress_ws_results.each do |ws|
							if ws3.crop_id == ws[0]
							  ws[5] = ws3.value
							  ws[6] = ws3.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							water_stress = []
							water_stress[0] = ws3.crop_id
							water_stress[1] = 0
							water_stress[2] = 0
							water_stress[3] = 0
							water_stress[4] = 0
							water_stress[5] = ws3.value
							water_stress[6] = ws3.ci_value
							@stress_ws_results.push(water_stress)
						  end
						end
						@crop_stress3_ps.each do |ps3|
						  @stress_ps_results.each do |ps|
							if ps3.crop_id == ps[0]
							  ps[5] = ps3.value
							  ps[6] = ps3.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							p_stress = []
							p_stress[0] = ps3.crop_id
							p_stress[1] = 0
							p_stress[2] = 0
							p_stress[3] = 0
							p_stress[4] = 0
							p_stress[5] = ps3.value
							p_stress[6] = ps3.ci_value
							@stress_ps_results.push(p_stress)
						  end
						end
						@crop_stress3_ns.each do |ns3|
						  @stress_ns_results.each do |ns|
							if ns3.crop_id == ns[0]
							  ns[5] = ns3.value
							  ns[6] = ns3.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							n_stress = []
							n_stress[0] = ns3.crop_id
							n_stress[1] = 0
							n_stress[2] = 0
							n_stress[3] = 0
							n_stress[4] = 0
							n_stress[5] = ns3.value
							n_stress[6] = ns3.ci_value
							@stress_ns_results.push(n_stress)
						  end
						end
						@crop_stress3_ts.each do |ts3|
						  @stress_ts_results.each do |ts|
							if ts3.crop_id == ts[0]
							  ts[5] = ts3.value
							  ts[6] = ts3.ci_value
							  found = true
							  break
							end
						  end
						  if found == false
							temp_stress = []
							temp_stress[0] = ts3.crop_id
							temp_stress[1] = 0
							temp_stress[2] = 0
							temp_stress[3] = 0
							temp_stress[4] = 0
							temp_stress[5] = ts3.value
							temp_stress[6] = ts3.ci_value
							@stress_ts_results.push(temp_stress)
						  end
						end
						if @results3.count > 0
							@present3 = true
						else
							if params[:result3] != nil then @errors.push(t('result.third_scenario_error') + " " + t('result.result').pluralize.downcase) end
						    @results3 = nil
						end
					end   # end result 3
				#end # end if params[:result1] != nill
			end #end if params button summary

        when t('result.download_pdf')
          #@result_selected = t('result.summary')

        when t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
		  @chart_type = 0
          @x = "Year"
          if session[:simulation] == "scenario"
		    @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id = ? or scenario_id = ? or scenario_id = ?)", 100, @scenario1.to_s, @scenario2.to_s, @scenario3.to_s).uniq
          else
            @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (watershed_id = ? or watershed_id = ? or watershed_id = ?)", 100, @scenario1.to_s, @scenario2.to_s, @scenario3.to_s).uniq
          end
          if params[:result5] != nil && params[:result5][:description_id] != "" then
            @description = params[:result5][:description_id]
			if params[:result5][:description_id] == "70" then
				crop = Crop.find(params[:result7][:crop_id])
				@title = crop.name
				@chart_type = params[:result7][:crop_id].to_i
				@y = crop.yield_unit
				@crop = crop.id
			else
				@title = Description.find(@description).description
				@chart_type = 0
				@y = Description.find(@description).unit
			end
            if params[:result1] != nil
              if params[:result1][:scenario_id] != "" then
                @scenario1 = params[:result1][:scenario_id]
                @charts1 = get_chart_serie(@scenario1, 1)
                if @charts1.count > 0
                  @present1 = true
                else
                  @errors.push(t('result.first_scenario_error') + " " + t('general.values').pluralize.downcase)
                end
              end
              if params[:result2][:scenario_id] != "" then
                @scenario2 = params[:result2][:scenario_id]
                @charts2 = get_chart_serie(@scenario2, 1)
                if @charts2.count > 0
                  @present2 = true
                else
                  @errors.push(t('result.second_scenario_error') + " " + t('general.values').pluralize.downcase)
                end
              end
              if params[:result3][:scenario_id] != "" then
                @scenario3 = params[:result3][:scenario_id]
                @charts3 = get_chart_serie(@scenario3, 1)
                if @charts3.count > 0
                  @present3 = true
                else
                  @errors.push(t('result.third_scenario_error') + " " + t('general.values').pluralize.downcase)
                end
              end
            end
          else
            @description = ""
            @title = ""
            @y = ""
          end
        when t("general.view") + " " + t('result.monthly') + "-" + t('result.charts')
          @x = "Month"
          if params[:result6] != nil && params[:result6][:description_id] != "" then
            @description = params[:result6][:description_id]
            @title = Description.find(@description).description
            @y = Description.find(@description).unit
            if params[:result1] != nil
              if params[:result1][:scenario_id] != "" then
                @scenario1 = params[:result1][:scenario_id]
                @charts1 = get_chart_serie(@scenario1, 2)
                if @charts1.count > 0
                  @present1 = true
                else
                  @errors.push(t('result.first_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result2][:scenario_id] != "" then
                @scenario2 = params[:result2][:scenario_id]
                @charts2 = get_chart_serie(@scenario2, 2)
                if @charts2.count > 0
                  @present2 = true
                else
                  @errors.push(t('result.second_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result3][:scenario_id] != "" then
                @scenario3 = params[:result3][:scenario_id]
                @charts3 = get_chart_serie(@scenario3, 2)
                if @charts3.count > 0
                  @present3 = true
                else
                  @errors.push(t('result.third_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
            end
          else
            @description = ""
            @title = ""
            @y = ""
          end
      end # end case type
    end # end if != nill <!--<h1><%=@type + " " + @title%></h1>-->
    if params[:format] == "pdf" then
      pdf = render_to_string pdf: "report",
  	  page_size: "Letter", layout: "pdf",
  	  template: "/results/report",
  	  footer: {center: '[page] of [topage]'},
  	  header: {spacing: -6, html: {template: '/layouts/_report_header.html'}},
  	  margin: {top: 16}
      send_data(pdf, :filename => "report.pdf")
	  return
    end # if format is pdf
	if params[:action] == "index" then   # just run the format for Tabular => General menu option.
      respond_to do |format|
        format.html
        format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"report-#{Date.today}.xlsx\"" }
        format.csv { send_data @crop_results.to_csv, filename: "report-#{Date.today}.csv"}
      end
	end
  end  # end Method Index

  ###############################  SHOW  ###################################
  # GET /results/1
  # GET /results/1.json
  def show
    #@result = Result.find(params[:id])
	@crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id == ? or scenario_id == ? or scenario_id == ?)", 100, params[:id], params[:id2], params[:id3]).uniq

    respond_to do |format|
		format.html # show.html.erb
		format.json { render json: @crops }
    end
  end

  ###############################  NEW  ###################################
  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @result }
    end
  end

  ###############################  EDIT  ###################################
  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: t('result.result') + " " + t('general.success') }
        format.json { render json: @result, status: :created, location: @result }
      else
        format.html { render action: "new" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(result_params)
        format.html { redirect_to @result, notice: t('result.result') + " " + t('general.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end

  def sel
    @result = Result.where(:field_id => params[:id], :scenario_id => [params[:scenario1], params[:scenario2], params[:scenario3]], :soil_id => 0).where("crop_id > 0")

    respond_to do |format|
      format.html # sel.html.erb
      format.json { render json: @result }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def result_params
    params.require(:result).permit(:field_id, :scenario_id, :soil_id, :value, :watershed_id, :description_id, :ci_value)
  end

  def get_chart_serie(scenario_id, month_or_year)
    if month_or_year == 1 then #means chart is annual
  		if session[:simulation] != 'scenario' then
  			watershed_scenarios = WatershedScenario.where(:watershed_id => scenario_id)
  			watershed_scenarios.each do |ws|
      			params[:field_id] = ws.field_id
      		end
  		end
  		first_year = Field.find(params[:field_id]).weather.simulation_final_year-12
  		if @chart_type > 0 then
  			chart_values = Chart.select("month_year, value").where("field_id = ? AND scenario_id = ? AND soil_id = ? AND crop_id = ? AND month_year > ? AND description_id < ?", params[:field_id], scenario_id, @soil, @chart_type, first_year, 80).order("month_year desc").limit(12).reverse
  		else
	        if session[:simulation] != 'scenario'
	          	chart_values = Chart.select("month_year, value").where("field_id = ? AND watershed_id = ? AND soil_id = ? AND description_id = ? AND month_year > ?", 0, scenario_id, @soil, @description, first_year).order("month_year desc").limit(12).reverse
	        else
	  		    chart_values = Chart.select("month_year, value").where("field_id = ? AND scenario_id = ? AND soil_id = ? AND description_id = ? AND month_year > ?", params[:field_id], scenario_id, @soil, @description, first_year).order("month_year desc").limit(12).reverse
	        end
      	end
    else #means chart is monthly average
      if session[:simulation] != 'scenario'
        chart_values = Chart.select("month_year, value").where("field_id = ? AND watershed_id = ? AND soil_id = ? AND description_id = ? AND month_year <= ?", 0, scenario_id, @soil, @description, 12)
      else
        chart_values = Chart.select("month_year, value").where("field_id = ? AND scenario_id = ? AND soil_id = ? AND description_id = ? AND month_year <= ?", params[:field_id], scenario_id, @soil, @description, 12)
      end
    end
    charts = Array.new
	if month_or_year == 2 then
		chart_values.each do |c|
		  chart = Array.new
		  #chart.push(c.month_year)
		  chart.push(listMonths[c.month_year-1][0])
		  chart.push(c.value)
		  charts.push(chart)
		end
	else
		current_year = first_year + 1
		chart_values.each do |c|
			while current_year < c.month_year
				chart = Array.new
				chart.push(current_year)
				chart.push(0)
				charts.push(chart)
				current_year +=1
			end
			chart = Array.new
			chart.push(c.month_year)
			chart.push(c.value)
			charts.push(chart)
			current_year +=1
		end
	end
    return charts
  end #end method get_chart_serie
end
