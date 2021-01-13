module ScenariosHelper
	def add_field_operations(replace, scenario_id, cropping_system_id, year, tillage_id)
		if replace != nil
		  #Delete operations for the scenario selected
		  Operation.where(:scenario_id => scenario_id).destroy_all
		end
		#take the event for the cropping_system and tillage selected and add to the operation and soilOperaition files for the scenario selected.
		crop_schedule_class_id = @cropping_systems.find(cropping_system_id).class_id
		events = Schedule.where(:crop_schedule_id => cropping_system_id)
		events.each do |event|
		  operation = Operation.new
		  operation.scenario_id = scenario_id
		  #get crop_id from croppingsystem and state_id
		  state_id = @project.location.state_id
		  @crop = Crop.find_by_number_and_state_id(event.apex_crop, state_id)
		  if @crop == nil then
		    @crop = Crop.find_by_number_and_state_id(event.apex_crop, '**')
		  end
		  operation.crop_id = @crop.id
		  if @crop.lu_number == 28 then
		  	plant_population = @crop.plant_population_ac
		  else
		  	plant_population = @crop.plant_population_ft
		  end
		  operation.activity_id = event.activity_id
		  operation.day = event.day
		  operation.month_id = event.month
		  operation.rotation = year
		  if replace != nil
		    #replace
		    operation.year = event.year
		  else
		    #don't replace
		    if @count > 0
		      operation.year = event.year + year.to_i - 1
		    else
		      operation.year = event.year
		    end
		  end
		  if crop_schedule_class_id == 2 then
		    case true
		      when @highest_year > 1 && year.to_i >= @highest_year
		        if event.activity_id == 5 then operation.year = 1 else operation.year = @highest_year end
		      when @highest_year > 1 && year.to_i < @highest_year
		        if event.activity_id == 5 then operation.year = year.to_i + 1 else operation.year = year.to_i end
		    end
		  end
		  if event.crop_schedule_id == 4 && @highest_year > operation.year && operation.activity_id == 5 # ask if corp rotation is winter wheat and the highest year is > than the kill operation. Since the kill is first in the table we need to be sure where to put it.
		    operation.year += 1
		  end
		  @highest_year = operation.year
		  #type_id is used for fertilizer and todo (others. identify). FertilizerTypes 1=commercial 2=manure
		  #note fertilizer id and code are the same so far. Try to keep them that way
		  operation.type_id = 0
		  operation.no3_n = 0
		  operation.po4_p = 0
		  operation.org_n = 0
		  operation.org_p = 0
		  operation.nh3 = 0
		  operation.subtype_id = 0
		  case operation.activity_id
		    when 1 #planting operation. Take planting code from crop table and plant population as well
		      if operation.activity_id == 1 && tillage_id=="" && @crop.lu_number != 28 then  #if no-till is selected the planting code change to 139.
		        operation.type_id = 139
		      else
		        operation.type_id = @crop.planting_code
		      end
		      operation.amount = plant_population
		    when 2, 7  #fertilizer and grazing
		      fertilizer = Fertilizer.find(event.apex_fertilizer) unless event.apex_fertilizer == 0
		      operation.amount = event.apex_opv1
		      if fertilizer != nil then
		        operation.type_id = fertilizer.fertilizer_type_id
		      if operation.type_id == 2 then operation.amount * 1000 end
		        operation.no3_n = fertilizer.qn
		        operation.po4_p = fertilizer.qp
		        operation.org_n = fertilizer.yn
		        operation.org_p = fertilizer.yp
		        operation.nh3 = fertilizer.nh3
		        operation.subtype_id = event.apex_fertilizer
		      end
		    when 3
		      operation.type_id = event.apex_operation
		    else
		      operation.amount = event.apex_opv1
		  end #end case
		  operation.depth = event.apex_opv2
		  operation.scenario_id = scenario_id
		  if operation.save
		    msg = add_soil_operation(operation,0)
		    notice = t('scenario.operation') + " " + t('general.created')
		    unless msg.eql?("OK")
		      raise ActiveRecord::Rollback
		    end
		  else
		    raise ActiveRecord::Rollback
		  end
		end # end events.each
	end

	def add_scenario_to_soils(scenario, soil_resubmit)
		field = Field.find(scenario.field_id)
		soils = field.soils
		i = 0
		total_percentage = soils.sum(:percentage)
		total_selected = soils.count
		soils.each do |soil|
			i+=1
			soil_area = (soil.percentage * field.field_area / 100)
			create_subarea("Soil", i, soil_area, soil.slope, field.field_type, total_selected, field.field_name, scenario.id, soil.id, soil.percentage, total_percentage, field.field_area, 0, 0, false, "create", soil_resubmit)
		end #soils each do end
	end

 ###################################### create_subarea ###################################### 
 ## Create subareas from soils receiving from map for each field and for each scenario ###
	def create_subarea(sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type, soil_resubmit)
		subarea = Subarea.new 
		update_subarea(subarea, sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type, soil_resubmit)
	end

	def update_subarea(subarea, sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type, soil_resubmit)
		rchc_buff = 0.01
		rchk_buff = 0.2
		subarea.scenario_id = scenario_id
		if bmp_id == 0
			subarea.soil_id = soil_id
			subarea.bmp_id = 0
		else
			subarea.bmp_id = bmp_id
			subarea.soil_id = 0
		end
		subarea.subarea_type = sub_type
		subarea.number = 0  # this number should be just included in the simulation because I do not know what soils are selected
		subarea.description = "0000000000000000  .sub file Subbasin:1 " + sub_type + "  Date: " + Time.now.to_s
		#line 2
		subarea.inps = i
		subarea.iops = i
		subarea.iow = 1
		subarea.ii = 0
        subarea.iapl = 0
        subarea.nvcn = 0
        subarea.iwth = 1
        subarea.ipts = 0
        subarea.isao = 0
        subarea.luns = 0
        subarea.imw = 0
		# line 3. get all of the default values from model
		subarea.sno = 0
        subarea.stdo = 0
        subarea.yct = 0
        subarea.xct = 0
        subarea.azm = 0
        subarea.fl = 0
        subarea.fw = 0
        subarea.angl = 0
		#line 4
		subarea.wsa = soil_area * AC_TO_HA
		subarea.chl = 0
		subarea.chl = Math::sqrt(subarea.wsa * 0.01) unless subarea.wsa < 0
		#subarea.wsa *= -1 unless i == 1
        subarea.slp = slope / 100
		subarea.splg = calculate_slope_length(slope)
		subarea.chn = 0
		subarea.upn = 0
		subarea.ffpq = 0
		subarea.chd = 0
		subarea.chs = 0
		subarea.urbf = 0
		if forestry && field_name == SMZ then
			subarea.chn = 0.1
			subarea.upn = 0.24
			subarea.ffpq = FSEFF
		end
		#line 5		
		subarea.rchl = subarea.chl
		subarea.rchl *= 0.9 unless i < total_selected  #just the last subarea is going to have different chl and rchl
		subarea.rchd = 0.0
		subarea.rcbw = 0.0
		subarea.rctw = 0.0
		subarea.rchs = 0.0
		subarea.rchn = 0.0
		subarea.rchc = 0.2
		subarea.rchk = 0.2
		subarea.rfpw = 0.0
		subarea.rfpl = 0.0
		#/line 6
        subarea.rsee = 0.0
        subarea.rsae = 0.0
        subarea.rsve = 0.0
        subarea.rsep = 0.0
        subarea.rsap = 0.0
        subarea.rsvp = 0.0
        subarea.rsv = 0.0
        subarea.rsrr = 0.0
        subarea.rsys = 0.0
        subarea.rsyn = 0.0
        #/line 7
        sLine = subarea.rshc = 0.0
        subarea.rsdp = 0.0
        subarea.rsbd = 0.0
        subarea.pcof = 0.0
        subarea.bcof = 0.0
        subarea.bffl = 0.0
        #/line 8
        subarea.nirr = 0
        subarea.iri = 0
        subarea.ira = 0
        subarea.lm = 1
		subarea.ifd = 0
		# if bmp_id == 0 && bmpsublist_id == 0 && @field.depth != nil
		# 	subarea.idr =  @field.depth.to_f * FT_TO_MM
		# else
		# 	subarea.idr = 0
		# end
		if subarea.soil_id != 0 then
        	subarea.idr = Soil.find(soil_id)[:tile_depth] != nil ? (Soil.find(soil_id)[:tile_depth] * FT_TO_MM).to_i : 0
        else
        	subarea.idr = 0
        end
        subarea.idf1 = 0
        subarea.idf2 = 69
        subarea.idf3 = 2
        subarea.idf4 = 1
        subarea.idf5 = 56
		#/line 9
		subarea.bir = 0
        subarea.efi = 0
		subarea.vimx = 0
        subarea.armn = 0
		subarea.armx = 0
		subarea.bft = 0
        subarea.fnp4 = 0
        subarea.fmx = 0
        subarea.drt = 0
        subarea.fdsf = 0
        #/line 10
        subarea.pec = 0.0
        subarea.dalg = 0.0
        subarea.vlgn = 0.0
        subarea.coww = 0.0
        subarea.ddlg = 0.0
        subarea.solq = 0.0
        subarea.sflg = 0.0
        subarea.fnp2 = 0.0
        subarea.fnp5 = 0.0
        subarea.firg = 0.0
		#line 10
		subarea.pec = 1
		if forestry && field_name == ROAD then
			subarea.pec = 0
		end

		#/line 11
		subarea.ny1 = 1
        subarea.ny2 = 2
        subarea.ny3 = 3
        subarea.ny4 = 4
        subarea.ny5 = 5
        subarea.ny6 = 6
        subarea.ny7 = 7
        subarea.ny8 = 8
        subarea.ny9 = 9
        subarea.ny10 = 10
		#/line 12
		subarea.xtp1 = 0
        subarea.xtp2 = 0
        subarea.xtp3 = 0
        subarea.xtp4 = 0
        subarea.xtp5 = 0
        subarea.xtp6 = 0
        subarea.xtp7 = 0
        subarea.xtp8 = 0
        subarea.xtp9 = 0
        subarea.xtp10 = 0
		buffer_length = field_area   #total Area
		temp_length = Math.sqrt(buffer_length * AC_TO_KM2)
		if soil_resubmit then
			#the default values are going to be overwritten if the addition is a buffer or the bmp modifies the subarea.
			scenario = Scenario.find(scenario_id)
			if scenario != nil then
				scenario.bmps.each do |bmp|
					if [1,2,3,9,11,16,17,18,25].include? bmp.bmpsublist_id
						@bmp = bmp
						update_bmp_information(subarea, soil_id, soil_area, rchc_buff, rchk_buff, scenario_id, temp_length, checker, type, total_selected, soil_percentage, total_percentage)
					end
				end
			end
		else
			#call whatever is comming once
			update_bmp_information(subarea, soil_id, soil_area, rchc_buff, rchk_buff, scenario_id, temp_length, checker, type, total_selected, soil_percentage, total_percentage)
		end

		#this is when the subarea is added from a scenario
		if scenario_id == 0 then
			subarea.ny1 = 0
			subarea.xtp1 = 0.0			
		else
			operations = Operation.where(:scenario_id => scenario_id)
			if operations != nil then
				operations.each do |operation|
					if operation.activity_id == 7 then   #grazing
						subarea.ny1 = 1
						subarea.xtp1 = 0.5
					end  # if operation is grazing 
				end # operations each do
			end #if operations no nill
		end # end if scneario_id == 0
		if subarea.save then

		else
		end
	end

	def update_bmp_information(subarea, soil_id, soil_area, rchc_buff, rchk_buff, scenario_id, temp_length, checker, type, total_selected, soil_percentage, total_percentage)
		if !(@bmp==nil)
			case @bmp.bmpsublist_id
			when 1,2 #autoirrigation / autofertigation
	            case @bmp.irrigation_id
	            when 1
	            	subarea.nirr = 11.0
	            when 2, 7, 8
	                subarea.nirr = 12.0
	            when 3
	                subarea.nirr = 15.0
	            end
	            subarea.vimx = 5000
	            subarea.bir = 0.0
	            subarea.iri = @bmp.days
	            subarea.bir = 1-@bmp.water_stress_factor
	            subarea.efi = @bmp.irrigation_efficiency
	            subarea.armx = @bmp.maximum_single_application * IN_TO_MM	  		      
	      		subarea.fdsf = 0
				subarea.fdsf = @bmp.safety_factor
	            subarea.fnp4 = @bmp.dry_manure * LBS_TO_KG
        		if @bmp.depth == 1 then
        			subarea.idf4 = 0.0
        			subarea.bft = 0.0
        		else
        			subarea.idf4 = 1.0
        			subarea.bft = 0.8
        		end
			when 3  #tile drain
				subarea.idr = @bmp.depth * FT_TO_MM
				subarea.drt = 2
			when 4   #PPDE, PPTW
				if @bmp.depth == 6 || @bmp.depth == 7 then
					#line 2
					subarea.number = 106
					subarea.iops = soil_id
					#subarea.iow = 1
					#line 5
					subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
					#line 4
					subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
					# reduce the area of others subareas proportionally
					update_wsa("-", subarea.wsa)
					subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
					## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
					subarea.chs = subarea.slp
					subarea.slp *= 0.25
					subarea.chn = 0.05
					subarea.upn = 0.41
					subarea.ffpq = 0.8
					#line 5
					subarea.rchd = 0.1
					subarea.rcbw = 0.1
					subarea.rctw = 0.2
					subarea.rchs = subarea.chs
					subarea.rchn = 0.15
					subarea.rchk = 0.01
					#line 6
					subarea.rsee = 0.10
					subarea.rsae = subarea.wsa
					subarea.rsve = 75
					subarea.rsep = 0.1
					subarea.rsap = subarea.wsa
					subarea.rsvp = 25
					subarea.rsrr = 1
					subarea.rsv = 0
					subarea.rsys = 300
					subarea.rsyn = 300
					#line 7
					subarea.rshc = 0.001
					subarea.rsdp = 360
					subarea.rsbd = 0.8
					#line 10
					subarea.pec = 1
				end
			when 8    #Wetlands
				#line 2
				subarea.number = 105
				subarea.iops = soil_id
				#subarea.iow = 1
				#line 5
				subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
				#line 4
				subarea.wsa = soil_area * AC_TO_HA * -1      #soil_area here is the reservior area. Negative on 04/09/18 according to Dr. Saleh
				# reduce the area of others subareas proportionally
				if @bmp.sides == 0 then
					update_wsa("-", subarea.wsa)
				end
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = 0.0025
				subarea.splg = calculate_slope_length(subarea.slp * 100)
				subarea.chs = 0.0
				subarea.chn = 0.0
				subarea.upn = 0.0
				subarea.ffpq = 0.0
				#line 5
				subarea.rchd = 0.0
				subarea.rcbw = 0.0
				subarea.rctw = 0.0
				subarea.rchs = 0.0
				subarea.rchn = 0.0
				subarea.rchc = 0.0
				subarea.rchk = 0.0
				#line 6
				subarea.rsee = 0.31
				subarea.rsae = subarea.wsa.abs #in case the are is negative
				subarea.rsve = 50
				subarea.rsep = 0.3
				subarea.rsap = subarea.wsa.abs * 0.90  # for principal spill way
				subarea.rsvp = 25
				subarea.rsrr = 20
				subarea.rsv = 20
				subarea.rsys = 300
				subarea.rsyn = 300
				#line 7
				subarea.rshc = 0.001
				subarea.rsdp = 360
				subarea.rsbd = 0.8
				#line 10
				subarea.pec = 1
				add_buffer_operation(139, 129, 0, 2000, 0, 33, 2, scenario_id)
			when 9    #Ponds		
				#line 7
				subarea.pcof = @bmp.irrigation_efficiency
			when 10    #Stream Fencing
				#bmp = Bmp.find(bmp_id)
				temp_length = @bmp.depth * FT_TO_KM
				#line 2
				subarea.number = 108
				#subarea.iops = soil_id
				#subarea.iow = 1
				#line 5
				subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
				#line 4
				subarea.wsa = soil_area * AC_TO_HA * -1      #soil_area here is the reservior area. Negative on 04/09/18 according to Dr. Saleh
				# reduce the area of others subareas proportionally
				#if @bmp.sides == 0 then
					update_wsa("-", subarea.wsa)
				#end
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = 0.0025
				subarea.splg = calculate_slope_length(subarea.slp * 100)
				subarea.chs = 0.0
				subarea.chn = 0.1
				subarea.upn = 0.24
				subarea.ffpq = 0.8
				#line 5
				subarea.rchn = 0.1
				subarea.rchc = 0.2
				subarea.rchk = 0.2
                subarea.rfpw = @bmp.width * FT_TO_M
                subarea.rfpl = @bmp.depth * FT_TO_KM
				#subarea.pcof = @bmp.irrigation_efficiency
				#line 10
				subarea.pec = 1
				add_buffer_operation(136, @bmp.crop_id, 0, 1400, 0, 22, 2, scenario_id)
				#add_buffer_operation(139, 129, 0, 2000, 0, 33, 2, scenario_id)
			when 12    #Riperian Forest
			when 13    #Filter Strip and reparian forest
				if @bmp.depth == 12 then
					#create the Riparian Forest buffer
					grass_field_portion = @bmp.grass_field_portion / (@bmp.width + @bmp.grass_field_portion)
					if !checker
						#line 2
						subarea.number = 102
						if @bmp.width > 0 then
							subarea.iops = soil_id + 1
						else
							subarea.iops = soil_id
						end
						#subarea.iow = 1
						#line 5					
						#subarea.rchl = (@bmp.width * FT_TO_KM * (1 - @bmp.grass_field_portion)).round(4)
						if @bmp.width > 0 then
							subarea.rchl = (@bmp.width * FT_TO_KM * grass_field_portion).round(4)
						else
							subarea.rchl = (FT_TO_KM * grass_field_portion).round(4)
						end
						#line 4
						if soil_area != nil
							#s_area = soil_area * AC_TO_HA * (1-@bmp.grass_field_portion)
							fs_area = soil_area * AC_TO_HA * (grass_field_portion)
							subarea.wsa = fs_area       #soil_area here is the reservior area
						else
							subarea.wsa = temp_length * subarea.rchl * KM2_TO_HA      # KM2_TO_HA
							fs_area = subarea.wsa
						end
						if @bmp.sides == 0 then
							update_wsa("-", subarea.wsa)
						end
						subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
						subarea.slp = subarea.slp * @bmp.buffer_slope_upland
						subarea.splg = calculate_slope_length(subarea.slp * 100)
						## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
						subarea.chn = 0.2
						subarea.upn = 0.30
						subarea.ffpq = @bmp.slope_reduction
						#line 5
						rchc_buff = 0.01
						rchk_buff = 0.2
						#subarea.rchl = subarea.rfpl    #soil_area here is the reservior area
						subarea.rchn = 0.1
						subarea.rchc = 0.2 
						subarea.rchk = 0.2 
						if subarea.rchc > 0.01
							subarea.rchc = 0.01
						end
						if subarea.rchc < rchc_buff
							subarea.rchc = rchc_buff
						end
						if subarea.rchk < rchk_buff
							subarea.rchk = rchk_buff
						end
						subarea.rfpw = (subarea.wsa * HA_TO_M2) / (subarea.rchl * KM_TO_M)
						subarea.rfpl = subarea.rchl
						#line 10
						subarea.pec = 1.0
						if @bmp.width > 0 then
							#if type == "create"
								create_subarea("RFFS", 1, soil_area, subarea.slp, false, total_selected, @field.field_name, scenario_id, soil_id, soil_percentage, total_percentage, @field.field_area, @bmp.id, @bmp.bmpsublist_id, true, "create", false)
							#else
								#update_wsa("-", subarea.wsa)
								#update_subarea(subarea, "RFFS", subarea.iops, soil_area, subarea.slp, false, total_selected, @field.field_name, scenario_id, soil_id, soil_percentage, total_percentage, @field.field_area, @bmp.id, @bmp.bmpsublist_id, true, "update", false)
							#end
						end
						add_buffer_operation(139, 79, 350, 1900, -64, 22, 1, scenario_id)
						add_buffer_operation(139, 49, 0, 1400, 0, 22, 1, scenario_id)
					else  # filter strip
						
						#line 2
						subarea.number = 103
						subarea.iops = soil_id
						#subarea.iow = 1
						#line 5
						subarea.rchl = (@bmp.width * FT_TO_KM * (1-grass_field_portion)).round(4)    #soil_area here is the reservior area
						#line 4
						if soil_area != nil
							subarea.wsa = soil_area * AC_TO_HA * (1-grass_field_portion)     #soil_area here is the reservior area
						else
							subarea.wsa = temp_length * subarea.rchl * KM2_TO_HA       # KM2_TO_HA
						end
						#subarea.wsa = subarea.wsa
						if @bmp.sides == 0 then
							update_wsa("-", subarea.wsa)
						end
						subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
						subarea.slp = subarea.slp * @bmp.buffer_slope_upland
						subarea.splg = calculate_slope_length(subarea.slp * 100)
						## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
						subarea.chn = 0.1
						subarea.upn = 0.24
						subarea.ffpq = @bmp.slope_reduction
						#line 5
						rchc_buff = 0.01
						rchk_buff = 0.2
						#subarea.rchl = subarea.rfpl    #soil_area here is the reservior area
						subarea.rchn = 0.1
						subarea.rchc = 0.2 
						subarea.rchk = 0.2 
						if subarea.rchc > 0.01
							subarea.rchc = 0.01
						end
						if subarea.rchc < rchc_buff
							subarea.rchc = rchc_buff
						end
						if subarea.rchk < rchk_buff
							subarea.rchk = rchk_buff
						end
						subarea.rfpw = 0
						subarea.rfpl = 0
						#line 10
						subarea.pec = 1.0
						add_buffer_operation(139, 49, 0, 1400, 0, 22, 2, scenario_id)
					end
				else
					# create the Fileter Strip buffer
					#line 2
					subarea.number = 101
					subarea.iops = soil_id
					#subarea.iow = 1
					#line 5
					subarea.rchl = (@bmp.width * FT_TO_KM).round(4)   #soil_area here is the reservior area
					#line 4
					if soil_area != nil
						temp_length = soil_area * AC_TO_KM2  / subarea.rchl
						subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
					else
						subarea.wsa = temp_length * subarea.rchl * KM2_TO_HA       # KM2_TO_HA
						soil_area = subarea.wsa * HA_TO_AC
					end
					if @bmp.sides == 0 then
						update_wsa("-", subarea.wsa)
					end
					subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
					## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
					subarea.slp = subarea.slp * @bmp.buffer_slope_upland
					subarea.splg = calculate_slope_length(subarea.slp * 100)
					subarea.chs = 0   #was subarea.slp before. Public of NTT is 0.
					subarea.chn = 0.1
					subarea.upn = 0.24
					subarea.ffpq = @bmp.slope_reduction
					#line 5
					subarea.rchn = 0.1
					subarea.rchc = 0.2 #TODO
					subarea.rchk = 0.2 #TODO
					if subarea.rchc > 0.01
						subarea.rchc = 0.01
					end
					if subarea.rchc < rchc_buff
						subarea.rchc = rchc_buff
					end
					if subarea.rchk < rchk_buff
						subarea.rchk = rchk_buff
					end
					#line 10
					subarea.pec = 1.0
					add_buffer_operation(136, Crop.find(@bmp.crop_id).number, 0, 1400, 0, 22, 2, scenario_id)
				end
			when 14    #Waterway
				#line 2
				subarea.number = 104
				subarea.iops = soil_id
				#line 5
				subarea.rchl = (@bmp.width * FT_TO_KM).round(4)   #soil_area here is the reservior area
				#line 4
				if @bmp.grass_field_portion > 0 then
					subarea.wsa = (@bmp.grass_field_portion * FT_TO_KM) * subarea.rchl * 100  #convert length to km and the area to ha.
				else
					subarea.wsa = temp_length * subarea.rchl * 100
				end
				
				update_wsa("-", subarea.wsa)
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = subarea.slp * 0.25
				subarea.splg = calculate_slope_length(subarea.slp * 100)
				subarea.chs = subarea.slp
				subarea.chn = 0.1
				subarea.upn = 0.24
				subarea.ffpq = @bmp.slope_reduction
				#subarea.ffpq = params[:bmp_ww][:floodplain_flow]
				#line 5
				subarea.rchn = 0.1
				subarea.rchc = 0.2 #
				subarea.rchk = 0.2 #
				if subarea.rchc > 0.01
					subarea.rchc = 0.01
				end
				if subarea.rchc < rchc_buff
					subarea.rchc = rchc_buff
				end
				if subarea.rchk < rchk_buff
					subarea.rchk = rchk_buff
				end
                subarea.rfpw = (subarea.wsa * HA_TO_M2) / (subarea.rchl * KM_TO_M)
                subarea.rfpl = subarea.rchl
				#line 10
				subarea.pec = 1.0
				add_buffer_operation(136, Crop.find(@bmp.crop_id).number, 0, 1400, 0, 22, 2, scenario_id)
			when 15    #Contour Buffer

			when 16    # land leveling
				#line 3
				subarea.slp = subarea.slp * (100 - @bmp.slope_reduction) / 100
			when 17    #terrace system
				case subarea.slp
				when 0..0.02
				subarea.pec = 0.6
				when 0.021..0.08
				subarea.pec = 0.5
				when 0.081..0.12
				subarea.pec = 0.6
				when 0.121..0.16
				subarea.pec = 0.7
				when 0.161..0.20
				subarea.pec = 0.8
				when 0.201..0.25
				subarea.pec = 0.9
				else
				subarea.pec = 1.0
				end
			when 23    #Shading
				#line 2
				subarea.number = 101
				subarea.iops = soil_id
				subarea.iow = 1
				#line 5
				subarea.rchl = @bmp.width * FT_TO_KM   #soil_area here is the reservior area
				#line 4
				if soil_area != nil
					temp_length = soil_area * AC_TO_KM2 / subarea.rchl
					subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
				else
					subarea.wsa = temp_length * subarea.rchl * KM2_TO_HA       # KM2_TO_HA
				end
				## updatewsa
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = subarea.slp * @bmp.buffer_slope_upland
				subarea.splg = calculate_slope_length(subarea.slp * 100)
				subarea.chs = subarea.slp
				subarea.chn = 0.1
				subarea.upn = 0.24
				subarea.ffpq = FSEFF
				#line 5
				subarea.rchn = 0.1
				subarea.rchc = 0.2 #TODO
				subarea.rchk = 0.2 #TODO
				if subarea.rchc > 0.01
					subarea.rchc = 0.01
				end
				if subarea.rchc < rchc_buff
					subarea.rchc = rchc_buff
				end
				if subarea.rchk < rchk_buff
					subarea.rchk = rchk_buff
				end
				#line 10
				subarea.pec = 1.0
				add_buffer_operation(136, @bmp.crop_id, 0, 1400, 0, 22, 2, scenario_id)
			end # end bmpsublist_id
		end # end if bmp1 not nil
	end

    def calculate_slope_length(soil_slope)
        slopeLength = 0.0
        case soil_slope.round(4)
        when 0 .. 0.5, 11.0001 .. 12
            slope_length = 100 * FT_TO_M
        when 0.5001 .. 1, 2.0001 .. 3
            slope_length = 200 * FT_TO_M
        when 1.0001 .. 2
            slope_length = 300 * FT_TO_M
        when 3.0001 .. 4
            slope_length = 180 * FT_TO_M
        when 4.0001 .. 5
            slope_length = 160 * FT_TO_M
        when 5.0001 .. 6
            slope_length = 150 * FT_TO_M
        when 6.0001 .. 7
            slope_length = 140 * FT_TO_M
        when 7.0001 .. 8
            slope_length = 130 * FT_TO_M
        when 8.0001 .. 9
            slope_length = 125 * FT_TO_M
        when 9.0001 .. 10
            slope_length = 120 * FT_TO_M
        when 10.0001 .. 11
            slope_length = 110 * FT_TO_M
        when 12.0001 .. 13
            slope_length = 90 * FT_TO_M
        when 13.0001 .. 14
            slope_length = 80 * FT_TO_M
        when 14.0001 .. 15
            slope_length = 70 * FT_TO_M
        when 15.0001 .. 17
            slope_length = 60 * FT_TO_M
        else
            slope_length = 50 * FT_TO_M
        end
        return slope_length
    end

	def update_wsa(operation, wsa)
		soils = @field.soils
		#soils = Soil.where(:field_id => params[:field_id], :selected => true)
		soils.each do |soil|
			subarea = @scenario.subareas.find_by_soil_id(soil.id)
			if operation == "+"
				subarea.wsa += wsa * soil.percentage / 100
			else
				subarea.wsa -= wsa * soil.percentage / 100
			end
			if subarea.save then
				#return "OK"   # if save no problem - cotinue with the next soil
			else
				return "Problem updating subarea area"
			end
		end
		return "OK"
	end

	def add_buffer_operation(oper, crop, years_cult, opv1, opv2, lunum, add_buffer, scenario_id)
		soil_operation = SoilOperation.new
		soil_operation.day = 15
		soil_operation.month = 1
		soil_operation.year = 1
		soil_operation.operation_id = 0
		soil_operation.tractor_id = 0
		soil_operation.apex_crop = crop
		soil_operation.type_id = 0
		soil_operation.opv1 = opv1
		soil_operation.opv2 = opv2
		soil_operation.opv3 = 0
		soil_operation.opv4 = 0
		soil_operation.opv5 = 0
		soil_operation.opv6 = add_buffer   # this is going to control the operation number. used when the bmp has more than one soil_operation. As now just RF. 
		soil_operation.opv7 = 0
		soil_operation.scenario_id = scenario_id
		soil_operation.soil_id = 0
		soil_operation.apex_operation = oper
		soil_operation.bmp_id = @bmp.id
		soil_operation.activity_id = 1
		if soil_operation.save then
			temp = 1
		else
			temp = 0
		end
		#TODO oper.LuNumber = lunum <- visual basic code
	end

	def update_soil_operation(soil_operation, soil_id, operation,carbon)
		soil_operation.activity_id = operation.activity_id
		soil_operation.scenario_id = operation.scenario_id
		soil_operation.operation_id = operation.id
		soil_operation.soil_id = soil_id
		soil_operation.year = operation.year
		soil_operation.month = operation.month_id
		soil_operation.day = operation.day
		case operation.activity_id
		  when 1, 3 #planting, tillage
		    soil_operation.apex_operation = operation.type_id
		    soil_operation.type_id = operation.type_id
		  when 2, 7 #fertilizer, grazing
		    soil_operation.apex_operation = Activity.find(operation.activity_id).apex_code
		    soil_operation.type_id = operation.subtype_id
		  when 4 #Harvest. Take harvest operation from crop table
		  	if @project.version == "Comet" then
		  		soil_operation.apex_operation = operation.type_id
		  	else
		    	soil_operation.apex_operation = Crop.find(operation.crop_id).harvest_code
		    end
		    soil_operation.type_id = operation.subtype_id
		  when 6 #irrigation
		  	soil_operation.apex_operation = Irrigation.find(operation.type_id).code
		  	soil_operation.type_id = operation.type_id
		  else
		    soil_operation.apex_operation = Activity.find(operation.activity_id).apex_code
		    soil_operation.type_id = operation.type_id
		end
		soil_operation.tractor_id = 0
		if operation.crop_id == 0 then
			soil_operation.apex_crop = 0
		else
			soil_operation.apex_crop = Crop.find(operation.crop_id).number
		end
		soil_operation.opv1 = set_opval1(operation)
		soil_operation.opv2 = set_opval2(soil_operation.soil_id, operation)
		soil_operation.opv3 = set_opval3(operation)
		soil_operation.opv4 = set_opval4(operation)
		soil_operation.opv5 = set_opval5(operation)
		soil_operation.opv6 = carbon
		soil_operation.opv7 = 0
		if soil_operation.save
		  return "OK"
		else
		  return soil_operation.errors
		end
	end

	def set_opval5(operation)
	    case operation.activity_id
	      when 1 #planting
	        lu_number = Crop.find(operation.crop_id).lu_number
	        if lu_number != nil then
	          if operation.amount == 0 then
	            if operation.crop_id == Crop_Road then
	              return 0
	            end
	          else
	          	if operation.amount == nil then
	          		operation.amount = 0
	          	end
	            #if operation.amount / FT2_TO_M2 < 1 then
	              #return (operation.amount / FT2_TO_M2).round(6) #plant population converte from ft2 to m2 if it is not tree
	            #else
	              #return (operation.amount / FT2_TO_M2).round(0) #plant population converte from ft2 to m2 if it is not tree
	            #end
	            if lu_number == 28 then
	              return (operation.amount / AC_TO_HA).round(0) #plant population converte from ac to ha if it is tree
		         else
		          return (operation.amount / FT2_TO_M2).round(6) #plant population converte from ft2 to m2 if it is not tree
	            end
	          end
	        end
	      else
	        return 0
	    end #end case
	end

	def set_opval1(operation)
	    opv1 = 1.0
	    case operation.activity_id
	    when 1 #planting take heat units
			#this code will calculate Heat Unist base on location and crop - Was taken back to take from database- Ali 11/2/2016 
	        #client = Savon.client(wsdl: URL_Weather)
	        #response = client.call(:get_hu, message: {"crop" => Crop.find(operation.crop_id).number, "nlat" => Weather.find_by_field_id(params[:field_id]).latitude, "nlon" => Weather.find_by_field_id(params[:field_id]).longitude})
	        #opv1 = response.body[:get_hu_response][:get_hu_result]
			#this code will take Heat Units from database according to Ali 11/2/216
			opv1 = Crop.find(operation.crop_id).heat_units
	      #opv1 = 2.2
	    when 2 #fertilizer - converte amount applied
	      	case operation.type_id
	      	when 1
				opv1 = (operation.amount * LBS_TO_KG / AC_TO_HA).round(2) #kg/ha of fertilizer applied converted from lbs/ac
	        when 2
	        	if operation.moisture == nil then
	        		operation.moisture = Fertilizer.find(operation.subtype_id).dry_matter
	        		operation.save
	        	end
	        	opv1 = (operation.amount * 2247 * (100-operation.moisture)/100).round(2) #Ali's equation on e-mail 11-07-2017
	        when 3
	        	if operation.moisture == nil then
	        		operation.moisture = Fertilizer.find(operation.subtype_id).dry_matter
	        		operation.save
	        	end
	          	opv1 = (operation.amount * 9350 * (100-operation.moisture)/100).round(2) #Ali's equation on e-mail 11-07-2017
	        end
	    when 3  #tillage. be sure opv is zero. Oscar Gallego. 10/16/2020. The opv1 for tillage operation shoudl be zero insted of 1.0
	    	opv1 = 0
	    when 4  #harvest. be sure opv is zero.  Oscar Gallego. 10/16/2020. The opv1 for harvest operation shoudl be zero insted of 1.0
	    	opv1 = 0
	    when 6 #irrigation
	        opv1 = operation.amount * IN_TO_MM #irrigation volume from inches to mm.
	    when 7, 9 #grazing
	    	#since it is grazing just one soil is used. So, the area for that subarea is the total are for the field.
	    	#if @scenario == nil then 
	    		#opv1 = Scenario.find(operation.scenario_id).subareas[0].wsa / operation.amount
	    	#else
	    		#opv1 = @scenario.subareas[0].wsa / operation.amount  #since it is grazing just first subarea is used.
	    	#end
	    	opv1 = @field.field_area * AC_TO_HA / operation.amount
	    when 12 #liming
	        opv1 = operation.amount / LBS_AC_TO_T_HA #converts input lbs/ac to APEX t/ha
	    end
	    return opv1
	end

	def set_opval4(operation)
	    opv4 = 0.0
	    case operation.activity_id
	      when 6 #irrigation efficiency. Converted from % to fraction
	        opv4 = 1 - operation.depth/100 unless operation.depth == nil
	    end
	    return opv4
	end

	def set_opval2(soil_id, operation)
	    opv2 = 0.0
	    case operation.activity_id
	      when 1 #planting. Take curve number
	        case Soil.find(soil_id).group[0, 1]  #group could be like C/D. [0, 1] will take just C.
	          when "A"
	            opv2 = Crop.find(operation.crop_id).soil_group_a
	          when "B"
	            opv2 = Crop.find(operation.crop_id).soil_group_b
	          when "C"
	            opv2 = Crop.find(operation.crop_id).soil_group_c
	          when "D"
	            opv2 = Crop.find(operation.crop_id).soil_group_d
	        end #end case Soil
	        if opv2 > 0 then
	          opv2 = opv2 * -1
	        end
	      when 2 #fertilizer - convert depth
	        opv2 = operation.depth * IN_TO_MM unless operation.depth == nil
	    end #end case operation
	    return opv2
	end #end set_opval2

	def set_opval3(operation)
		if operation.moisture == nil then operation.moisture = 0 end
		opv3 = 0
		if operation.amount == 0 then
			opv3 = operation.moisture
			if opv3 >= 0.00 then 
				opv3 = 1 - opv3
			end
			if opv3 == 1 then opv3 = 0.95 end
		end
		return opv3
	end

	def calculate_centroid(coordinates)
	    #https://en.wikipedia.org/wiki/Centroid.
	    centroid_structure = Struct.new(:cy, :cx)
	    centroid = centroid_structure.new(0.0, 0.0)
	    points = coordinates.split(" ")
	    i=0

	    points.each do |point|
	      i+=1
	      centroid.cx += point.split(",")[0].to_f
	      centroid.cy += point.split(",")[1].to_f
	    end
	    centroid.cx = centroid.cx / (i)
	    centroid.cy = centroid.cy / (i)
	    return centroid
	end

	def add_soil_operation(operation,carbon)
	    #@project = Project.find(params[:project_id])
	    #@field = Field.find(params[:field_id])
	    #@scenario = Scenario.find(params[:scenario_id])
	    soils = @field.soils
	    #soils = Soil.where(:field_id => Scenario.find(@operation.scenario_id).field_id)
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



	def request_soils()
		#  def get_soils_nrcs
		#	url_soils = "https://sdmdataaccess.sc.egov.usda.gov/Tabular/SDMTabularService.asmx?WSDL"
		#	req = "SELECT hydgrp as horizdesc2,compname as seriesname,albedodry_r as albedo,comppct_r as compct,sandtotal_r as sand,silttotal_r as silt, 100-sandtotal_r-silttotal_r as clay, dbthirdbar_r as bd,om_r as om,texdesc as texture,ph1to1h2o_r as ph,hzdepb_r as ldep,drainagecl as horizgen,ecec_r as cec,muname, slope_r FROM sacatalog sac INNER JOIN legend l ON l.areasymbol = sac.areasymbol AND l.areatypename = 'Non-MLRA Soil Survey Area' INNER JOIN mapunit mu ON mu.lkey = l.lkey LEFT OUTER JOIN component c ON c.mukey = mu.mukey LEFT OUTER JOIN chorizon ch ON ch.cokey = c.cokey LEFT OUTER JOIN chtexturegrp chtgrp ON chtgrp.chkey = ch.chkey LEFT OUTER JOIN chtexture cht ON cht.chtgkey = chtgrp.chtgkey LEFT OUTER JOIN chtexturemod chtmod ON chtmod.chtkey = cht.chtkey WHERE l.areasymbol='TX143' AND mu.mukey='365419' AND musym='WoC' AND hydgrp<>'' AND hzdepb_r <> '' ORDER BY mu.mukey, compname, hzdepb_r"
		#	client = Savon.client(wsdl: url_soils)
		#	response = client.call(:run_query, message: {"Query" => req})
		#	msg = response.body[:run_query_response][:run_query_result][:diffgram][:new_data_set][:table]
		#  end
	  	#soil1 = "AL001"
	 	#soil2 = "328057"
	 	#soil3 = "AaB"
	 	#sql = "SELECT "
	   #sql = sql + "hydgrp as horizdesc2,compname as seriesname,albedodry_r as albedo,comppct_r as compct," 
	   #sql = sql + "sandtotal_r as sand, silttotal_r as silt, 100-(sandtotal_r+silttotal_r) as clay, dbthirdbar_r as bd,om_r as om,"
	   #sql = sql + "texdesc as texture,ph1to1h2o_r as ph,hzdepb_r as ldep,drainagecl as horizgen,ecec_r as cec, muname, slope_r"
	   #sql = sql + "FROM sacatalog sac "
	   #sql = sql + "INNER JOIN legend l ON l.areasymbol = sac.areasymbol AND l.areatypename = 'Non-MLRA Soil Survey Area' "
	   #sql = sql + "INNER JOIN mapunit mu ON mu.lkey = l.lkey "
	   #sql = sql + "LEFT OUTER JOIN component c ON c.mukey = mu.mukey "
	   #sql = sql + "LEFT OUTER JOIN chorizon ch ON ch.cokey = c.cokey "
	   #sql = sql + "LEFT OUTER JOIN chtexturegrp chtgrp ON chtgrp.chkey = ch.chkey "
	   #sql = sql + "LEFT OUTER JOIN chtexture cht ON cht.chtgkey = chtgrp.chtgkey "
	   #sql = sql + "LEFT OUTER JOIN chtexturemod chtmod ON chtmod.chtkey = cht.chtkey "
	   #sql = sql + "WHERE l.areasymbol='" + soil1 + "' AND mu.mukey='" + soil2 + "' AND musym='" + soil3 + "' AND hydgrp<>'' "
	   #sql = sql + "ORDER BY mu.mukey, compname, hzdepb_r"
	   #sql = "SELECT mukey FROM mapunit WHERE mukey = 328057"
	    #client = Savon.client(wsdl: URL_NRCS)
	 	#response = client.call(:send_soils, message: {"county" => County.find(@project.location.county_id).county_state_code, "state" => State.find(@project.location.state_id).state_name, "field_coor" => @field.coordinates.strip, "session" => session[:session_id], "outputFolder" => APEX_FOLDER + "/APEX" + session[:session_id]})
	 	#response = client.call(:run_query, message: { "query" => sql })
	 	#another test
	    client = Savon.client(wsdl: URL_SoilsInfo, read_timeout: 500)
	 	#response = client.call(:send_soils, message: {"county" => County.find(@project.location.county_id).county_state_code, "state" => State.find(@project.location.state_id).state_name, "field_coor" => @field.coordinates.strip, "session" => session[:session_id], "outputFolder" => APEX_FOLDER + "/APEX" + session[:session_id]})
	 	response = client.call(:send_soils1, message: {"county" => County.find(@project.location.county_id).county_state_code, "state" => State.find(@project.location.state_id).state_name, "field_coor" => @field.coordinates.strip, "session" => session[:session_id], "outputFolder" => session[:session_id]})
	    if !(response.body[:send_soils1_response][:send_soils1_result].downcase.include? "error") then
	      msg = "OK"
	      msg = create_new_soils(YAML.load(response.body[:send_soils1_response][:send_soils1_result]))
	      return msg
	    else
	      return response.body[:send_soils1_response][:send_soils1_result]
	    end
	end

	###################################### create_soil ######################################
	## Create soils receiving from map for each field.
	def create_new_soils(data)
	    msg = "OK"
	    #delete all of the soils for this field
	    soils1 = @field.soils.destroy_all
	    #soils1.destroy_all #will delete Subareas and SoilOperations linked to these soils
	    total_percentage = 0

	    if data.include? "Error" or data.include? "error"
	      	return t('notices.no_soils')
	    end
	    data.each do |soil|
	      #todo check for erros to soils level as well as layers level.
	      if soil[0] == "soils" || soil[1]["lay_number"] == 0 then
	        next
	      end #
	      @soil = @field.soils.new
	      @soil.key =  soil[1]["mukey"]
	      @soil.symbol = soil[1]["musym"]
	      @soil.group = soil[1]["hydgrpdcd"]
	      @soil.name = soil[1]["muname"]
	      @soil.albedo = soil[1]["albedo"]
	      @soil.slope = soil[1]["slope"]
	      if @soil.slope == 0 then
	        @soil.slope = 0.01
	        msg = t('soil.no_slope_msg')
	      end
	      @soil.percentage = soil[1]["pct"]
	      @soil.percentage = @soil.percentage.round(2)
	      @soil.drainage_id = soil[1]["drain"]
	      @soil.tsla = 10
	      @soil.xids = 1
	      @soil.wtmn = 0
	      @soil.wtbl = 0
	      @soil.ztk = 1
	      @soil.zqt = 2
	      if @soil.drainage_id != nil then
	        case true
	          when 1
	            @soil.wtmx = 0
	          when 2
	            @soil.wtmx = 4
	            @soil.wtmn = 1
	            @soil.wtbl = 2
	          when 3
	            @soil.wtmx = 4
	            @soil.wtmn = 1
	            @soil.wtbl = 2
	          else
	            @soil.wtmx = 0
	        end
	      end

	      if @soil.save then
	        msg = create_layers(soil[1])
	      else
	        msg = "Soils was not saved " + @soil.name
	      end
	    end #end for create_soils
	    soils = @field.soils.order(percentage: :desc)

	    i=1
	    soils.each do |soil|
	      if (i <= 3) then
	        soil.selected = true
	        soil.save
	      end
	      i+=1
	    end
	    scenarios = Scenario.where(:field_id => @field.id)
	    scenarios.each do |scenario|
	      add_scenario_to_soils(scenario, true)
	      operations = Operation.where(:scenario_id => scenario.id)
	      operations.each do |operation|
	        soils.each do |soil|
	          update_soil_operation(SoilOperation.new, soil.id, operation,0)
	        end # end soils each
	      end # end operations.each
	      ### if there is contour buffer BMP the subareas need to be added. for each scenario
	      @bmp = scenario.bmps.find_by_bmpsublist_id(15) 
	      if @bmp != nil then
	      	#call subroutine to add the subareas for CB
	      	add_cb(scenario)
	      end
	    end #end Scenario each do
	    @field.field_average_slope = @field.soils.average(:slope)
	    @field.updated = false
	    if @field.save then
	    	return msg
	    else
	    	return "Error saving soils"
	    end
	end

	###################################### create_soil layers ######################################
	### if there is contour buffer BMP the subareas need to be added. for each scenario ###
	def add_cb(scenario)
	    total_width = @bmp.width + @bmp.crop_width
	    total_strips = ((@field.field_area * AC_TO_HA * 10000) / (total_width * FT_TO_MM)).to_i
	    buffer_area = @bmp.width / total_width 
	    crop_area = @bmp.crop_width / total_width 
	    if total_strips > MAX_STRIPS then total_strips = MAX_STRIPS end
	    subareas = scenario.subareas
	    number = subareas.count + 1
	    iops = subareas[subareas.count-1].iops + 1
	    inps = subareas[subareas.count-1].inps + 1
	    iow = subareas[subareas.count-1].iow + 1
	    areas = Array.new
	    iops = 0
	    crop = Crop.find(@bmp.crop_id)
	    add_buffer_operation(139, crop.number, 0, crop.heat_units, 0, 33, 2, scenario.id)
	    (total_strips*2).times do |i|
	      j=0
	      subareas.each do |s|
	        if i == 0 then  # update the current subareas. And save the initial areas in an array to calculate further areas.
	          areas[j] = s.wsa
	          s.rchl = s.chl
	          s.wsa = s.wsa / total_strips * crop_area
	          if j > 0 && s.wsa > 0 then
	            s.wsa *= -1
	          end
	          s.save
	          j += 1
	          iops = s.iops
	        else
	          s_new = s.dup
	          s_new.rchl = s_new.chl
	          s_new.number = number
	          number += 1
	          #s_new.iops = iops
	          #s_new.inps = inps
	          #s_new.iow = iow
	          s_new.subarea_type = "CB"
	          #if s_new.chl == s_new.rchl then
	            #s_new.rchl *= 0.90
	          #end
	          s_new.bmp_id = @bmp.id
	          if i.even? then
	            s_new.wsa = areas[j] / total_strips * crop_area
	            s_new.description = "0000000000000000  .sub Contour Main Crop Strip"
	            s_new.wsa *= -1
	          else
	            s_new.wsa = areas[j] / total_strips * buffer_area
	            s_new.description = "0000000000000000  .sub Contour Buffer Grass Strip"
	            s_new.iops = iops + 1
	            if j > 0 then
	              s_new.wsa *= -1
	            else
	              s_new.rchl = s_new.chl * 0.9
	            end
	          end
	          j += 1
	          s_new.save
	        end
	      end
	    end
	end

	###################################### create_soil layers ######################################
	## Create layers receiving from map for each soil.
	def create_layers(layers)
	  	if layers == nil then return t('notices.no_layers') end
	  	layer_number = 0
	  	depth = 0
	    #define an inner function to add crops results to crops_data including the last year.
	    add_layer = ->() {
	      layer = @soil.layers.new
	      layer.sand = layers[layer_number]["sand"]
	      layer.silt = layers[layer_number]["silt"]
	      layer.clay = 100 - layer.sand - layer.silt
	      layer.bulk_density = layers[layer_number]["bd"]
	      layer.organic_matter = layers[layer_number]["om"]
	      if layer.organic_matter < 0.5 then 
	      	layer.organic_matter = 0.5
	      end
	      layer.ph = layers[layer_number]["ph"]
	      layer.depth = depth
	      #layer.depth = (layers[layer_number]["depth"].to_f / IN_TO_CM).round(2)
	      #layer.depth /= IN_TO_CM
	      #layer.depth = layer.depth.round(2)
	      layer.cec = layers[layer_number]["cec"]
	      layer.soil_p = 0
	      if layer.save then
	        return "OK"
	      else
	        return "Error saving some layers"
	      end
	    }
	    for l in 1..layers["lay_number"].to_i
	      layer_number = "layer" + l.to_s
	      depth = (layers[layer_number]["depth"].to_f / IN_TO_CM).round(2)
	      msg = add_layer.call
	    end #end for create_layers
	    #If last soil layer is less than 1.75 m a new layer is added at 2 m depth. for now it is only in dev. Oscar Gallego 1/13/21
	    if request.url.include? "ntt.bk" or request.url.include? "localhost" then
		    if (layers[layer_number]["depth"].to_f / 100).round(3) < 1.75 then
		    	depth = 78.74
		    	msg = add_layer.call
		    end
		end
	    return msg
	end

	def get_weather_file_name(lat, lon)
		times = 1.0
		@station = nil
		while @station == nil and times <= 3.0
			lat_less = lat - LAT_DIF * times
			lat_plus = lat + LAT_DIF * times
			lon_less = lon - LON_DIF * times
			lon_plus = lon + LON_DIF * times
			sql = "SELECT lat,lon,file_name,(lat-" + lat.to_s + ") + (lon + " + lon.to_s + ") as distance, final_year, initial_year"
			sql = sql + " FROM stations"
			sql = sql + " WHERE lat > " + lat_less.to_s + " and lat < " + lat_plus.to_s + " and lon > " + lon_less.to_s + " and lon < " + lon_plus.to_s  
			sql = sql + " ORDER BY distance"
			@station = Station.find_by_sql(sql).first
			times = times + 0.5
		end 
		#replace in order to have the same rutin from NTT than from other interfaces such as SEC, TFT, and CSU. Oscar Gallego 1/7/21
	  	#lat_less = lat - LAT_DIF
		#lat_plus = lat + LAT_DIF
		#lon_less = lon - LON_DIF
		#lon_plus = lon + LON_DIF
		#sql = "SELECT lat,lon,file_name,(lat-" + lat.to_s + ") + (lon + " + lon.to_s + ") as distance, final_year, initial_year"
		#sql = sql + " FROM stations"
		#sql = sql + " WHERE lat > " + lat_less.to_s + " and lat < " + lat_plus.to_s + " and lon > " + lon_less.to_s + " and lon < " + lon_plus.to_s  
		#sql = sql + " ORDER BY distance"
		#station = Station.find_by_sql(sql).first
		if @station != nil
			return @station.file_name + "," + @station.initial_year.to_s + "," + (@station.final_year + 1).to_s
		else
			return "Error saving weather file name"
		end
	    #client = Savon.client(wsdl: URL_SoilsInfo)
	    ###### create control, param, site, and weather files ########
	    #response = client.call(:get_weather_file_name, message: {"nlat" => lat, "nlon" => lon})
	    #if response.body[:get_weather_file_name_response][:get_weather_file_name_result].include? ".wth" then
	      #return response.body[:get_weather_file_name_response][:get_weather_file_name_result]
	    #else
	      #return "Error" + response.body[:get_weather_file_name_response][:get_weather_file_name_result]
	    #end
	end

	################################  Save Prism data #################################
	# GET /weathers/1
	# GET /weathers/1.json
  	def save_prism(coordinates)
  		if coordinates != "" then
		    #calcualte centroid to be able to find out the weather information. Field coordinates will be needed, so it will be using field.coordinates
		    centroid = calculate_centroid(coordinates)
		    @weather.latitude = centroid.cy
		    @weather.longitude = centroid.cx
		end
	    weather_data = get_weather_file_name(@weather.latitude, @weather.longitude)
	    if !(weather_data.include? "Error")
		    data = weather_data.split(",")
		    @weather.weather_file = data[0]
		    if @weather.weather_file == nil then @weather.weather_file = "" end
		    data[2].slice! "\r\n"
		    @weather.simulation_final_year = data[2]
		    if @weather.simulation_final_year == nil then @weather.simulation_final_year=0 end
		    @weather.weather_final_year = @weather.simulation_final_year
		    @weather.weather_initial_year = data[1]
		    if @weather.weather_initial_year == nil then @weather.weather_initial_year == 0 end
		    @weather.simulation_initial_year = @weather.weather_initial_year + 5
		    @weather.way_id = 1
		else
			if @weather.weather_file == nil then @weather.weather_file = "" end
			if @weather.simulation_final_year == nil then @weather.simulation_final_year = 0 end
			if @weather.weather_initial_year == nil then @weather.weather_initial_year = 0 end
			if @weather.weather_final_year == nil then @weather.weather_final_year = 0 end
			if @weather.simulation_initial_year == nil then @weather.simulation_initial_year = 0 end
		end
	    if @weather.save
	      return "OK"
	    else
	      retunr t('notices.no_weather_file')
	    end
	end

	def calculate_nutrients(total_n_con, moisture, total_p_con, activity_id, type_id, subtype_id)
	    if activity_id == "2" && type_id != "1"
	      if type_id == "2" #solid manure
	        total_n = (total_n_con/2000)/((100-moisture)/100)
	        total_p = ((total_p_con*PO4_TO_P2O5)/2000)/((100-moisture)/100)
	      elsif type_id == "3" #liquid manure
	        total_n = (total_n_con*0.011982)/(100-moisture)
	        total_p = (total_p_con*PO4_TO_P2O5*0.011982)/(100-moisture)
	      end
	      fert_type = Fertilizer.find(subtype_id)
	      params[:operation][:no3_n] = total_n * fert_type.qn * 100  #convert fraction to percentage. When fert line is being changed (simuilation_helper/add_operation)
	      params[:operation][:org_n] = total_n * fert_type.yn * 100
	      params[:operation][:po4_p] = total_p * fert_type.qp * 100
	      params[:operation][:org_p] = total_p * fert_type.yp * 100
	    end
  	end
end
