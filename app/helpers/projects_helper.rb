module ProjectsHelper
  def sort_link(column, title = nil)
    title ||= column.titleize
	#todo check this.
	case true
		when column.include?("Last Modified")
			column = "updated_at"
		when column.include?("ltima Modificaci")
			column = "updated_at"
		when column.include?("Nombre")
			column = "name"
		when column.include?("Project Name")
			column = "name"
	end  #end case
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, {column: title, direction: direction}
  end

  ######################### Duplicate charts #################################################
  def duplicate_chart(chart_id, new_field_id)
	#1. copy chart to new result
		chart = Chart.find(chart_id)   #1. find chart to copy
		new_chart = chart.dup
		new_chart.field_id = new_field_id
		new_chart.scenario_id = @new_scenario_id
		if new_chart.save
			"OK"
		else
			"Error Saving charts"
		end # end if chart saved
  end   # end duplicate location

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
		# duplicate results when soli_id => 0. totals
		#results = field.results.where(:field_id => field.id, :soil_id => 0)
		#results.each do |r|
			#duplicate_result(r.id, new_field.id)
		#end
		# duplicate charts when soli_id => 0. totals
		#charts = field.charts.where(:field_id => field.id, :soil_id => 0)
		#charts.each do |c|
			#duplicate_chart(c.id, new_field.id)
		#end
		field.scenarios.each do |s|
			duplicate_scenario(s.id, "", new_field.id)
			#charts = field.charts.where(:field_id => field.id, :scenario_id => s.id)
			#charts.each do |c|
				#duplicate_chart(c.id, new_field.id)
			#end
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
		if msg == "OK" then duplicate_apex_parameter(new_project.id) else return msg end
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

  ######################### Duplicate a bmp #################################################
  def duplicate_bmp(bmp_id, name)
	bmp = Bmp.find(bmp_id)
	new_bmp = bmp.dup
	new_bmp.scenario_id = @new_scenario_id
	if new_bmp.save
		# 4.1 copy subareas that belonge to a BMP
		subareas = Subarea.where(:bmp_id => bmp.id)
		if !(subareas.blank? || subareas == nil) then
			subareas.each do |subarea|
				new = subarea.dup
				new.scenario_id = new_scenario.id
				new.bmp_id = new_bmp.id
				if !new.save
					#todo send error message
				else
					#todo send error message
				end
			end    # end subareas.each
		end # end if subareas

		# 4.2 copy soil_operations that belonge to a BMP
		soil_operations = SoilOperation.where(:bmp_id => bmp.id)
		if !(soil_operations.blank? || soil_operations == nil) then
			soil_operations.each do |soil_operation|
				new = soil_operation.dup
				new.scenario_id = new_scenario.id
				new.bmp_id = new_bmp.id
				if !new.save
					return "Error Saving soil operation"
				else
					"OK"
				end
			end    # end subareas.each
		end # end if subareas

		# 4.3 copy climates that belonge to a BMP
		climates = Climate.where(:bmp_id => bmp.id)
		if !(climates.blank? || climates == nil) then
			climates.each do |climate|
				new = climate.dup
				new.bmp_id = bmp.id
				if !new.save
					return "Error Saving climates"
				else
					"OK"
				end
			end    # end climate.each
		end # end if climate
	else
		"Error saving bmp"
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

end
