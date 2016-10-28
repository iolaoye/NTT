module ScenariosHelper
	def add_scenario_to_soils(scenario)
		field = Field.find(scenario.field_id)
		soils = Soil.where(:field_id => scenario.field_id)
		i = 0
		total_percentage = soils.where(:selected => true).sum(:percentage)
		total_selected = soils.where(:selected => true).count
		soils.each do |soil|
			i+=1
			soil_area = (soil.percentage * field.field_area / 100)
			create_subarea("Soil", i, soil_area, soil.slope, field.field_type, total_selected, field.field_name, scenario.id, soil.id, soil.percentage, total_percentage, field.field_area, 0, 0, false, "create")
		end #soils each do end
	end

 ###################################### create_subarea ###################################### 
 ## Create subareas from soils receiving from map for each field and for each scenario ###
	def create_subarea(sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type)
		subarea = Subarea.new
		update_subarea(subarea, sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type)
	end

	def update_subarea(subarea, sub_type, i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, checker, type)
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
        subarea.iwth = 0
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
			subarea.ffpq = 0.9
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
        subarea.lm = 0
        subarea.ifd = 0
        subarea.idr = 0
        subarea.idf1 = 0
        subarea.idf2 = 0
        subarea.idf3 = 0
        subarea.idf4 = 0
        subarea.idf5 = 0
		#/line 9
		subarea.bir = 0
        subarea.efi = 0
		subarea.vimx = 0
        subarea.armn = 0
		subarea.armx = 0
		subarea.bft = 0
        subarea.fnp4 =
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
		subarea.ny1 = 0
        subarea.ny2 = 0
        subarea.ny3 = 0
        subarea.ny4 = 0
        subarea.ny5 = 0
        subarea.ny6 = 0
        subarea.ny7 = 0
        subarea.ny8 = 0
        subarea.ny9 = 0
        subarea.ny10 = 0
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
		bmps = Bmp.where(:bmpsublist => 1, :bmpsublist => 2, :bmpsublist => 3)
		temp_length = Math.sqrt(buffer_length)

		#the default values are going to be overwritten if the addition is a buffer
		case bmpsublist_id
			when 6    #PPDE
				#line 2
				subarea.number = 106
				subarea.iops = soil_id
				subarea.iow = 1
				#line 5
				subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
				#line 4
				subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.chs = subarea.slp
				subarea.chn = 0.05
				subarea.upn = 0.41
				subarea.ffpq = 0.8
				#line 5
				subarea.rchd = 0.1
				subarea.rcbw = 0.1
				subarea.rctw = 0.1
				subarea.rchs = subarea.slp
				subarea.rchn = 0.15
				subarea.rchk = 0.01
				#line 6
				subarea.rsee = 0.01
				subarea.rsae = subarea.wsa
				subarea.rsve = 75
				subarea.rsep = 0.1
				subarea.rsap = subarea.wsa
				subarea.rsvp = 25
				subarea.rsrr = 1
				subarea.rsys = 300
				subarea.rsyn = 300
				#line 7
				subarea.rshc = 0.001
				subarea.rsdp = 360
				subarea.rsbd = 0.8
				#line 10
				subarea.pec = 1
			when 8    #Wetlands
				#line 2
				subarea.number = 105
				subarea.iops = soil_id
				subarea.iow = 1
				#line 5
				subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
				#line 4
				subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = 0.01
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
				#line 6
				subarea.rsee = 0.3
				subarea.rsae = subarea.wsa
				subarea.rsve = 50
				subarea.rsep = 0.3
				subarea.rsap = subarea.wsa
				subarea.rsvp = 25
				subarea.rsrr = 20
				subarea.rsys = 300
				subarea.rsyn = 300
				#line 7
				subarea.rshc = 0.001
				subarea.rsdp = 360
				subarea.rsbd = 0.8
				#line 10
				subarea.pec = 1
				add_buffer_operation(subarea, 139, 139, 0, 2000, 0, 33, true, scenario_id)
			when 12    #Riperian Forest
				if !checker
					#line 2
					subarea.number = 102
					subarea.iops = soil_id
					subarea.iow = 1
					#line 5
					fs_width = @bmp.width * FT_TO_KM * @bmp.grass_field_portion
					subarea.rchl = fs_width    #soil_area here is the reservior area
					#line 4
					if soil_area != nil
						fs_area = soil_area * AC_TO_HA * @bmp.grass_field_portion
						subarea.wsa = fs_area      #soil_area here is the reservior area
					else
						subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
						fs_area = subarea.wsa
					end
					update_wsa("+", subarea.wsa)
					subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
					subarea.slp = subarea.slp * @bmp.buffer_slope_upland
					subarea.splg = calculate_slope_length(subarea.slp * 100)
					## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
					subarea.chn = 0.1
					subarea.upn = 0.24
					subarea.ffpq = FSEFF
					#line 5
					rchc_buff = 0.01
					rchk_buff = 0.2
					subarea.rchl = subarea.rfpl    #soil_area here is the reservior area
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
					subarea.rfpw = (subarea.wsa * HA_TO_M2) / (subarea.rchl * KM_TO_M)
					subarea.rfpl = subarea.rchl
					#line 10
					subarea.pec = 1.0
					if type == "create"
						create_subarea("RF", i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, true, "create")
					else
						update_wsa("-", subarea.wsa)
						update_subarea(subarea, "RF", i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, true, "update")
					end
					add_buffer_operation(subarea, 139, 49, 0, 1400, 0, 22, true, scenario_id)
				else
					#line 2
					subarea.number = 103
					subarea.iops = soil_id
					subarea.iow = 1
					#line 5
					fs_width = @bmp.width * FT_TO_KM * @bmp.grass_field_portion
					subarea.rchl = soil_area * AC_TO_HA - fs_width    #soil_area here is the reservior area
					#line 4
					if soil_area != nil
						subarea.wsa = soil_area * AC_TO_HA * (1 - @bmp.grass_field_portion)      #soil_area here is the reservior area
					else
						subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
					end
					update_wsa("+", subarea.wsa)
					subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
					subarea.slp = subarea.slp * @bmp.buffer_slope_upland
					subarea.splg = calculate_slope_length(subarea.slp * 100)
					## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
					subarea.chn = 0.2
					subarea.upn = 0.3
					subarea.ffpq = FSEFF
					#line 5
					rchc_buff = 0.01
					rchk_buff = 0.2
					subarea.rchl = subarea.rfpl    #soil_area here is the reservior area
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
					subarea.rfpw = (subarea.wsa * HA_TO_M2) / (subarea.rchl * KM_TO_M)
					subarea.rfpl = subarea.rchl
					#line 10
					subarea.pec = 1.0
					add_buffer_operation(subarea, 139, 79, 350, 1900, -64, 22, true, scenario_id)
					add_buffer_operation(subarea, 136, 49, 0, 1400, 0, 22, false, scenario_id)
				end
			when 13    #Filter Strip
				#line 2
				subarea.number = 101
				subarea.iops = soil_id
				subarea.iow = 1
				#line 5
				subarea.rchl = @bmp.width * FT_TO_KM   #soil_area here is the reservior area
				#line 4
				if soil_area != nil
					temp_length = soil_area * AC_TO_KM2  / subarea.rchl
					subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
				else
					subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
					soil_area = subarea.wsa * HA_TO_AC
				end
				update_wsa("+", subarea.wsa)
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
				add_buffer_operation(subarea, 136, @bmp.crop_id, 0, 1400, 0, 22, true, scenario_id)
			when 14    #Waterway
				#line 2
				subarea.number = 104
				subarea.iops = soil_id
				subarea.iow = 1
				#line 5
				subarea.rchl = @bmp.width * FT_TO_KM   #soil_area here is the reservior area
				#line 4
				subarea.wsa = temp_length * subarea.rchl * 100
				update_wsa("+", subarea.wsa)
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = subarea.slp * 0.25
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
				add_buffer_operation(subarea, 136, @bmp.crop_id, 0, 1400, 0, 22, true, scenario_id)
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
					subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
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
				add_buffer_operation(subarea, 136, @bmp.crop_id, 0, 1400, 0, 22, true, scenario_id)
		end # end bmpsublist_id

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
		subarea.save
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
		soils = soils = Soil.where(:field_id => session[:field_id], :selected => true)
		soils.each do |soil|
			subarea = Subarea.where(:scenario_id => session[:scenario_id], :soil_id => soil.id).first
			if operation == "+"
				subarea.wsa += subarea.wsa * soil.percentage / 100
			else
				subarea.wsa -= subarea.wsa * soil.percentage / 100
			end
			subarea.save
		end
	end

	def add_buffer_operation(subarea, operation, crop, years_cult, opv1, opv2, lunum, add_buffer, scenario_info)
		operation = SoilOperation.new
		operation.day = 15
		operation.month = 1
		operation.year = 1
		operation.operation_id = 0
		operation.tractor_id = 0
		operation.apex_crop = crop
		operation.type_id = 0
		operation.opv1 = opv1
		operation.opv2 = opv2
		operation.opv3 = 0
		operation.opv4 = 0
		operation.opv5 = 0
		operation.opv6 = 0
		operation.opv7 = 0
		operation.scenario_id = scenario_info
		operation.soil_id = 0
		operation.apex_operation = operation
		operation.bmp_id = @bmp.id
		operation.activity_id = 1
		operation.save
		#TODO oper.LuNumber = lunum <- visual basic code
	end
end
