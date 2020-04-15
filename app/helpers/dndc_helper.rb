module DndcHelper
	def texture
		[
			["sandy clay loam",6],["silty clay loam",7],["loamy sand",2],["sandy loam",3],["sandy clay",9],
			["silt loam",4],["clay loam",8],["silty clay",10], ["sand",1], ["loam",5], ["silt",12], ["clay",11]
		]
	end

	def land_use
		[
			["3",1]

		]
	end

	def line(u_l_t, des, value)
		len = value.length + des.length + u_l_t
		return "_" * u_l_t + des + " " * (71-len) + value + "*"
	end

	def input_parameters
		####DNDC_Input_Parameters
		year_sim = @project.apex_controls.find_by_control_description_id(1).value
		dndc_string = "DNDC_Input_Parameters" + "*"
		dndc_string += "-" * 40 + "*"
		dndc_string += "Site_information" + "*" + "*"
		dndc_string += line(2, "Site_name", @project.name.delete(' ')) 
		dndc_string += line(2, "Simulated_years",sprintf("%d",year_sim))
		dndc_string += line(2,"Latitude",@field.site.ylat.to_s)
		dndc_string += line(2,"Daily_Record","0")
		dndc_string += line(2,"Unit_system","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		####Climate_data
		dndc_string += "-" * 40 + "*"
		dndc_string += "Climate_data" + "*" + "*"
		dndc_string += line(2,"Climate_data_type","1")		#todo check 0,1,2, or 3
		dndc_string += line(2,"N_in_rainfall",sprintf("%.4f",@project.apex_controls.find_by_control_description_id(39).value))
		dndc_string += line(2,"Air_NH3_concentration","0.0600")
		dndc_string += line(2,"Air_CO2_concentration",sprintf("%.4f",@project.apex_controls.find_by_control_description_id(40).value))
		dndc_string += line(2,"Climate_files",sprintf("%d",year_sim))
		for i in 1..year_sim
			dndc_string += sprintf("%4d", i) + "   D:\\NTTHTML5Files\\DNDC" + session[:session_id] + "\\wth_" + i.to_s + ".txt" + "*"
		end
		dndc_string += line(2,"Climate_file_mode","0")
		dndc_string += line(2,"CO2_increase_rate","0.000000")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		####Soil_data
		dndc_string += "-" * 40 + "*"
		dndc_string += "Soil_data" + "*" + "*"
		#find lanbd use 
		crop = Crop.find(@scenario.operations[0].crop_id)
		land_use = "1"
		case crop.lu_number
			when 2..19		#crops
				land_use = "1" 
			when 20,25,26,34	#grasses
				land_use = "3"
			when 27,28,29
				land_use = "6"	#trees
		end
		if crop.code = "RICE" then land_use = "2" end
		dndc_string += line(2,"Landuse_use_ID",sprintf("%d",land_use))
		#find the soil texture
		soil_texture = 0
		texture.each do |txt|
			if @field.soils[0].name.include? txt[0] then
				soil_texture = txt[1] 
				break
			end
		end
		dndc_string += line(2,"Soil_Texture_ID",sprintf("%d",soil_texture))
		#select the first layer of the first soil
		soil_layer = @field.soils[0].layers[0]
		dndc_string += line(2,"Bulk_density",sprintf("%.4f",soil_layer.bulk_density))
		dndc_string += line(2,"pH",sprintf("%.5f",soil_layer.ph))
		dndc_string += line(2,"Clay_fraction",sprintf("%.5f", soil_layer.clay/100))
		dndc_string += line(2,"Porosity","0.4760")
		dndc_string += line(2,"Bypass_flow","0.00000")
		dndc_string += line(2,"Field_capacity","0.5700") 
		dndc_string += line(2,"Wilting_point","0.2700")
		dndc_string += line(2,"Hydro_conductivity","0.0150")
		dndc_string += line(2,"Top_layer_SOC","0.48500") 
		dndc_string += line(2,"Litter_fraction","0.10000")
		dndc_string += line(2,"Humads_fraction","0.0353")
		dndc_string += line(2,"Humus_fraction","0.9547")
		dndc_string += line(2,"Adjusted_litter_factor","1.0000")
		dndc_string += line(2,"Adjusted_humads_factor","1.0000")
		dndc_string += line(2,"Adjusted_humus_factor","1.0000")
		dndc_string += line(2,"Humads_C/N","10.0000") 
		dndc_string += line(2,"Humus_C/N","10.0000")
		dndc_string += line(2,"Black_C","0.0000")
		dndc_string += line(2,"Black_C_C/N","500.0000")
		dndc_string += line(2,"SOC_profile_A","0.0800")
		dndc_string += line(2,"SOC_profile_B","1.4000")
		dndc_string += line(2,"Initial_nitrate_ppm","0.5000")
		dndc_string += line(2,"Initial_ammonium_ppm","0.0500")
		dndc_string += line(2,"Soil_microbial_index","1.0000")
		dndc_string += line(2,"Soil_slope",sprintf("%.4f",@field.soils[0].slope))
		dndc_string += line(2,"Lateral_influx_index","1.0000")
		dndc_string += line(2,"Watertable_depth","1.0000")
		dndc_string += line(2,"Water_retension_layer_depth","9.9900")
		dndc_string += line(2,"Soil_salinity","0.0000")
		dndc_string += line(2,"SCS_curve_use","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		dndc_string += line(2,"None","0")
		####Crop_data
		dndc_string += "-" * 40  + "*"
		dndc_string += "Crop_data" + "*" + "*"
		all_rotations = @scenario.operations.distinct.pluck(:rotation)
		dndc_string += line(0,"Cropping_systems",sprintf("%d",all_rotations.count)) + "*"
		for rot in 0..all_rotations.count - 1
			dndc_string += line(2,"Cropping_system", sprintf("%d",rot+1))   #number of current rotations (i.e. 2 Corn and Soyb)
			dndc_string += line(2,"Total_years", sprintf("%d",year_sim/all_rotations.count))		#number of years to simulate  current rotation (total years / # of rotations). Total years = simulated years
			all_years = @scenario.operations.where(:rotation => all_rotations[rot]).distinct.pluck(:year)
			dndc_string += line(2,"Years_of_a_cycle", sprintf("%d",all_years.count)) + "*"	# number of years for the current rotation (1 for corn and 1 for soyb)
			for year in 0..all_years.count - 1
				dndc_string += line(4,"Year",sprintf("%d",year + 1))
				all_crops = @scenario.operations.where(:rotation => all_rotations[rot], :year => all_years[year]).distinct.pluck(:crop_id)
				dndc_string += line(4,"Crops",sprintf("%d",all_crops.count))
				for crop in 0..all_crops.count - 1
					operations = @scenario.operations.where(:rotation => all_rotations[rot], :year => all_years[year], :crop_id => all_crops[crop]).order(:month_id, :day)
					dndc_string += line(6,"Crop#{}",sprintf("%d",crop + 1))
					dndc_string += get_crop_info(operations)		
				end
			end
		end
		msg = send_file_to_DNDC(dndc_string, @project.name.delete(" ") + ".dnd", County.find(@project.location.county_id).county_state_code[0,2])
		return msg
	end

	def get_crop_info(operations)
		planting = Array.new
		fertilizer = Array.new
		manure = Array.new
		tillage = Array.new
		tillage[0] = 0
		fertilizer[0] = 0
		manure[0] = 0
		irrigation = Array.new
		irrigation[0] = 0
		grazing = Array.new
		grazing[0] = 0
		operations.each do |oper|
			crop_ant = oper.crop_id
			case oper.activity_id
				when 1	#planting
					planting[0] = Crop.find(oper.crop_id).dndc.to_s
					planting[1] = oper.month_id.to_s
					planting[2] = oper.day.to_s
				when 2 	#fertilizer
					fert_method = 0
					if oper.type_id == 1 then	#comercial fert
						fertilizer[0] += 1
						if oper.depth > 0 then fert_method = 1 end 	#surface or injected(0,1 method)
						fertilizer.push(fertilizer[0].to_s + "," + oper.month_id.to_s + "," + oper.day.to_s + "," + fert_method.to_s + "," + oper.depth.to_s + "," + (oper.amount * oper.no3_n / 100).to_s + "," + (oper.amount * oper.po4_p / 100).to_s)
					else						#manure application. todo calculate amount accordingly
						manure[0] += 1
						if oper.type_id == 2	#solid manure
							manure_C_N = 13
							manure_type = 1
						else	# liquid amnure
							manure_C_N = 5
							manure_type = 4
						end
						if oper.depth > 0 then fert_method = 1 end 	#surface or injected(0,1 method)
						manure.push(manure[0].to_s + "," + oper.month_id.to_s + "," + oper.day.to_s + "," + oper.amount.to_s + "," + manure_C_N.to_s + "," + manure_type.to_s + "," + fert_method.to_s + "," + oper.depth.to_s + "," + (oper.amount * oper.no3_n * 100).to_s + "'" + (oper.amount * oper.org_n * 100).to_s) 
					end
				when 3 	#Tillage
					tillage[0] += 1
					tillage.push(tillage[0].to_s + "," + oper.month_id.to_s + "," + "0" + "'" + Tillage.find_by_code(oper.type_id).dndc)
				when 4	#harvest
					planting[3] = oper.month_id.to_s
					planting[4] = oper.day.to_s
					planting[5] = oper.year.to_s
				when 5	#kill
				when 6	#irrigation
					irrigation[0] += 1	#todo check amount of irrigation.
					case oper.type_id
						when 1
							irrigation_method = 1
						when 2, 7
							irrigation_method = 0
						when 3
							irrigation_method = 2
					end
					irrigation.push(irrigation[0].to_s + "," + oper.month_id.to_s + "," + oper.day.to_s + "," + oper.amount.to_s + "," + irrigation_method.to_s)
				when 7	#grazing continues
					grazing[0] += 1
					oper_end_grazing = Operation.find_by_type_id(oper.id)
					dairy = 0
					beef = 0
					sheep = 0
					horse = 0 
					pig = 0
					heads_per_ha = oper.amount / (@field.field_area * AC_TO_HA)
					case oper.type_id
						when 43
							dairy = heads_per_ha
						when 44
							beef = heads_per_ha
						when 46
							pig = heads_per_ha
						when 47, 48 
							sheep = heads_per_ha
						when 49
							horse = heads_per_ha
					end
					grazing.push(grazing[0].to_s + "," + oper.month_id.to_s + "," + oper.day.to_s + "," + oper_end_grazing.month_id.to_s + "," + oper_end_grazing.day.to_s + "," + sprintf("%.4f",oper.depth) + "," + sprintf("%.4f",dairy) + "," + sprintf("%.4f",beef) + "," + sprintf("%.4f",sheep) + "," + sprintf("%.4f",horse) + "," + sprintf("%.4f",pig))
				when 9	#rotation grazing
				when 11	#burn
				when 12 #liming	
			end
		end
		#1. print planting. Todo check what other values are possible to take from crop table
		#todo check crops code APEX vs dndc
		crop_string = line(6,"Crop_ID",planting[0])	#crop id
        crop_string += line(6,"Planting_month",planting[1])	#planting month
        crop_string += line(6,"Planting_day",planting[2])	#planting day
        crop_string += line(6,"Harvest_month",planting[3])
        crop_string += line(6,"Harvest_day",planting[4])
        crop_string += line(6,"Harvest_year",planting[5])
        crop_string += line(6,"Residue_left_in_field","1.0000")
        crop_string += line(6,"Maximum_yield","186.6600")
        crop_string += line(6,"Leaf_fraction","0.3500")	
        crop_string += line(6,"Stem_fraction","0.3500")	
        crop_string += line(6,"Root_fraction","0.2800")	
        crop_string += line(6,"Grain_fraction","0.0200")	
        crop_string += line(6,"Leaf_CN","55.0000")	
        crop_string += line(6,"Stem_CN","55.0000")	
        crop_string += line(6,"Root_CN","50.0000")	
        crop_string += line(6,"Grain_CN","35.0000")	
        crop_string += line(6,"Accumulative_temperature","2000.0000")	
        crop_string += line(6,"Optimum_temperature","15.0000")	
        crop_string += line(6,"Water_requirement","2.0000")	
        crop_string += line(6,"N_fixation_index","0.0000")	
        crop_string += line(6,"If_cover_crop","0.0000")	
        crop_string += line(6,"If_perennial_crop ","1.0000")	
        crop_string += line(6,"If_transplanted ","0.0000")	
        crop_string += line(6,"Tree_maturity_age ","0.0000")	
        crop_string += line(6,"Tree_current_age ","0.0000")	
        crop_string += line(6,"Tree_max_leaf ","0.0000")	
        crop_string += line(6,"Tree_min_leaf  ","0.0000")
    	crop_string += line(6,"None","0")
		crop_string += line(6,"None","0")
		crop_string += line(6,"None","0")
		crop_string += line(6,"None","0")
		crop_string += line(6,"None","0")
	    #2. print tillages. todo check till code APEX vs dndc
        tillage_string = "-" * 40 + "*"
		tillage_string += line(4,"Tillage_applications",tillage[0].to_s)
		for j in 1..tillage.count-1
			till = tillage[j].split(",")
			tillage_string += line(6,"Till#",till[0])
			tillage_string += line(6,"Till_month",till[1])
    		tillage_string += line(6,"Till_day",till[2])
    		tillage_string += line(6,"Till_method", till[3])
		end
		#3. print fertilizer applications. todo check fert code APEX vs dndc
		fertilizer_string = "-" * 40 + "*"
		fertilizer_string += line(4,"Fertilizer_applications",fertilizer[0].to_s)
		for j in 1..fertilizer.count-1
			fert = fertilizer[j].split(",")
			fertilizer_string += line(6,"Fertilizing#",fert[0])
			fertilizer_string += line(6,"Fertilizing_month",fert[1])
    		fertilizer_string += line(6,"Fertilizing_day",fert[2])
    		fertilizer_string += line(6,"Fertilizing_method", fert[3])
    		fertilizer_string += line(6,"Fertilizing_depth", fert[4])
    		fertilizer_string += line(6,"Nitrate", fert[5])
   			fertilizer_string += line(6,"Ammonium_bicarbonate", "0.0000")
    		fertilizer_string += line(6,"Urea", "0.0000")
    		fertilizer_string += line(6,"Anhydrous_ammonia", "0.0000")
    		fertilizer_string += line(6,"Ammonium", "0.0000")
    		fertilizer_string += line(6,"Sulphate", "0.0000")
    		fertilizer_string += line(6,"Phosphate", fert[6])
    		fertilizer_string += line(6,"Slow_release_rate", "1.0000")
    		fertilizer_string += line(6,"Nitrification_inhibitor_efficiency", "0.0000")
    		fertilizer_string += line(6,"Nitrification_inhibitor_duration", "0.0000")
    		fertilizer_string += line(6,"Urease_inhibitor_efficiency ", "0.0000")
    		fertilizer_string += line(6,"Urease_inhibitor_duration", "0.0000")
	    	fertilizer_string += line(6,"None","0")
			fertilizer_string += line(6,"None","0")
			fertilizer_string += line(6,"None","0")
			fertilizer_string += line(6,"None","0")
			fertilizer_string += line(6,"None","0")	
		end
		fertilizer_string += line(4,"Fertilization_option","0")			
		#4. print manure applications. todo check fert code APEX vs dndc
		manure_string = "-" * 40 + "*"
		manure_string += line(4,"Manure_applications",manure[0].to_s)
		for j in 1..manure.count-1
			man = manure[j].split(",")
			manure_string += line(6,"Manuring#",man[0])
			manure_string += line(6,"Manuring_month",man[1])
    		manure_string += line(6,"Manuring_day",man[2])
    		manure_string += line(6,"Manuring_amount", man[3])
    		manure_string += line(6,"Manuring_C/N", man[4])
    		manure_string += line(6,"Manuring_type", man[5])
    		manure_string += line(6,"Manuring_method", man[6])
    		manure_string += line(6,"Manuring_depth", man[7])
    		manure_string += line(6,"Manuring_OrgN", man[9])
    		manure_string += line(6,"Manuring_NH4", "0.0000")
    		manure_string += line(6,"Manuring_NO3", man[8])
	    	manure_string += line(6,"None","0")
		end
		#5. print film applications.
		film_string = "-" * 40 + "*"
		film_string += line(4,"Film_applications","0")
		film_string += line(4,"Method","0")
		#6. print flood applications.
		flood_string = "-" * 40 + "*"
		flood_string += line(4,"Flood_applications","0")
		flood_string += line(4,"Water_control","0")
		flood_string += line(4,"Flood_water_N","0.0000")
		flood_string += line(4,"Leak_rate","0.0000")
		flood_string += line(4,"Water_gather_index","1.0000")
		flood_string += line(4,"Watertable_file","None")
		flood_string += line(4,"Empirical_para_1","0.0000")
		flood_string += line(4,"Empirical_para_2","0.0000")
		flood_string += line(4,"Empirical_para_3","0.0000")
		flood_string += line(4,"Empirical_para_4","0.0000")
		flood_string += line(4,"Empirical_para_5","0.0000")
		flood_string += line(4,"Empirical_para_6","0.0000")
		#4. print irrigation applications.
		irrigation_string = "-" * 40 + "*"
		irrigation_string += line(4,"Irrigation_applications",irrigation[0].to_s)
		irrigation_string += line(4,"Irrigation_control","0")
		irrigation_string += line(4,"Irrigation_index","0.0000")
		irrigation_string += line(4,"Irrigation_method","5")
		for j in 1..irrigation.count-1
			irri = irrigation[j].split(",")
			irrigation_string += line(6,"Irrigation#",irri[0])
			irrigation_string += line(6,"Irri_month",irri[1])
    		irrigation_string += line(6,"Irri_day",irri[2])
    		irrigation_string += line(6,"Water_amount", irri[3])	#todo check volum units for convertion
    		irrigation_string += line(6,"Irri_method", irri[4])
	    	irrigation_string += line(6,"None","0")
			irrigation_string += line(6,"None","0")
			irrigation_string += line(6,"None","0")
			irrigation_string += line(6,"None","0")
			irrigation_string += line(6,"None","0")	
		end
		grazing_string = "-" * 40 + "*"
		grazing_string += line(4,"Grazing_applications",grazing[0].to_s)	#todo add this
		for j in 1..grazing.count-1
			graze = grazing[j].split(",")
			grazing_string += line(6,"grazing#",graze[0])
			grazing_string += line(6,"Start_month",graze[1])
    		grazing_string += line(6,"Start_day",graze[2])
			grazing_string += line(6,"End_month",graze[3])
    		grazing_string += line(6,"End_day",graze[4])
    		grazing_string += line(6,"Dairy_heads", graze[6])
    		grazing_string += line(6,"Beef_heads", graze[7])
    		grazing_string += line(6,"Pig_heads", graze[8])
    		grazing_string += line(6,"Sheep_heads", graze[9])
    		grazing_string += line(6,"Horse_heads", graze[10])
    		grazing_string += line(6,"Grazing_hours/day", graze[5])
    		grazing_string += line(6,"Additional_feed", "0.0000")
    		grazing_string += line(6,"Additional_feed_C/N", "0.0000")
   			grazing_string += line(6,"Excreta_handling", "1")
	    	grazing_string += line(6,"None","0")
			grazing_string += line(6,"None","0")
			grazing_string += line(6,"None","0")
			grazing_string += line(6,"None","0")
			grazing_string += line(6,"None","0")	
		end
		cut_string = "-" * 40 + "*"
		cut_string += line(4,"Cut_applications ","0")
		cut_string += "-" * 40 + "*"
		return crop_string + tillage_string + fertilizer_string + manure_string + film_string + flood_string + irrigation_string + grazing_string + cut_string
	end
end
