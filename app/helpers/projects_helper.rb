module ProjectsHelper
  def sort_link(column, title = nil)
    title ||= column.titleize
	#todo check this.
	case true
		when column.include?("Date Created")
			column = "created_at"
		when column.include?("Fecha de Creaci")
			column = "created_at"
		when column.include?("Nombre")
			column = "name"
		when column.include?("Project Name")
			column = "name"
		when ["User", "Usuario"].include?(column)
			column = "user_id"
	end  #end case
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, {column: title, direction: direction}
  end

  ######################### Duplicate results #################################################
  def duplicate_result(result)
	#1. copy result to new result
		#result = Result.find(result_id)   #1. find result to copy
		new_result = result.dup
		#new_result.field_id = new_field_id
		new_result.scenario_id = @new_scenario_id
		#if result.soil_id > 0 then
			#new_result.soil_id = Soil.find_by_soil_id_old(result.soil_id).id
		#end
		if new_result.save
			"OK"
		else
			"Error Saving results"
		end # end if result saved
  end   # end duplicate location

  ######################### Duplicate Weathers #################################################
  def duplicate_weather(field_id, new_field_id)
	#1. copy weather to new weather
		weather = Weather.find_by_field_id(field_id)   #1. find weather to copy
		new_weather = weather.dup
		new_weather.field_id = new_field_id
		if new_weather.save
			"OK"
		else
			"Error Saving weather"
		end # end if field saved
  end   # end duplicate location

  ######################### Duplicate Soils #################################################
  def duplicate_layer(layer_id, new_soil_id)
	#1. copy layer to new layer
		layer = Layer.find(layer_id)   #1. find layer to copy
		new_layer = layer.dup
		new_layer.soil_id = new_soil_id
		if new_layer.save
			"OK"
		else
			"Error Saving layers"
		end # end if soil saved
  end   # end duplicate layer

  ######################### Duplicate Soils #################################################
  def duplicate_soil(soil_id, new_field_id)
	#1. copy soil to new soil
		soil = Soil.find(soil_id)   #1. find soil to copy
		new_soil = soil.dup
		new_soil.field_id = new_field_id
		new_soil.soil_id_old =  soil.id
		if new_soil.save
			soil.layers.each do |l|
				duplicate_layer(l.id, new_soil.id)
			end
			"OK"
		else
			"Error Saving soils"
		end # end if soil saved
  end   # end duplicate soil

  ######################### Duplicate Fields #################################################
  def duplicate_field(field_id, new_location_id)
	#1. copy field to new field
	field = Field.find(field_id)   #1. find field to copy
  	field_id = Hash.new
	new_field = field.dup
	new_field.location_id = new_location_id
	if new_field.save
	    field_id = Hash.new
	    field_id[field.id] = new_field.id
	    @field_ids.push(field_id)
		#duplicate site
		new_site = field.site.dup
		new_site.field_id = new_field.id
		if !new_site.save then
			return "Error saving Site"
		end
		field.soils.each do |s|
			duplicate_soil(s.id, new_field.id)
		end
		duplicate_weather(field.id, new_field.id)
		field.scenarios.each do |s|
			duplicate_scenario(s.id, "", new_field.id)
		end   # end scnearios.each
		"OK"
	else
		"Error Saving fields"
	end # end if field saved
	field.soils.update_all soil_id_old: nil
  end   # end duplicate location

  ######################### Duplicate a location #################################################
  def duplicate_location(new_project_id)
	#1. copy location to new location
  	new_location = @project.location.dup
	new_location.project_id = new_project_id
	if new_location.save
    	@field_ids = Array.new
    	@scenario_ids = Array.new
		@project.location.fields.each do |f|
			duplicate_field(f.id, new_location.id)
		end
    	@project.location.watersheds.each do |w|
      	duplicate_watershed(w.id, new_location.id)
    end
			"OK"
		else
			"Error Saving location"
	end  # end if location saved
  end   # end duplicate location

  ######################### Duplicate a apex_control #################################################
  def duplicate_apex_control(new_project_id)
	#1. copy apexcontrol
	@project.apex_controls.each do |apex_control|
		new_apex_control = apex_control.dup
		new_apex_control.project_id = new_project_id
		if !new_apex_control.save then return "Error copying control values" end
	end  # end apex_controls.each
	return "OK"
  end   # end duplicate apex_control

  ######################### Duplicate a apex_parameter #################################################
  def duplicate_apex_parameter(new_project_id)
	#2. copy apexparameter
	@project.apex_parameters.each do |apex_parameter|
		new_apex_parameter = apex_parameter.dup
		new_apex_parameter.project_id = new_project_id
		if !new_apex_parameter.save then return "Error copying parameters values" end
	end  # end apex_parameters.each
	return "OK"
  end   # end duplicate apex_parameter

  ######################### Duplicate a Project #################################################
  def duplicate_project
	msg = "OK"
	#1. find project to copy
	@project = Project.find(params[:id])
	#2. copy project to new project
  	new_project = @project.dup
	new_project.name = @project.name + " copy"
	new_project.user_id = session[:user_id]
	if new_project.save
		duplicate_location(new_project.id)
		msg = duplicate_apex_control(new_project.id)
		if msg == "OK" then msg = duplicate_apex_parameter(new_project.id) else return msg end
		if msg == "OK" then
			#delete all of the old_soil_id from soils to avoid errors if the project is duplicated again
			new_project.fields.each do |field|
				field.soils.update_all(:soil_id_old => nil)
			end
		end
		"OK"
	else
		"Error Saving project"
	end   # end if project saved
  end   # end duplicate project method

  ######################### Duplicate an operation #################################################
  def duplicate_operation(operation_id, name)
	operation = Operation.find(operation_id)
	new_operation = operation.dup
	new_operation.scenario_id = @new_scenario_id
	if new_operation.activity_id == 7 then  #when continues grazing the type_id should be updated for the kill operation.
		new_operation.subtype_id = operation_id
	end
	if !new_operation.save
		"Error saving operation"
	end
  end

  ######################### Duplicate a Subareas by scenario/soil #################################################
  def duplicate_subareas_by_scenario(scenario_id)
	subareas = Subarea.where("scenario_id = " + scenario_id.to_s + " and soil_id > 0")
	subareas.each do |subarea|
  		new_subarea = subarea.dup
		new_subarea.scenario_id = @new_scenario_id
		if @use_old_soil == true then
			new_subarea.soil_id = Soil.find_by_soil_id_old(subarea.soil_id).id
		end
		if !new_subarea.save
			return "Error Saving subarea"
		end
	end   # end subareas.each
  end

  ######################### Duplicate a Subareas by scenario/bmp #################################################
  def duplicate_subareas_by_bmp(bmp_id, new_bmp_id)
	subareas = Subarea.where(:bmp_id => bmp_id)
	subareas.each do |subarea|
		new = subarea.dup
		new.bmp_id = new_bmp_id
		new.scenario_id = @new_scenario_id
		if !new.save
			return "Error Saving subarea by bmp"
		end
	end   # end subareas.each
  end

  ######################### Duplicate a Operations #################################################
  def duplicate_operations(scenario_id)
	operations = Operation.where(:scenario_id => scenario_id)
	operations.each do |operation|
		if operation.activity_id == 8 || operation.activity_id == 10 then # if stop grazing operation is duplicated differently
			next
		end
  		new = operation.dup
		new.scenario_id = @new_scenario_id
		if !new.save
			return "Error Saving operation"
		else
			duplicate_soil_operations_by_scenarios(operation.id, new.id)
			if operation.activity_id == 7 || operation.activity_id == 9 then #continuous and rotational grazing
				stop_operation = operations.find_by_type_id(operation.id)
				if stop_operation != nil then #create the stop grazing operation
					new_stop_graizing = stop_operation.dup
					new_stop_graizing.scenario_id = @new_scenario_id
					new_stop_graizing.type_id = new.id
					if !new_stop_graizing.save
						return "Error Saving operation"
					else
						if operation.activity_id == 7 then
							duplicate_soil_operations_by_scenarios(stop_operation.id, new_stop_graizing.id)
						end
					end
				end
			end
		end
	end   # end operation.each
  end

  ######################### Duplicate a SoilOperation by operation/soil #################################################
  def duplicate_soil_operations_by_scenarios(operation_id, new_operation_id)
	soil_operations = SoilOperation.where(:operation_id => operation_id)
	soil_operations.each do |soil_operation|
  		new = soil_operation.dup
		new.scenario_id = @new_scenario_id
		new.operation_id = new_operation_id
		if @use_old_soil == true then
			new.soil_id = Soil.find_by_soil_id_old(soil_operation.soil_id).id
		end
		if !new.save
			return "Error Saving soil operation"
		end
	end
  end

  ######################### Duplicate a SoilOperation by bmp #################################################
  def duplicate_soil_operation_by_bmp(bmp_id, new_bmp_id)
	soil_operations = SoilOperation.where(:bmp_id => bmp_id)
	soil_operations.each do |soil_operation|
  		new = soil_operation.dup
		new.scenario_id = @new_scenario_id
		new.bmp_id = new_bmp_id
		if !new.save
			return "Error Saving soil operation by Bmp"
		end
	end
  end

  ######################### Duplicate a Bmps #################################################
  def duplicate_bmp(bmp)
  	new = bmp.dup
	new.scenario_id = @new_scenario_id
	if !new.save
		return "Error Saving Bmp"
	else
		duplicate_soil_operation_by_bmp(bmp.id, new.id)
		duplicate_subareas_by_bmp(bmp.id, new.id)
	end
  end

  ######################### Duplicate a Scenario  #################################################
  def duplicate_scenario(scenario_id, name, new_field_id)
	scenario = Scenario.find(scenario_id)   #1. find scenario to copy
	#2. copy scenario to new scenario
  	scenario_id = Hash.new
  	new_scenario = scenario.dup
	new_scenario.name = scenario.name + name
	new_scenario.field_id = new_field_id
	#new_scenario.last_simulation = ""
  	if new_scenario.save
	    scenario_id = Hash.new
	    scenario_id[scenario.id] = new_scenario.id
	    if @scenario_ids != nil then @scenario_ids.push(scenario_id) end
	    @new_scenario_id = new_scenario.id
	    #3. Copy subareas info by scenario
		duplicate_subareas_by_scenario(scenario.id)
		#4. Copy operations info
		duplicate_operations(scenario.id)
		#5. Copy bmps info
		scenario.bmps.each do |b|
			duplicate_bmp(b)
		end   # end bmps.each
		# Duplicate annual results when soil_id > 0.
		results = scenario.annual_results
		results.each do |r|
			duplicate_result(r)
		end
		# Duplicate crop results when soil_id > 0.
		results = scenario.crop_results
		results.each do |r|
			duplicate_result(r)
		end	else
		return "Error Saving scenario"
	end   # end if scenario saved
  	return "OK"
  end

  ####################### Duplicate Watershed Scenarios ######################
  def duplicate_watershed_scenarios(scenarios_id, new_watershed_id)
    scenario = WatershedScenario.find(scenarios_id)
    new_scenario = scenario.dup
    new_scenario.watershed_id = new_watershed_id
    @field_ids.each do |field_id|
    	if field_id.has_key?(scenario.field_id) then
           new_scenario.field_id = field_id.fetch(scenario.field_id)
        end
    end
        @scenario_ids.each do |scenario_id|
    	if scenario_id.has_key?(scenario.scenario_id) then
           new_scenario.scenario_id = scenario_id.fetch(scenario.scenario_id)
        end
    end
    if !new_scenario.save
      return "Failed to save watershed scenario"
    end
  end

    ######################## Duplicate Watershed ################################################
    def duplicate_watershed(watershed_id, new_location_id)
    watershed = Watershed.find(watershed_id)
    new_watershed = watershed.dup
    new_watershed.location_id = new_location_id
      if !new_watershed.save
        return "Watershed not Saved"
      end
      watershed.watershed_scenarios.each do |ws|
        duplicate_watershed_scenarios(ws.id, new_watershed.id)
      end
    end

    ######################## Upload operations from Comet ################################################
	def upload_operation_comet_version(scenario_id, new_operation)
	    operation = Operation.new
	    operation.scenario_id = scenario_id
	    operation.save
	    activity_id = 0
	    crop =  nil
	    for i in 0..(new_operation.length - 1)
	      p = new_operation[i]
	      #new_operation.elements.each do |p|
	      case p.name
	        when "Crop"
	          operation.crop_id = p.text
	          crop = Crop.find_by_number(operation.crop_id)
	          if crop == nil then 
	          	operation.crop_id = 0
	          else
	          	operation.crop_id = crop.id
	          end
	          
	        when "Operation_Name"   #todo
	          case true
	            when p.text.include?("Tillage")
	              activity_id = 3
	            when  p.text.include?("Planting")
	              activity_id = 1
	            when  p.text.include?("Harvest")
	              activity_id = 4
	            when  p.text.include?("Kill")
	              activity_id = 5
	            when  p.text.include?("Irrigation")
	              activity_id = 6
	            when p.text.include?("Liming")
	              activity_id = 12
	            when p.text.include?("Manure")
	              activity_id = 2
	            when p.text.include?("Grazing Start")
	              activity_id = 7
	            when p.text.include?("Grazing End")
	              activity_id = 8
	            when p.text.include?("Burn")
	              activity_id = 11
	            else
	              activity_id = 2
	          end
	          operation.activity_id = activity_id
	        when "Day"
	          operation.day = p.text
	        when "Month"
	          operation.month_id = p.text
	        when "Year"
	          operation.year = p.text
	        when "Operation"
	          operation.type_id = p.text
	          if p.text == "427" then 
	          	operation.type_id = @graz_oper_id 
	          end
	          if p.text == "580" then
	            operation.activity_id = 2
	            operation.subtype_id = 1
	          end
	        when "subtype_id"
	          operation.subtype_id = 0
	        when "Opv1"
	          operation.amount = p.text
	          if operation.amount == nil then operation.amount = 0 end
	          if operation.activity_id == 6 then operation.amount = operation.amount * MM_TO_IN end #irrigation - volume
	          if operation.activity_id == 12 then operation.amount = operation.amount * KG_TO_LBS / HA_TO_AC end #liming application
	          #if operation.activity_id == 7 then operation.amount = operation.amount end # Number of animal units
	        when "Opv2"
	          operation.depth = p.text
	        when "Opv3"
	          if operation.activity_id == 6 then
	            if ["1","2","3","7"].include? p.text then
	              operation.type_id = p.text 
	            else
	              case operation.type_id
	                when 500
	                  operation.type_id = 1
	                when 502
	                  operation.type_id = 2
	                when 530
	                  operation.type_id = 3
	              end
	            end
	          end
	          if operation.activity_id == 2 then operation.depth = operation.depth / IN_TO_MM end
	          if operation.activity_id == 7 then operation.type_id = p.text end
	        when "Opv4"
	          #todo add opv4 for grazing
	          total_n = 0
	          if operation.activity_id == 2 then 
	            nutrients = p.text.split(",")
	            operation.no3_n = nutrients[0]
	            operation.po4_p = nutrients[1]
	            operation.org_n = nutrients[2]
	            operation.org_p = nutrients[3]
	            operation.nh3 = nutrients[4]
	            operation.type_id = 1
	            if nutrients.count >= 9 then
	              operation.org_c = nutrients[5] 
	              total_n = nutrients[6].to_f
	              operation.nh4_n = nutrients[7]
	              operation.moisture = nutrients[8]
	              operation.type_id = nutrients[9].to_i + 1
	            end
	            if operation.no3_n != nil then operation.no3_n *= 100 end
	            #if operation.no3_n > 0 then operation.subtype_id = 1
	            if operation.po4_p != nil then operation.po4_p *= 100 end
	            #if operation.po4_p > 0 then operation.subtype_id = 2
	            if operation.org_n != nil then operation.org_n *= 100 end
	            if operation.org_p != nil then operation.org_p *= 100 end
	            case operation.type_id
	              when 1  
	                operation.amount = operation.amount * KG_TO_LBS / HA_TO_AC
	              when 2
	                operation.no3_n = (total_n/ 2000) / ((100 - operation.moisture) / 100) * operation.no3_n
	                operation.po4_p = (operation.nh4_n * 0.4364 / 2000) / ((100 - operation.moisture) / 100) * operation.po4_p
	                operation.org_n = (total_n/ 2000) / ((100 - operation.moisture) / 100) * operation.org_n
	                operation.org_p = (operation.nh4_n * 0.4364 / 2000) / ((100 - operation.moisture) / 100) * operation.org_p
	                operation.amount = operation.amount / (2247*(100-operation.moisture)/100)
	              when 3
	                operation.no3_n = (total_n * 0.011982) / (100 - operation.moisture) * operation.no3_n
	                operation.po4_p = (operation.nh4_n * 0.4364 * 0.011982) / (100 - operation.moisture) * operation.po4_p
	                operation.org_n = (total_n * 0.011982) / (100 - operation.moisture) * operation.org_n
	                operation.org_p = (operation.nh4_n * 0.4364 * 0.011982) / (100 - operation.moisture) * operation.org_p
	                operation.amount = operation.amount / (9350*(100-operation.moisture)/100)
	             end            
	          end
	          if operation.activity_id == 6 then operation.depth = p.text.to_f * 100 end
	          if operation.activity_id == 7 then 
	          	operation.nh3 = p.text 
	          	operation.org_c = 1
	          end
	        when "Opv5"
	          if operation.activity_id == 1 then
	            operation.amount = p.text
	            operation.subtype_id = 0  #makes subtype different than 1 to avoid consufution with CC.
	            if operation.amount != nil then   #take plant population from crop if Opv5 is zero
	              if operation.amount <= 0 then operation.amount = crop.plant_population_mt * FT2_TO_M2 end
	            end
	          end
	          if operation.activity_id == 7 then operation.subtype_id = p.text end
	      end
	    end
	    operation.rotation = 1
	    if operation.save then
	      if operation.activity_id == 7 then #means this is a Grazing Start operations. We need to save the id to add into the type_id for Grazing End operation 
	      	@graz_oper_id = operation.id
	      end
	      add_soil_operation(operation)
	      return "OK"
	    else
	      return "operation could not be saved"
	    end
	end

    ######################## Upload BMPs from Comet ################################################
  	def upload_bmp_comet_version(scenario_id, new_bmps)
	    values = {}
	    values[:action] = "save_bmps_from_load"
	    values[:project_id] = @project.id
	    values[:button] = t('submit.savecontinue')
	    for i in 0..(new_bmps.length - 1)
	      #bmp = Bmp.new
	      #bmp.scenario_id = scenario_id
	      case new_bmps[i].name
	        when "TileDrain"
	          values[:field_id] = @field.id
	          values[:scenario_id] = scenario_id
	          values[:bmp_td] = {}
	          values[:bmp_td][:depth] = (new_bmps[0].elements[0].text.to_f / FT_TO_MM).round(1)
	          values[:bmpsublist_id] = 3
	          #bmp.depth = new_bmps[0].elements[0].text
	          #bmp.depth = (bmp.depth / FT_TO_MM).round(1)
	          #bmp.save
	          #update subarea file with the TD
	          #subareas = Subarea.where(:scenario_id => scenario_id)
	          #subareas.each do |subarea|
	            #subarea.idr = new_bmps[0].elements[0].text
	            #subarea.save
	          #end
	        when "AutoIrrigation"
	          #params[:scenario_id] = scenario_id
	          values[:bmpsublist_id] = 1
	          values[:irrigation_id] = new_bmps[0].elements["Code"].text
	          values[:days] = new_bmps[0].elements["Frequency"].text
	          values[:water_stress_factor] = new_bmps[0].elements["Stress"].text
	          values[:irrigation_efficiency] = new_bmps[0].elements["Efficiency"].text
	          values[:maximum_single_application] = new_bmps[0].elements["Volume"].text * MM_TO_IN
	          values[:dry_manure] = new_bmps[0].elements["ApplicationRate"].text
	      end
	      #$params = params
	      bmp_controller = BmpsController.new
	      bmp_controller.request = request
	      bmp_controller.response = response
	      bmp_controller.save_bmps_from_load(values)
	    end
	end

end
