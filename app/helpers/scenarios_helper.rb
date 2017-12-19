module ScenariosHelper
	def add_scenario_to_soils(scenario)
		field = Field.find(scenario.field_id)
		soils = field.soils
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
		subarea.iow = i
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
		#bmps = Bmp.where(:bmpsublist => [1, 2, 3])
		temp_length = Math.sqrt(buffer_length * AC_TO_KM2)

		#the default values are going to be overwritten if the addition is a buffer
		case bmpsublist_id
			when 6, 7    #PPDE
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
			when 8    #Wetlands
				#line 2
				subarea.number = 105
				subarea.iops = soil_id
				#subarea.iow = 1
				#line 5
				subarea.rchl = soil_area * AC_TO_KM2 / temp_length    #soil_area here is the reservior area
				#line 4
				subarea.wsa = soil_area * AC_TO_HA       #soil_area here is the reservior area
				# reduce the area of others subareas proportionally
				if @bmp.sides == 0 then
					update_wsa("-", subarea.wsa)
				end
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
				subarea.rchc = 0.0
				subarea.rchk = 0.0
				#line 6
				subarea.rsee = 0.3
				subarea.rsae = subarea.wsa
				subarea.rsve = 50
				subarea.rsep = 0.3
				subarea.rsap = subarea.wsa
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
			when 12    #Riperian Forest
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
						subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
						fs_area = subarea.wsa
					end
					if @bmp.sides == 0 then
						update_wsa("-", subarea	.wsa)
					end
					subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
					subarea.slp = subarea.slp * @bmp.buffer_slope_upland
					subarea.splg = calculate_slope_length(subarea.slp * 100)
					## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
					subarea.chn = 0.2
					subarea.upn = 0.30
					subarea.ffpq = params[:bmp_fs][:floodplain_flow]
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
						if type == "create"
							create_subarea("RFFS", i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, true, "create")
						else
							update_wsa("-", subarea.wsa)
							update_subarea(subarea, "RFFS", i, soil_area, slope, forestry, total_selected, field_name, scenario_id, soil_id, soil_percentage, total_percentage, field_area, bmp_id, bmpsublist_id, true, "update")
						end
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
						subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
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
					subarea.ffpq = params[:bmp_fs][:floodplain_flow]
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
			when 13    #Filter Strip
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
					subarea.wsa = temp_length * subarea.rchl * 100      # KM2_TO_HA
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
				subarea.ffpq = params[:bmp_fs][:floodplain_flow]
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
			when 14    #Waterway
				#line 2
				subarea.number = 104
				subarea.iops = soil_id
				#subarea.iow = 1
				#line 5
				subarea.rchl = (@bmp.width * FT_TO_KM).round(4)   #soil_area here is the reservior area
				#line 4
				subarea.wsa = temp_length * subarea.rchl * 100
				update_wsa("-", subarea.wsa)
				subarea.chl = Math.sqrt((subarea.rchl**2) + ((temp_length/2) ** 2))
				## slope is going to be the lowest slope in the selected soils and need to be passed as a param in slope variable
				subarea.slp = subarea.slp * 0.25
				subarea.splg = calculate_slope_length(subarea.slp * 100)
				subarea.chs = subarea.slp
				subarea.chn = 0.1
				subarea.upn = 0.24
				subarea.ffpq = params[:bmp_ww][:floodplain_flow]
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
                subarea.rfpw = (subarea.wsa * HA_TO_M2) / (subarea.rchl * KM_TO_M)
                subarea.rfpl = subarea.rchl
				#line 10
				subarea.pec = 1.0
				add_buffer_operation(136, Crop.find(@bmp.crop_id).number, 0, 1400, 0, 22, 2, scenario_id)
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
				add_buffer_operation(136, @bmp.crop_id, 0, 1400, 0, 22, 2, scenario_id)
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
		if subarea.save then
			
		else
			
		end
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
		soils = @field.soils.where(:selected => true)
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

	def update_soil_operation(soil_operation, soil_id, operation)
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
		    soil_operation.apex_operation = Crop.find(operation.crop_id).harvest_code
		    soil_operation.type_id = operation.subtype_id
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
		soil_operation.opv3 = 0
		soil_operation.opv4 = set_opval4(operation)
		soil_operation.opv5 = set_opval5(operation)
		soil_operation.opv6 = 0
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
            if operation.amount / FT2_TO_M2 < 1 then
              return (operation.amount / FT2_TO_M2).round(6) #plant population converte from ft2 to m2 if it is not tree
            else
              return (operation.amount / FT2_TO_M2).round(0) #plant population converte from ft2 to m2 if it is not tree
            end
            if lu_number == 28 then
              return (operation.amount / FT_TO_HA).round(0) #plant population converte from ft2 to ha if it is tree
            end
          end
        end
      else
        return 0
    end #end case
  end

  #end set_val5

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
        	opv1 = (operation.amount * 2471 * (100-operation.moisture)/100).round(2) #Ali's equation on e-mail 11-07-2017
        when 3
        	if operation.moisture == nil then
        		operation.moisture = Fertilizer.find(operation.subtype_id).dry_matter
        		operation.save
        	end
          	opv1 = (operation.amount * 9350 * (100-operation.moisture)/100).round(2) #Ali's equation on e-mail 11-07-2017
        end
    when 6 #irrigation
        opv1 = operation.amount * IN_TO_MM #irrigation volume from inches to mm.
    when 7, 9 #grazing
    	opv1 = @scenario.subareas[0].wsa / operation.amount  #since it is grazing just first subarea is used.
    when 12 #liming
        opv1 = operation.amount / THA_TO_TAC #converts input t/ac to APEX t/ha
    end
    return opv1
  end

  #end ser_opval1

  def set_opval4(operation)
    opv4 = 0.0
    case operation.activity_id
      when 6 #irrigation efficiency. Converted from % to fraction
        opv4 = 1 - operation.depth/100 unless operation.depth == nil
    end
    return opv4
  end
  #end set_opval4

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

  def calculate_centroid()
    #https://en.wikipedia.org/wiki/Centroid.
    centroid_structure = Struct.new(:cy, :cx)
    centroid = centroid_structure.new(0.0, 0.0)
    points = @field.coordinates.split(" ")
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

  def add_soil_operation(operation)
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    #@scenario = Scenario.find(params[:scenario_id])
    soils = @field.soils
    #soils = Soil.where(:field_id => Scenario.find(@operation.scenario_id).field_id)
    msg = "OK"
    soils.each do |soil|
      if msg.eql?("OK")
        msg = update_soil_operation(SoilOperation.new, soil.id, operation)
      else
        break
      end
    end
    return msg
  end

end
