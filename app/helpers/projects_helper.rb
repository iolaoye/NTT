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

 ######################### Duplicate a Timespan by bmp #################################################
  def duplicate_timespan_by_bmp(bmp_id, new_bmp_id)
  timespans = Timespan.where(:bmp_id => bmp_id)
  timespans.each do |timespan|
    new = timespan.dup
    new.bmp_id = new_bmp_id
    if !new.save
      return "Error Saving timespan by Bmp"
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
    duplicate_timespan_by_bmp(bmp.id, new.id)
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
      duplicate_subareas_by_scenario(scenario.id) unless @project.version.include?("special")
      #4. Copy operations info
      duplicate_operations(scenario.id)
      #5. Copy bmps info
      scenario.bmps.each do |b|
        duplicate_bmp(b)
      end   # end bmps.each
      if !@project.version.include?("special")
      # Duplicate annual results when soil_id > 0.
        results = scenario.annual_results
        results.each do |r|
          duplicate_result(r)
        end
        # Duplicate crop results when soil_id > 0.
        results = scenario.crop_results
        results.each do |r|
          duplicate_result(r)
        end
      else
        # Duplicate county results when soil_id > 0.
        results = scenario.county_results
        results.each do |r|
          duplicate_result(r)
        end
        # Duplicate county crop results when soil_id > 0.
        results = scenario.county_crop_results
        results.each do |r|
          duplicate_result(r)
        end
      end
    else
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

  ######################## Upload SoilOperation ################################################
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
        if Soil.find_by_soil_id_old(p.text) == nil then
        return "OK"
        else
        soil_operation.soil_id = Soil.find_by_soil_id_old(p.text).id
        end
      end
    end  # end case
    end  # node
    if soil_operation.save
    return "OK"
    else
    return "soil operation could not be saved"
    end
  end

  ######################## Upload Timespan ################################################
  def upload_timespan_info(node, crop_id, bmp_id)
    timespan = Timespan.new
    timespan.bmp_id = bmp_id
    node.elements.each do |p|
    case p.name
      when "crop_id"
      timespan.crop_id = p.text
      when "start_month"
      timespan.start_month = p.text
      when "start_day"
      timespan.start_day = p.text
      when "end_month"
      timespan.end_month = p.text
      when "end_day"
      timespan.end_day = p.text
    end
    end
    if timespan.save
    return "OK"
    else
    return "timespan could not be saved"
    end
  end

  ######################## Upload Climate ################################################
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

  ######################## Upload Bmp info ################################################
  def upload_bmp_info_new_version(scenario_id, new_bmp)
    bmp = Bmp.new
    bmp.scenario_id = scenario_id
    if !bmp.save then return "Error saving Bmp" end
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
            msg = upload_climate_new_version(climate, bmp.id)
            if msg != "OK"
              return msg
            end
          end
        when "subareas"
          p.elements.each do |subarea|
            msg = upload_subarea_new_version(bmp.id, scenario_id, subarea)
            if msg != "OK"
              return msg
            end
          end
        when "soil_operations"
          p.elements.each do |soil_op|
            msg = upload_soil_operation_new(soil_op, 0, 0, 0, bmp.id)
            if msg != "OK"
              return msg
            end
          end
        when "timespans"
          p.elements.each do |timespan|
            msg = upload_timespan_info(timespan, bmp.crop_id, bmp.id)
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

    ######################## Upload operations from Comet ################################################
  def upload_operation_comet_version(scenario_id, new_operation)
      operation = Operation.new
      operation.scenario_id = scenario_id
      operation.save
      activity_id = 0
      crop =  nil
      crops = 1
      carbon = 0.0
      auto_irr_start = false
      auto_irr_end = false
      for i in 0..(new_operation.length - 1)
        p = new_operation[i]
        #new_operation.elements.each do |p|
        case p.name
          when "Crop"
            operation.crop_id = p.text
            if operation.crop_id == 600 then
              crops = 3
              operation.crop_id = 41
            elsif operation.crop_id == 601 then
              crops = 2
              operation.crop_id = 41
            end
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
              when  p.text.include?("Auto Irrigation START")
                activity_id = 6
                auto_irr_start = true
              when  p.text.include?("Auto Irrigation END")
                activity_id = 6
                auto_irr_end = true
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
            if auto_irr_start then operation.moisture = p.text end
            if auto_irr_end then operation.moisture = p.text end
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
              scenario = Scenario.find(scenario_id)
              scenario.subareas.each do |suba|
                if suba.nirr <= 0 then
                  suba.nirr = operation.type_id
                  suba.iri = 1
                  suba.vimx = 5000
                  suba.armx = 75
                  suba.save
                end
              end
            end
            if operation.activity_id == 2 then operation.depth = operation.depth / IN_TO_MM end
            if operation.activity_id == 7 then operation.type_id = p.text end
          when "Opv4"
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
                carbon = nutrients[5]
                operation.org_c = nutrients[6] #total N
                #total_n = nutrients[6].to_f
                operation.nh4_n = nutrients[7]   #total p
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
                  operation.no3_n = (operation.org_c / 2000) / ((100 - operation.moisture) / 100) * operation.no3_n
                  operation.po4_p = (operation.nh4_n * 0.4364 / 2000) / ((100 - operation.moisture) / 100) * operation.po4_p
                  operation.org_n = (operation.org_c / 2000) / ((100 - operation.moisture) / 100) * operation.org_n
                  operation.org_p = (operation.nh4_n * 0.4364 / 2000) / ((100 - operation.moisture) / 100) * operation.org_p
                  operation.amount = operation.amount / (2247*(100-operation.moisture)/100)
                when 3
                  operation.no3_n = (operation.org_c  * 0.011982) / (100 - operation.moisture) * operation.no3_n
                  operation.po4_p = (operation.nh4_n * 0.4364 * 0.011982) / (100 - operation.moisture) * operation.po4_p
                  operation.org_n = (operation.org_c  * 0.011982) / (100 - operation.moisture) * operation.org_n
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
      add_soil_operation(operation, carbon)
      if crops == 2
          set_new_operation(operation, 33)
        end
      if crops == 3
            set_new_operation(operation, 150)
        end
        return "OK"
      else
        return "operation could not be saved"
      end
  end

  def set_new_operation(oper_old, crop_id)
    oper_new = Operation.new
    oper_new.crop_id = crop_id
    crop = Crop.find_by_number(oper_new.crop_id)
    if crop == nil then 
      oper_new.crop_id = 0
    else
      oper_new.crop_id = crop.id
    end
    oper_new.activity_id = oper_old.activity_id
    oper_new.day = oper_old.day
    oper_new.month_id = oper_old.month_id
    oper_new.year = oper_old.year
    oper_new.type_id = oper_old.type_id
    oper_new.amount = oper_old.amount
    oper_new.depth = oper_old.depth
    oper_new.no3_n = oper_old.no3_n
    oper_new.po4_p = oper_old.po4_p
    oper_new.org_n = oper_old.org_n
    oper_new.org_p = oper_old.org_p
    oper_new.nh3 = oper_old.nh3
    oper_new.scenario_id = oper_old.scenario_id
    oper_new.subtype_id = oper_old.subtype_id
    oper_new.moisture = oper_old.moisture
    oper_new.org_c = oper_old.org_c
    oper_new.nh4_n = oper_old.nh4_n
    oper_new.rotation = oper_old.rotation
    oper_new.save
    add_soil_operation(oper_new,0)
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

  ########################################### Create county field ##################
  def create_field(field_name, county_id)
    @field = Field.new
    @field.field_name = field_name
    @field.location_id = 0
    @field.field_area = 100
    @field.weather_id = 0
    @field.soilp = 0
    @field.location_id = @location.id
    #save county id in here in order to have it available for other counties in the same state. And because there only one location for project. 
    @field.field_average_slope = county_id
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

  ########################################### Create county weather ##################
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

  ########################################### Create county soil ##################
  def create_soil
    soil = Soil.new
    soil.field_id = @field.id
    soil.key = @project.id    #just to identify it no used
    soil.group = "B"
    soil.name = @field.field_name
    soil.slope = 0.1
    soil.albedo = 0.37
    soil.percentage = 100
    soil.drainage_id = 1
    if soil.save then
      return true
    else
      return false
    end
  end

end