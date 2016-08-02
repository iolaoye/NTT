
module SimulationsHelper
	PHMIN = 3.5
    PHMAX = 9.0
	OCMIN = 0.0      #change from 0.5 to 0 according to Ali. APEX calculate it if 0.
    OCMAX = 2.5
	OM_TO_OC = 1.724
	BDMIN = 1.1
    BDMAX = 1.79
	SoilPMaxForSoilDepth = 15.24
	SoilPDefault = 0.1
	CropMixedGrass = 367
	COMA = ", "	

	def create_control_file()
		apex_string = ""
		apex_control = ApexControl.where(:project_id => session[:project_id])
		require 'net/http'
		coor = '(39.307505,-75.963721),(39.303686,-75.964451),(39.304683,-75.965910),(39.305413,-75.966253),(39.307007,-75.965738),(39.307406,-75.964837)'
		county = 'md029'
		state = 'Maryland'
		t = 'cbntt'
        apex_control.each do |c|
            case c.control_id
                when 1..19        #line 1
					apex_string += sprintf("%4d", c.value)
                when 20
					apex_string += sprintf("%4d", c.value) + "\n"
                when 21..37       #line 2
                    apex_string += sprintf("%4d", c.value)
                when 38
					apex_string += sprintf("%4d", c.value) + "\n"
                when 39..47        #line 3
                    apex_string += sprintf("%8.2f", c.value)
                when 48
					apex_string += sprintf("%8.2f", c.value) + "\n"
                when 49..57        #line 4
					apex_string += sprintf("%8.2f", c.value)
                when 58
					apex_string += sprintf("%8.2f", c.value) + "\n"
                when 59..67		#line 5
					apex_string += sprintf("%8.2f", c.value)
                when 68
					apex_string += sprintf("%8.2f", c.value) + "\n"
                when 69..75		#line 6
					apex_string += sprintf("%8.2f", c.value)
                when 76
					apex_string += sprintf("%8.2f", c.value) + "\n"
            end
        end
		msg = send_file_to_APEX(apex_string, "Apexcont.dat")
		#print_string_to_file(apex_string, "Apexcont.dat")
	end

	def send_file_to_APEX(apex_string, file)
		uri = URI('http://nn.tarleton.edu/NTTRails/NNRestService.ashx')
		res = Net::HTTP.post_form(uri, "data" => apex_string, "file" => file, "folder" => session[:session_id], "rails" => "yes")
		if res.body.include?("Created") then return "OK" else return res.body end
	end

	def create_parameter_file()
        apex_string = ""       
        apex_string +="  90.050  99.950" + "\n"
        apex_string +="   10.50  100.95" + "\n"
        apex_string +="   50.10   95.95" + "\n"
        apex_string +="    0.00    0.00" + "\n"
        apex_string +="   25.05   75.90" + "\n"
        apex_string +="    5.10  100.95" + "\n"
        apex_string +="    5.25   50.95" + "\n"
        apex_string +="    20.5   80.99" + "\n"
        apex_string +="    1.10   10.99" + "\n"
        apex_string +="   10.05  100.90" + "\n"
        apex_string +="    5.01   20.90" + "\n"
        apex_string +="    5.05  100.50" + "\n"
        apex_string +="    1.80    3.99" + "\n"
        apex_string +="    5.10   20.95" + "\n"
        apex_string +="   10.10  100.95" + "\n"
        apex_string +="    3.10   20.99" + "\n"
        apex_string +="   20.10   50.95" + "\n"
        apex_string +="    5.10   50.30" + "\n"
        apex_string +="   10.01   25.95" + "\n"
        apex_string +="  400.05  600.80" + "\n"
        apex_string +="    10.5   100.9" + "\n"
        apex_string +="  100.01  1000.9" + "\n"
        apex_string +="    1.50    3.99" + "\n"
        apex_string +="    1.25    5.95" + "\n"
        apex_string +="   50.10   55.90" + "\n"
        apex_string +="                " + "\n"
        apex_string +="                " + "\n"
        apex_string +="                " + "\n"
        apex_string +="                " + "\n"
        apex_string +="   50.00   10.00" + "\n"
		apex_parameter = ApexParameter.where(:project_id => session[:project_id])
		apex_parameter.each do |p|
			#number = Parameter.find(p.parameter_id).number
			case p.parameter_id
				when 10, 20, 30, 50, 60, 70, 80, 90
					apex_string += sprintf("%8.2f", p.value) + "\n"
				when 36, 65, 76, 87, 88
					apex_string += sprintf("%8.3f", p.value) 
				when 40
					apex_string += sprintf("%8.3f", p.value) + "\n"
				when 23, 43, 55, 58, 84, 85
					apex_string += sprintf("%8.4f", p.value) 
				when 39
					apex_string += sprintf("%8.5f", p.value) 
				else 
					apex_string += sprintf("%8.2f", p.value) 
			end  #end case p.line
		end #end each do p
        apex_string +="\n"
        apex_string +="    .044     31.     .51     .57     10." + "\n"
        apex_string +=" " + "\n"
		msg = send_file_to_APEX(apex_string, "parm.dat")
		#print_string_to_file(apex_string, "parm.dat")
	end

	def create_site_file(field_id)
		site = Site.find_by_field_id(field_id)
		#site_file = Array.new
		apex_string = ""
		apex_string += 
		apex_string += " .sit file Subbasin:1  Date: " + @dtNow1 + "\n"
		apex_string += "" + "\n"
		apex_string += "" + "\n"
		apex_string += sprintf("%8.2f", site.ylat) + sprintf("%8.2f", site.xlog) + sprintf("%8.2f", site.elev) + 
		sprintf("%8.2f", site.apm) + sprintf("%8.2f", site.co2x) + sprintf("%8.2f", site.cqnx) + sprintf("%8.2f", site.rfnx) +
		sprintf("%8.2f", site.upr) + sprintf("%8.2f", site.unr) + sprintf("%8.2f", site.fir0)
		for i in 5..25  #print 21 additonal lines in the site file, which do not need any information at this time.
			apex_string += "" + "\n"
		end  # end for
		msg = send_file_to_APEX(apex_string, "APEX.sit")
		#print_array_to_file(site_file, "APEX.sit")
	end

	def create_wind_wp1_files(dir_name)
		county = County.find(Location.find(session[:location_id]).county_id)
		apex_run_string = "APEX001   1IWPNIWND   1   0   0"
		if county != nil then
			client = Savon.client(wsdl: URL_Weather)
			response = client.call(:get_weather, message:{"path" => WP1 + "/" + county.wind_wp1_name + ".wp1"})
			weather_data = response.body[:get_weather_response][:get_weather_result][:string]
			msg = send_file_to_APEX(weather_data.join("\n"), county.wind_wp1_name + ".wp1")
			#print_wind_to_file(weather_data, county.wind_wp1_name + ".wp1")
			#path = File.join(WP1, county.wind_wp1_name + ".wp1")
			#FileUtils.cp_r(path, dir_name + "/" + county.wind_wp1_name + ".wp1")
			client = Savon.client(wsdl: URL_Weather)
			response = client.call(:get_weather, message:{"path" => WIND + "/" + county.wind_wp1_name + ".wnd"})
			weather_data = response.body[:get_weather_response][:get_weather_result][:string]
			msg = send_file_to_APEX(weather_data.join("\n"), county.wind_wp1_name + ".wnd")
			#print_wind_to_file(weather_data, county.wind_wp1_name + ".wnd")
			#path = File.join(WIND, county.wind_wp1_name + ".wnd")
			#FileUtils.cp_r(path, dir_name + "/" + county.wind_wp1_name + ".wnd")
			apex_run_string["IWPN"] = sprintf("%4d", county.wind_wp1_code)
			apex_run_string["IWND"] = sprintf("%4d", county.wind_wp1_code)
		end
		#create apex run file
		#print_string_to_file(apex_run_string, "Apexrun.dat")
		msg = send_file_to_APEX(apex_run_string, "Apexrun.dat")
	end

	def create_weather_file(dir_name, field_id)
		#todo weather file are more than one when there are different fields such as in watershed simulation.
		weather = Weather.find_by_field_id(field_id)
		if (weather.way_id == 2)
			#copy the file path
			path = File.join(OWN,weather.weather_file)
		    FileUtils.cp_r(path, dir_name + "/APEX.wth")
			data = read_file(File.join(OWN,weather.weather_file), true)
		else
			path = File.join(PRISM,weather.weather_file)
			#client = Savon.client(wsdl: URL_Weather)
			#response = client.call(:get_weather, message:{"path" => PRISM + "/" + weather.weather_file})
			#weather_data = response.body[:get_weather_response][:get_weather_result][:string]
			#print_array_to_file(PATH, "APEX.wth")
			data = send_file_to_APEX("WTH", path)
		end
		#todo after file is copied if climate bmp is in place modified the weather file.
        bmp_id = Bmp.select(:id).where(:scenario_id => session[:scenario_id])
        climate_array = Array.new
        climates = Climate.where(:bmp_id => bmp_id)
        climates.each do |climate|
            climate_array = update_hash(climate, climate_array)
        end
        if climates.first != nil
            data.each_line do |day|
                month = data[6, 4].to_i
                max_input = climate_array[month]["max"]
                min_input = climate_array[month]["min"]
                pcp_input = climate_array[month]["pcp"] / 100
                max_file = data[20, 6].to_f
                min_file = data[26, 6].to_f
                pcp_file = data[32, 7].to_f
                if max_input != 0
                    max = max_file + max_input
                    max = sprintf("%.1f", max)
                    while max.length < 6
                        max = " " + max
                    end
                    data[20, 6] = max
                end #end if max
                if min_input != 0
                    min = min_file + min_input
                    min = sprintf("%.1f", min)
                    while min.length < 6
                        min = " " + min
                    end
                    data[26, 6] = min
                end #end if min
                if pcp_input != 0
                    pcp = pcp_file + pcp_file * pcp_input
                    pcp = sprintf("%.2f", pcp)
                    while pcp.length < 7
                        pcp = " " + pcp
                    end
                    data[32, 7] = pcp
                end #end if pcp
                #climate_array[month]["key"] 
                #session[:month] = str[6, 4].to_i
                #session[:max] = str[20, 6].to_f
                #session[:min] = str[26, 6].to_f
                #session[:pcp] = str[32, 7].to_f
            end # end each
	        #@climate_file_array = Array.new
	        #newLine = "  " + oper.to_s	
	        #newLine += " C:FERT 5 CUST      5.      0.      0.      0.      0.     0.0    0.00   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000"
            #newLine += sprintf("%8.2f", depthAnt * 25.4)
            #newLine += "   0.000   0.000   0.000   0.000   9.000   0.000   0.000   0.000   0.000   5.000   5.363  FERTILIZER APP        " + oper.to_s + "\n"
            #@change_till_depth.push(newLine)
        end #end if
        #print_array_to_file(data, "Apex.wth")
		msg = send_file_to_APEX(data, "APEX.wth")
		#todo fix widn and wp1 files with the real name
	end

    def create_soils()
        #APEXStrings1 As New System.Text.StringBuilder
        #Dim ds1 As IEnumerable(Of LayersData)
        soilSlope =0
        series = "" 
		horizgen = "" 
		horizdesc1 = "" 
		horizdesc2 = ""
        i=0
        depth = Array.new
        bulk_density = Array.new
        uw = Array.new
        fc = Array.new
        sand = Array.new
        silt = Array.new
        wn = Array.new
        ph = Array.new
        smb = Array.new
        woc = Array.new
        cac = Array.new
        cec = Array.new
        rok = Array.new
        cnds = Array.new
        ssf = Array.new
        rsd = Array.new
        bdd = Array.new
        psp = Array.new
        satc = Array.new
        hcl = Array.new
        wpo = Array.new
        cprv = Array.new
        cprh = Array.new
        rt = Array.new
        ssaCode = ""
		#series_name ""
        albedo = 0
        #added to control when information is not available
        texture = ["sandy clay loam", "silty clay loam", "loamy sand", "sandy loam", "sandy clay", "silt loam", "clay loam", "silty clay", "sand", "loam", "silt", "clay"]
        sands = [53.2, 8.9, 80.2, 63.4, 52, 15, 29.1, 7.7, 84.6, 41.2, 4.9, 12.7]
        silts = [20.6, 58.9, 14.6, 26.3, 6, 67, 39.3, 45.8, 11.1, 40.2, 85, 32.7]
        satcs = [9.24, 11.4, 94.66, 48.01, 0.8, 15.55, 7.74, 5.29, 107.83, 19.98, 10.64, 2.1]
        bds = [1.49, 1.2, 1.44, 1.46, 1.49, 1.31, 1.33, 1.21, 1.45, 1.4, 1.42, 1.24]
        soil_file_name = ""
        last_soil1 = 0
		#last_soil = 0
		soil_info = Array.new
		#APEXStrings1 = 0
        #check to see if there are soils selected
        selected = false
		@soils.each do |soil|
            if soil.selected == true 
				selected = true
				break
            end
        end
        #if no soils selected the soils are sorted by area and  selects up to the three most dominant soils.
        if selected == false 
			@soils.each do |soil|
                if i > 2 
					break
				else
					soil.selected = true
				end
            end
        end

        apex_scenarios = 0
        i = 0
		@soils.each do |soil|
			soil_info.clear
			if soil.selected == false 
				next
			end
			layers = Layer.where(:soil_id => soil.id)
            last_soil1 = @last_soil + i + 1
            soil_file_name = "APEX" + "00" + last_soil1.to_s + ".sol"
            #total_area = total_area + soil.percentage
            apex_scenarios += 1
            records = " .sol file Soil: " + soil_file_name + " Date: " + @dtNow1 + " Soil Name: " + soil.name
			soil_info.push(records + "\n")                
            records = ""
            layer_number = 1
            result = 0
            if soil.group == nil
                hsg = "B"
            else
                hsg = soil.group
            end
            layers.each do |layer|
				# try to find texture from texture description from database
                #for j = 0 To texture.Length - 1
                #    if layer("texture").Contains(texture(j))  Exit for
                #end

                if layer_number == 1
                    #validate if this layer is going to be used for Agriculture Lands
                    if layer.depth <= 5 && layer.sand == 0 && layer.silt == 0 && layer.organic_matter > 25 && layer.bulk_density < 0.8
                        next
                    end
                    if soil.albedo > 0 
                        albedo = soil.albedo
                    else
                        albedo = 0.37
                    end
                end 

                depth[layer_number] = layer.depth * IN_TO_CM

                #if current layer is deeper than maxDept  no more layers are needed.
                #if Depth[layer_number] > maxDepth(i) && maxDepth(i) > 0  Exit for
                #These statements were added to control duplicated layers in the soil.
                if layer_number > 1 
                    if depth[layer_number] == depth[layer_number - 1] 
						next
					end
                end
				if !(layer.uw == nil)
					if layer.uw <= 0.0 && layer_number > 1 
						uw[layer_number] = uw[layer_number - 1]
					else
						uw[layer_number] = layer.uw
					end
				else
					uw[layer_number] = 0
				end 
				if !(layer.fc == nil)
					if layer.fc <= 0 && layer_number > 1 
						fc[layer_number] = fc[layer_number - 1]
					else
						fc[layer_number] = layer.fc
					end
				else
					fc[layer_number] = 0
				end
                #These lines were changed to take sand from xml file in case user had changed it
                if layer.sand <= 0 && layer_number > 1 
                    sand[layer_number] = sand[layer_number - 1]
                else
                    sand[layer_number] = layer.sand
                end
                if layer.silt <= 0 && layer_number > 1 
                    silt[layer_number] = silt[layer_number - 1]
                else
                    silt[layer_number] = layer.silt
                end
				if !(layer.wn == nil)
					if layer.wn <= 0 && layer_number > 1 
						wn[layer_number] = wn[layer_number - 1]
					else
						wn[layer_number] = layer.wn
					end
				else
					wn[layer_number] = 0
				end
				if (layer.ph != nil)
					if layer.ph <= 0 && layer_number > 1 
						ph[layer_number] = ph[layer_number - 1]
					else
						ph[layer_number] = layer.ph
					end
				else
					ph[layer_number] = PHMIN
				end
				ph[layer_number] = PHMIN if ph[layer_number] < PHMIN
				ph[layer_number] = PHMAX if ph[layer_number] > PHMAX
				
				cec[layer_number] = 0
                if layer.cec == 0 && layer_number > 1
                    cec[layer_number] = cec[layer_number - 1]
                else
                    cec[layer_number] = layer.cec unless layer.cec == nil
                end

                smb[layer_number] = 0
                if layer.smb == 0 && layer_number > 1 
                    smb[layer_number] = smb[layer_number - 1]
                else
                    smb[layer_number] = layer.smb unless layer.smb == nil
                end

				woc[layer_number] = 0
                if layer.organic_matter == 0 && layer_number > 1
                    woc[layer_number] = woc[layer_number - 1]
                else
                    woc[layer_number] = layer.organic_matter unless layer.organic_matter == nil
                end
                woc[layer_number] = (woc[layer_number] / OM_TO_OC)
                if woc[layer_number] < OCMIN
					woc[layer_number] = OCMIN
				end
                if woc[layer_number] > OCMAX  
					woc[layer_number] = OCMAX
				end

				cac[layer_number] = 0
                if layer.cac == 0 && layer_number > 1 
                    cac[layer_number] = cac[layer_number - 1]
                else
                    cac[layer_number] = layer.cac unless layer.cac == nil
                end
				rok[layer_number] = 0 
                if layer.rok == 0 && layer_number > 1 
                    rok[layer_number] = rok[layer_number - 1]
                else
                    rok[layer_number] = layer.rok unless layer.rok == nil
                end
				cnds[layer_number] = 0
                if layer.cnds == 0 && layer_number > 1
                    cnds[layer_number] = cnds[layer_number - 1]
                else
                    cnds[layer_number] = layer.cnds unless layer.cnds == nil
                end
                ssf[layer_number] = 0
                if layer.soil_p == 0 && layer_number == 1 
                    ssf[layer_number] = ssf[layer_number-1]
                else
                    ssf[layer_number] = layer.soil_p unless layer.soil_p == nil
                end
				rsd[layer_number] = 0
                if layer.rsd == 0 && layer_number > 1 
                    rsd[layer_number] = rsd[layer_number - 1]
                else
                    rsd[layer_number] = layer.rsd unless layer.rsd == nil
                end
                #These lines were changed to take silt from xml file in case user had changed it
				bulk_density[layer_number] = 0
                if layer.bulk_density == 0 
                    bulk_density[layer_number] = bulk_density[layer_number - 1]
                else
                    bulk_density[layer_number] = layer.bulk_density unless layer.bulk_density == nil
                end
                if bulk_density[layer_number] < BDMIN
					bulk_density[layer_number] = BDMIN
				end
                if bulk_density[layer_number] > BDMAX
					bulk_density[layer_number] = BDMAX
				end
                bdd[layer_number] = bulk_density[layer_number]
                #psp
				psp[layer_number] = 0
                if layer.psp == 0 && layer_number > 1 
                    psp[layer_number] = psp[layer_number - 1]
                else
                    psp[layer_number] = layer.psp unless layer.psp == nil
                end
                sand_silt = sand[layer_number] + silt[layer_number]

                satc[layer_number] = cal_satc(sand[layer_number] / 100, (100 - sand_silt) / 100, woc[layer_number] * OM_TO_OC, 1, 0, 0)
                if satc[layer_number] == 0 
                    if layer_number == 1 
                        satc[layer_number] = 0
                    else
                        satc[layer_number] = satc[layer_number - 1]
                    end
                end
                hcl[layer_number] = 0
                wpo[layer_number] = 0
                cprv[layer_number] = 0
                cprh[layer_number] = 0
                rt[layer_number] = 0

                if soil.slope <= 0 
                    soilSlope = 0.01
                else
                    soilSlope = (soil.slope / 100)
                end
                if hsg == "" || hsg == nil
					hsg = "B"
				end
				layer_number = layer_number + 1
            end  # end layers do

			@bulk_density = bulk_density
            #if first layer is less than 0.1 m a new layer is added as first one
            initial_layer = 1
            if (depth[initial_layer] / 100).round(3) > 0.100
                initial_layer = 0
                depth[initial_layer] = 10.0
                bulk_density[initial_layer] = bulk_density[initial_layer + 1]
                uw[initial_layer] = uw[initial_layer + 1]
                fc[initial_layer] = fc[initial_layer + 1]
                sand[initial_layer] = sand[initial_layer + 1]
                silt[initial_layer] = silt[initial_layer + 1]
                wn[initial_layer] = wn[initial_layer + 1]
                ph[initial_layer] = ph[initial_layer + 1]
                smb[initial_layer] = smb[initial_layer + 1]
                woc[initial_layer] = woc[initial_layer + 1]
                cac[initial_layer] = cac[initial_layer + 1]
                cec[initial_layer] = cec[initial_layer + 1]
                rok[initial_layer] = rok[initial_layer + 1]
                cnds[initial_layer] = cnds[initial_layer + 1]
                ssf[initial_layer] = ssf[initial_layer + 1]
                rsd[initial_layer] = rsd[initial_layer + 1]
                bdd[initial_layer] = bdd[initial_layer + 1]
                psp[initial_layer] = psp[initial_layer + 1]
                satc[initial_layer] = satc[initial_layer + 1]
                hcl[initial_layer] = hcl[initial_layer + 1]
                wpo[initial_layer] = wpo[initial_layer + 1]
                cprv[initial_layer] = cprv[initial_layer + 1]
                cprh[initial_layer] = cprh[initial_layer + 1]
            end  #end depth
			#Line 2 Column 1 and 2
            if albedo == 0 
				albedo = 0.2
			end
            records = sprintf("%8.2f", albedo)
            #records =  albedo.to_s
            case hsg[0]
                when "A"
                    records = records + "      1."
                when "B"
                    records = records + "      2."
                when "C"
                    records = records + "      3."
                when "D"
                    records = records + "      4."
            end
			soil.ffc = 0 unless soil.ffc!=nil
            records = records + sprintf("%8.2f", soil.ffc)
			soil.wtmn = 0 unless soil.wtmn!=nil
            records = records + sprintf("%8.2f", soil.wtmn)
			soil.wtmx = 0 unless !(soil.wtmx==nil)
            records = records + sprintf("%8.2f", soil.wtmx)
			soil.wtbl = 0 unless !(soil.wtbl==nil)
            records = records + sprintf("%8.2f", soil.wtbl)
			soil.gwst = 0 unless !(soil.gwst==nil)
            records = records + sprintf("%8.2f", soil.gwst)
			soil.gwmx = 0 unless !(soil.gwmx==nil)
            records = records + sprintf("%8.2f", soil.gwmx)
			soil.rft = 0 unless !(soil.rft==nil)
            records = records + sprintf("%8.2f", soil.rft)
			soil.rfpk = 0 unless !(soil.rfpk==nil)
            records = records + sprintf("%8.2f", soil.rfpk)
			soil_info.push(records + "\n")
			#Line 3 Column 1 to 7
            records = ""
			soil.tsla = 0 unless !(soil.tsla==nil)
            records = records + sprintf("%8.2f", soil.tsla)
			soil.xids = 0 unless !(soil.xids==nil)
            records = records + sprintf("%8.2f", soil.xids)
			soil.rtn1 = 0 unless !(soil.rtn1==nil)
            records = records + sprintf("%8.2f", soil.rtn1)
			soil.xidk = 0 unless !(soil.xidk==nil)
            records = records + sprintf("%8.2f", soil.xidk)
			soil.zqt = 0 unless !(soil.zqt==nil)
            records = records + sprintf("%8.2f", soil.zqt)
			soil.zf = 0 unless !(soil.zf==nil)
            records = records + sprintf("%8.2f", soil.zf)
			soil.ztk = 0 unless !(soil.ztk==nil)
            records = records + sprintf("%8.2f", soil.ztk)
            soil_info.push(records + "\n")
			#line 4 to 24 Layers information
			records = ""
			for layers in initial_layer..layer_number -1
				depth_cm = depth[layers] / 100
				records = records + sprintf("%8.3f", depth_cm)
            end
            soil_info.push(records + "\n")
			records = ""
            for layers in initial_layer..layer_number - 1
                if bulk_density[layers] == 0
					bulk_density[layers] = 1.3
				end
                records = records + sprintf("%8.3f", bulk_density[layers])
            end
            soil_info.push(records + "\n")
			records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.3f", uw[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.3f", fc[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", sand[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", silt[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", wn[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", ph[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", smb[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", woc[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", cac[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", cec[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", rok[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", cnds[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                if depth[layers] > SoilPMaxForSoilDepth
					ssf[layers] = SoilPDefault
				end
                if ssf[layers] == 0 || ssf[layers] == nil
					ssf[layers] = SoilPDefault
				end
                records = records + sprintf("%8.2f", ssf[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", rsd[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", bdd[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", psp[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", satc[layers])
            end
            soil_info.push(records + "\n")                
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", hcl[layers])
            end
            soil_info.push(records + "\n")
            records = ""
            for layers in initial_layer..layer_number - 1
                records = records + sprintf("%8.2f", wpo[layers])
            end
            soil_info.push(records + "\n")
            records = ""
			(25..47).each do
				soil_info.push(records + "\n")
			end
            #this lines are not added at this time to reduced the size of the information to be transmited to the server. The server will include them in blanks for now. 5/30/2014.
            #INSERT LINES 25, 26, 27, 28
            @soil_list.push("  " + sprintf("%3d",last_soil1) + " " + soil_file_name + "\n")
            i += 1
			#print_array_to_file(soil_info, soil_file_name)			
			msg = send_file_to_APEX(soil_info, soil_file_name)
		end  # end soils do
		@last_soil = last_soil1
	end  # end method create_soils

	def create_subareas(operation_number)  # operation_number is used for subprojects as for now it is just 1 - todo
	    @last_soil2 = 0
        last_owner1 = 0
		i=0
        #soil_number = 0
		#soils = Soil.where(:field_id => field_id, :selected => true)
        @soils.each do |soil|
            #create the operation file for this subarea.
            nirr = create_operations(soil, operation_number)
            #create the subarea file
			bmp = Bmp.where(:scenario_id => params[:id]).find_by_bmpsublist_id(15)
			if (bmp == nil)  # todo if contour buffer this need to be different
            #if !(bmps.CBCWidth > 0 && _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBBWidth > 0 && _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBCrop > 0) then
                #addSubareaFile(soil._scenariosInfo(currentScenarioNumber)._subareasInfo, operation_number, last_soil1, last_owner1, @soil_number, nirr, false)
				#operation number is used to control subprojects. Therefore here is going to be 1.
                add_subarea_file(Subarea.find_by_soil_id_and_scenario_id(soil.id, @scenario.id), operation_number, last_owner1, i, nirr, false, @soils.count)
                @soil_number += 1
				i+=1
            end
        end

        if @last_soil2 > 0 
            @last_soil_sub = @last_soil2 - 1
        else
            @last_soil_sub = 0
        end
        @last_subarea = 0

        #for Each buf In _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bufferInfo
		#todo if buffer is used. Maybe just subarea are used means all of the buffer are created directly as subareas.
		no = 1
		if no != 1 then
			Buffer.each do |buf|
				if !(buf.SbaType == "PPDE" || buf.SbaType == "PPTW" || buf.SbaType == "AITW" || buf.SbaType == "CBMain") 
					#create the operation file for this subarea.
					@last_subarea += 1
					opcsFile.Add(buf.SubareaTitle)
					opcsFile.Add(".OPC " & buf.SubareaTitle + " file Operation:1  Date: " + @dtNow1)
					opcsFile.Add(buf._operationsInfo(0).LuNumber.ToString.PadLeft(4))
					operations = Operation.where(:scenario_id => params[:id])
					#for Each oper In buf._operationsInfo
					operations.each do |oper|
					   opcsFile.Add(sprintf("%3d", oper.year) + sprintf("%3d", oper.month) + sprintf("%3d", oper) + sprintf("%5d", oper.apex_code) + sprintf("%5d", 0) + sprintf("%5d", oper.apex_crop) + sprintf("%5d", oper.subtype) + sprintf("%8.2f", oper.opv1) + sprintf("%8.2f", oper.opv2))
					end
					opcsFile.Add("End " & buf.SubareaTitle)
				end 
				add_subarea_file(buf, operation_number, last_owner1, 0, 0, True)
			end
		end #end if no != 1

        @last_soil_sub = @last_soil2
        last_owner = last_owner1
        #todo check this one.
        #$last_subarea += _fieldsInfo1(currentFieldNumber)._soilsInfo(i - 1)._scenariosInfo(currentScenarioNumber)._subareasInfo_subarea_info..Iops
		#print_array_to_file(@subarea_file, "APEX.sub")	
		msg = send_file_to_APEX(@subarea_file, "APEX.sub")
        return "OK"
	end 

    def add_subarea_file(_subarea_info, operation_number, last_owner1, i, nirr, buffer, total_soils)
        j = i + 1
        #/line 1
        if buffer then   
            @subarea_file.push(sprintf("%8d", j) + "0000000000000000   " + _subarea_info.description + "\n")
        else
            @subarea_file.push(sprintf("%8d", j) + _subarea_info.description + "\n")
        end
		#/line 2
        @last_soil2 = j + @last_soil_sub
        sLine = sprintf("%4d", @soil_number + 1)
        sLine += sprintf("%4d", @soil_number + 1)
		if _subarea_info.iow == 0 then 
			_subarea_info.iow = 1
		end
        last_owner1 = @last_soil2
        sLine += sprintf("%4d", last_owner1)    #owner id. Should change for each field
        sLine += sprintf("%4d", _subarea_info.ii)
        sLine += sprintf("%4d", _subarea_info.iapl)
        sLine += sprintf("%4d", 0)				#column 6 line 1 is not used
        sLine += sprintf("%4d", _subarea_info.nvcn)
        sLine += sprintf("%4d", _subarea_info.iwth)
        sLine += sprintf("%4d", _subarea_info.ipts)
        sLine += sprintf("%4d", _subarea_info.isao)
        sLine += sprintf("%4d", _subarea_info.luns)
        sLine += sprintf("%4d", _subarea_info.imw)
        @subarea_file.push(sLine + "\n")
        #/line 3
        sLine = sprintf("%8.2f", _subarea_info.sno)
        sLine += sprintf("%8.2f", _subarea_info.stdo)
        sLine += sprintf("%8.2f", _subarea_info.yct)
        sLine += sprintf("%8.2f", _subarea_info.xct)
        sLine += sprintf("%8.2f", _subarea_info.azm)
        sLine += sprintf("%8.2f", _subarea_info.fl)
        sLine += sprintf("%8.2f", _subarea_info.fw)
        sLine += sprintf("%8.2f", _subarea_info.angl)
        @subarea_file.push(sLine + "\n")        
		#/line 4
        if _subarea_info.wsa > 0 && i > 0 then
            sLine = sprintf("%8.2f", _subarea_info.wsa * -1)
        else
            sLine = sprintf("%8.2f", _subarea_info.wsa)
        end
        sLine += sprintf("%8.4f", _subarea_info.chl)
        sLine += sprintf("%8.2f", _subarea_info.chd)
        sLine += sprintf("%8.2f", _subarea_info.chs)
        sLine += sprintf("%8.2f", _subarea_info.chn)
        sLine += sprintf("%8.4f", _subarea_info.slp)
        sLine += sprintf("%8.2f", _subarea_info.splg)
        sLine += sprintf("%8.2f", _subarea_info.upn)
        sLine += sprintf("%8.2f", _subarea_info.ffpq)
        sLine += sprintf("%8.2f", _subarea_info.urbf)
        @subarea_file.push(sLine + "\n")
        #/line 5
        if _subarea_info.chl != _subarea_info.rchl && i > 0 then
			_subarea_info.rchl = _subarea_info.chl 
		end
        if (operation_number > 1 && i == 0) || i > 0 then
        #if (operation_number > 1 && i == 0) || (total_soils == i + 1 && total_soils > 1) then
            sLine = sprintf("%8.4f", _subarea_info.rchl * 0.9)
        else
            sLine = sprintf("%8.4f", _subarea_info.rchl)
        end
        sLine += sprintf("%8.2f", _subarea_info.rchd)
        sLine += sprintf("%8.2f", _subarea_info.rcbw)
        sLine += sprintf("%8.2f", _subarea_info.rctw)
        sLine += sprintf("%8.2f", _subarea_info.rchs)
        sLine += sprintf("%8.2f", _subarea_info.rchn)
        sLine += sprintf("%8.4f", _subarea_info.rchc)
        sLine += sprintf("%8.4f", _subarea_info.rchk)
        sLine += sprintf("%8.0f", _subarea_info.rfpw)
        sLine += sprintf("%8.4f", _subarea_info.rfpl)
        @subarea_file.push(sLine + "\n")
		#/line 6
        sLine = sprintf("%8.2f",  _subarea_info.rsee)
        sLine += sprintf("%8.2f", _subarea_info.rsae)
        sLine += sprintf("%8.2f", _subarea_info.rsve)
        sLine += sprintf("%8.2f", _subarea_info.rsep)
        sLine += sprintf("%8.2f", _subarea_info.rsap)
        sLine += sprintf("%8.2f", _subarea_info.rsvp)
        sLine += sprintf("%8.2f", _subarea_info.rsv)
        sLine += sprintf("%8.2f", _subarea_info.rsrr)
        sLine += sprintf("%8.2f", _subarea_info.rsys)
        sLine += sprintf("%8.2f", _subarea_info.rsyn)
        @subarea_file.push(sLine + "\n")
        #/line 7
        sLine = sprintf("%8.3f", _subarea_info.rshc)
        sLine += sprintf("%8.2f", _subarea_info.rsdp)
        sLine += sprintf("%8.2f", _subarea_info.rsbd)
        sLine += sprintf("%8.2f", _subarea_info.pcof)
        sLine += sprintf("%8.2f", _subarea_info.bcof)
        sLine += sprintf("%8.2f", _subarea_info.bffl)
        @subarea_file.push(sLine + "\n")
        #/line 8
        if _subarea_info.nirr > 0 then
            sLine = sprintf("%4d", _subarea_info.nirr)
        else
            sLine = sprintf("%4d", _subarea_info.nirr)
        end
        sLine += sprintf("%4d", _subarea_info.iri)
        sLine += sprintf("%4d", _subarea_info.ira)
        sLine += sprintf("%4d", _subarea_info.lm)
        sLine += sprintf("%4d", _subarea_info.ifd)
        sLine += sprintf("%4d", _subarea_info.idr)
        sLine += sprintf("%4d", _subarea_info.idf1)
        sLine += sprintf("%4d", _subarea_info.idf2)
        sLine += sprintf("%4d", _subarea_info.idf3)
        sLine += sprintf("%4d", _subarea_info.idf4)
        sLine += sprintf("%4d", _subarea_info.idf5)
        @subarea_file.push(sLine + "\n")
		#/line 9
        if _subarea_info.nirr > 0 then 
			sLine = sprintf("%8.2f", _subarea_info.bir) 
		else 
			sLine = sprintf("%8.2f", 0)
		end
        sLine += sprintf("%8.2f", _subarea_info.efi)
        if _subarea_info.nirr > 0 then 
			sLine += sprintf("%8.2f", _subarea_info.vimx) 
		else 
			sLine += sprintf("%8.2f", 0)
		end
        sLine += sprintf("%8.2f", _subarea_info.armn)
        if _subarea_info.nirr > 0 then 
			sLine += sprintf("%8.2f", _subarea_info.armx) 
			sLine += sprintf("%8.2f", _subarea_info.bft)
		else 
			sLine += sprintf("%8.2f", 0)
			sLine += sprintf("%8.2f", 0)
		end
        sLine += sprintf("%8.2f", _subarea_info.fnp4)
        sLine += sprintf("%8.2f", _subarea_info.fmx)
        sLine += sprintf("%8.2f", _subarea_info.drt)
        sLine += sprintf("%8.2f", _subarea_info.fdsf)
        @subarea_file.push(sLine + "\n")
        #/line 10
        sLine = sprintf("%8.2f", _subarea_info.pec)
        sLine += sprintf("%8.2f", _subarea_info.dalg)
        sLine += sprintf("%8.2f", _subarea_info.vlgn)
        sLine += sprintf("%8.2f", _subarea_info.coww)
        sLine += sprintf("%8.2f", _subarea_info.ddlg)
        sLine += sprintf("%8.2f", _subarea_info.solq)
        sLine += sprintf("%8.2f", _subarea_info.sflg)
        sLine += sprintf("%8.2f", _subarea_info.fnp2)
        sLine += sprintf("%8.2f", _subarea_info.fnp5)
        sLine += sprintf("%8.2f", _subarea_info.firg)
        @subarea_file.push(sLine + "\n")
		#/line 11
        sLine = sprintf("%4d", _subarea_info.ny1)
        sLine += sprintf("%4d", _subarea_info.ny2)
        sLine += sprintf("%4d", _subarea_info.ny3)
        sLine += sprintf("%4d", _subarea_info.ny4)
        @subarea_file.push(sLine + "\n")
		#/line 12            
        sLine = sprintf("%8.2f", _subarea_info.xtp1)
        sLine += sprintf("%8.2f", _subarea_info.xtp2)
        sLine += sprintf("%8.2f", _subarea_info.xtp3)
        sLine += sprintf("%8.2f", _subarea_info.xtp4)
        @subarea_file.push(sLine + "\n")

        return "OK"
    end

	def create_operations(soil, operation_number)
	    #This suroutine create operation files for Baseline and Alternative using information entered by user.
        nirr = 0
        #verify if _crops are empty. if so get them.
        @fert_code = 79
        grazingb = false
		@opcs_file = Array.new
        #@opcs_file.push("Operation" + "\n")
		irrigation_type = 0
		bmp = Bmp.where("scenario_id = " + session[:scenario_id].to_s + " and irrigation_id > 0").first		
		irrigation_type = Irrigation.find(bmp.irrigation_id).code unless bmp == nil
        #SORT operation records by date (year, month, day)
        #Dim query As IEnumerable(Of OperationsData)
        #query = From r In soil._scenariosInfo(currentScenarioNumber)._operationsInfo Order By r.Year, r.Month, r.Day, r.ApexOpName, r.EventId
        #check and fix the operation list
		@soil_operations = SoilOperation.where("soil_id == " + soil.id.to_s + " and scenario_id == " + @scenario.id.to_s)
		#todo when the map is saved again the number of soils in SoilOperation are not updated we can use something like SoilOperation.where(:soil_id => 1698).update_all(:soil_id => 1703)
		
		if @soil_operations.count > 0 then
			#fix_operation_file()
			#line 1
			@opcs_file.push(" .Opc file created directly by the user. Date: " + @dtNow1 + "\n")
			j = 0

			@soil_operations.each do |soil_operation|
				# ask for 1=planting, 5=kill, 3=tillage
				if soil_operation.apex_crop == CropMixedGrass && (soil_operation.activity_id == 1 || soil_operation.activity_id == 5 || soil_operation.activity_id == 3) then
				    #todo check this one
					#mixed_crops = operation.MixedCropData.Split(",")
					#mixedCropsInfo(2) As String
					#newOper As OperationsData

					#for Each value In mixedCrops
					#    newOper = New OperationsData
					#    newOper = AddMixedOperations(operation)
					#    mixedCropsInfo = value.Split("|")
					#    newOper.ApexCrop = mixedCropsInfo(0)
					#    newOper.OpVal5 = mixedCropsInfo(2) / ac_to_m2
					#    newOper.setCN(newOper.ApexCrop, "", _fieldsInfo1.Count, soil.Group, currentFieldNumber, _startInfo, Session("UserGuide"))
					#    AddOperation(newOper, irrigation_type, nirr, soil.Percentage, j)
					#end
				else
					add_operation(soil_operation, irrigation_type, nirr, soil.percentage, j)
				end # end if
				j+=1
			end #end soil_operations.each do
			# add to the tillage file the new fertilizer operations - one for each depth
			append_file("tillOrg.dat", true, "till.dat", "till")
			append_file("fertOrg.dat", true, "fert.dat", "fert")
			#print_array_to_file(@opcs_file, "APEX" + (@soil_number+1).to_s.rjust(3, '0') + ".opc")  #print operation files
			msg = send_file_to_APEX(@opcs_file, "APEX" + (@soil_number+1).to_s.rjust(3, '0') + ".opc")
			@opcs_list_file.push((@soil_number+1).to_s.rjust(5, '0') + " " + "APEX" + (@soil_number+1).to_s.rjust(3, '0') + ".opc" + "\n")
		end #end if 
        #@opcs_file.push("End Operation")
		#print_array_to_file(@subarea_file, "APEX.sub")
        return nirr
	end  #end Create Operations

	def fix_operation_file()
        #drOuts = SoilOperation.new
		
		if @soil_operations.count > 0 then
			total_records = @soil_operations.count - 1
			first_date = sprintf("%2d", @soil_operations[0].month) + sprintf("%2d",@soil_operations[0].day)
			last_date = sprintf("%2d", @soil_operations[total_records].month) + sprintf("%2d",@soil_operations[total_records].day)
			if first_date > last_date then
				last_year = sprintf("%2d",@soil_operations[total_records].year)
				#if this is the case the operation for the last year need to be put before the first record.
				for i in 0..@soil_operations.count-1
					if last_year = @soil_operations[i].year then
						break
					end
				end
				for j in i..@soil_operations.count - 1
					#drOut = SoilOperation.new
					#drOut = drIn(j)
					@soil_operations[j].year = "1"
					#drOuts.Add(drOut)
				end
				#if i > 0 then
					#for j = 0 To i - 1
						#drOut = drIn(j)
						#drOuts.Add(drOut)
					#next
				#end
				#Return drOuts
			#else
				#Return drIn
			end
		end
    end

    def add_operation(operation, irrigation_type, nirr, soil_percentage, j)
		items = Array.new
		values = Array.new
        crop_ant = 0
        oper_ant = 799
        found = false
        #Dim animalCode As Short = 0
        #Dim cn As Single = 0

        for i in 0..(8 - 1)
            items[i] = ""
            values[i] = 0
        end
        items[7] = "LATITUDE"
        items[8] = "LONGITUDE"
        apex_string = ""

        if crop_ant != operation.apex_crop then
			crop = Crop.find_by_number(operation.apex_crop)
            if crop != nil then
                #if crop.number == operation.apex_crop then
                    lu_number = crop.lu_number
                    harvest_code = crop.harvest_code
                    filter_strip = crop.type1
                #end
            end
            crop_ant = operation.apex_crop
        end
        #if the process is starting the lines 1, 2 should be created
        if j == 0 then
            if irrigation_type > 0 then
                @opcs_file.push(sprintf("%4d", lu_number) + sprintf("%4d", irrigation_type) + "\n")
            else
                @opcs_file.push(sprintf("%4d", lu_number) + "\n")
            end
            if irrigation_type == 7 then #ADD BILD FURROW DIKE OPERATION for baseline
                @opcs_file.push(sprintf("%3d", 1) + sprintf("%3d", 1) + sprintf("%3d", 2) + sprintf("%5d", 256) + sprintf("%5d", 0) + sprintf("%5d", operation.number) + "\n")
            end
        end

        opv5 = "\s" + "\s" + "\s" + "\s" + "\s"
        apex_string += sprintf("%3d", operation.year)           #Year
        apex_string += sprintf("%3d", operation.month)          #Month
        if operation.month == 12 && operation.day == 31 then
            apex_string += sprintf("%3d" ,30)           #Day
        else
            apex_string += sprintf("%3d", operation.day)                 #Day
        end
		#planting =1, tillage = 3, harvest = 4
        if operation.activity_id == 1 || operation.activity_id == 3 || operation.activity_id == 4 || operation.activity_id == 6 then
			apex_string += sprintf("%5d", operation.apex_operation)    #Operation Code        #APEX0604			
        else
            if operation.activity_id == 2 then #fertilizer 
                found = false
                if @depth_ant != nil then
                    for n in 0..@depth_ant.count - 1
                        if @depth_ant[n] = operation.opv2 then
                            oper_ant = @opers[n]
                            found = true
                        end
                    end
                    num_of_depths= @depth_ant.count - 1
                else
                    num_of_depths= 0
                end

                if found == false then
                    oper_ant = oper_ant + 1
                    @opers.push(oper_ant)
					@depth_ant.push(operation.opv2)
                    change_till_for_depth(oper_ant, @depth_ant[@depth_ant.count - 1]) unless @depth_ant == nil					
                end
                apex_string += sprintf("%5d", oper_ant)    #Operation Code        #APEX0604
            else
                #apex_string += operation.ApexTillCode.ToString.PadLeft(5))    #Operation Code        #APEX0604
				apex_string += sprintf("%5d", operation.apex_operation)    #Operation Code        #APEX0604			
            end
        end  #end if 1, 3, or 4

        apex_string += "     "                           #Tractor ID. Not Used  #APEX0604
        apex_string += sprintf("%5d", operation.apex_crop)    #Crop Code             #APEX0604
        case operation.activity_id
            when 1   #planting
                if operation.apex_crop == "18" then
                    rice_crop = true
                end
                if lu_number == 28 then
                    if operation.apex_crop == 108 || operation.apex_crop = 152 then

                    end
                    apex_string += sprintf("%5d", filter_strip)
                else
                    apex_string += sprintf("%5d", 0)    #TIME TO MATURITY       #APEX0604
                end
                #if operation.opv1 == 0 then
					#uri = URI.parse(URL_HU +  "?op=getHU&crop=operation.apex_crop&nlat=" + Weather.find_by_field_id(session[:field_id]).latitude.to_s + "&nlon=" + Weather.find_by_field_id(session[:field_id]).longitude.to_s)
					#uri.open
					#operation.opv1 = uri.read
					#operation.opv1 = endpoint.post("op=getHU&crop=operation.apex_crop&nlat=" + Weather.find_by_field_id(session[:field_id]).latitude + "&nlon=" + Weather.find_by_field_id(session[:field_id]).longitude)
                    #Dim getHu As New GetHU
                    #operation.opv1 = getHu.calcHU(operation.apex_crop, wp1Files + "\" + _startInfo.Wp1Name + ".WP1", folder + "\App_Data\PHUCRP.DAT")
                    #operation.opv1 = calcHU(operation.apex_crop, _crops, _startInfo)
                #end
                apex_string += sprintf("%8.2f", operation.opv1)  
                items[0] = "Heat Units"
                values[0] = operation.opv1
				items[1] = "Curve Number"
				values[1] = operation.opv2
				bmps_count = Bmp.where(:bmpsublist_id == 4 || :bmpsublist_id == 5 || :bmpsublist_id == 6 || :bmpsublist_id == 7).count
                #With _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo
                    #if .PPNDWidth > 0 Or .PPDSWidth > 0 Or .PPDEWidth > 0 Or .PPTWWidth > 0 then
					if bmps_count > 0 then
                        apex_string += sprintf("%8.1f", (operation.opv2 * 0.9))   #curve number
                    else
                        apex_string += sprintf("%8.1f", operation.opv2)  #curve number
                    end
                #End With
                apex_string += sprintf("%8.2f", operation.opv3)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", operation.opv4)                      #Opv4. No entry needed.
				
				operation.opv5 == nil ? apex_string += sprintf("%8.2f", 0) : operation.opv5 < 0.01 ? apex_string += sprintf("%8.6f", operation.opv5) : apex_string += sprintf("%8.2f", operation.opv5) #Opv 5 Plant Population.
            when 6 #irrigation
                apex_string += sprintf("%5d", 0)    #
                items[0] = "Irrigation"
                values[0] = operation.opv2
                apex_string += sprintf("%8.2f", operation.opv1)  #Volume applied for irrigation in mm
                nirr = 1
                apex_string += sprintf("%8.2f", 0)             #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0) & sprintf("%8.2f", operation.opv2)  #Opv4 Irrigation Efficiency
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 2  # fertilizer            #fertilizer or fertilizer(folier)
                #if operation.activetApexTillName.ToString.ToLower.Contains("fert") then
					oper = Operation.where(:id => operation.operation_id).first
                    add_fert(oper.no3_n, oper.po4_p, oper.org_n, oper.org_p, Operation.find(operation.operation_id).type_id, oper.nh3, oper.subtype_id)
                    apex_string += sprintf("%5d", @fert_code)    #Fertilizer Code       #APEX0604
                    items[0] = @fert_code
                #else
                    #apex_string += sprintf("%5d", operation.subtype)    #Fertilizer Code       #APEX0604
                    #items[0] = operation.subtype
                #end
                apex_string += sprintf("%8.2f", operation.opv1)  #kg/ha of fertilizer applied
                values[0] = operation.opv1
                apex_string += sprintf("%8.2f", operation.opv2)
                items[1] = "Depth"
                values[1] = operation.opv2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 7 # grazing              #Grazing - kind and number of animals 
                apex_string += sprintf("%5d", 0)    #
                #if number of animals were enter in modify page and it is the first grazing operation
                if grazingb == false then
                    items[3] = "DryMatterIntake"
					#TODO create_herd file and send to APEX
                    values[3] = create_herd_file(operation.opv1, operation.opv2, operation.ApexTillName, soil_percentage)
                    animalB = operation.ApexTillCode
                    grazingb = true
                    if operation.no3 != 0 || operation.po4 != 0 || operation.org_n != 0 || operation.org_p != 0 || operation.nh3 != 0 then
                        animal_code = get_animal_code(operation.ApexTillCode)
                        change_fert_for_grazing(operation.no3, operation.po4, operation.org_n, operation.org_p, animal_code, operation.nh3)
                    end
                end
                apex_string += sprintf("%8.4f", operation.opv1)
                items[0] = "Kind"
                values[0] = operation.ApexTillCode
                items[1] = "Animals"
                values[1] = operation.ApexOpv1
                items[2] = "Hours"
                values[2] = operation.ApexOpv2
                apex_string += sprintf("%8.2f", 0)             #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 3   #tillage
                apex_string += sprintf("%5d", 0)
                apex_string += sprintf("%8.2f", 0)
                items[0] = "Tillage"
                values[0] = 0
                apex_string += sprintf("%8.2f", 0)            #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 4   #harvest
                apex_string += sprintf("%5d", 0)    #
                apex_string += sprintf("%8.2f", 0)
                items[1] = "Curve Number"
                values[1] = operation.opv2
                if Field.find(session[:field_id]).field_type then
					#todo test this. ApexTillCode is not part of operations
                    change_till_for_HE(operation.ApexTillCode, operation.opv1)
                end
                apex_string += sprintf("%8.2f", 0)						#opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 5   #kill
                apex_string += sprintf("%5d", 0)    #
                apex_string += sprintf("%8.2f", 0)
                items[0] = "Curve Number"
                values[0] = operation.opv2
                items[1] = "Time of Operation"
                values[1] = operation.opv2
                apex_string += sprintf("%8.2f", 0)        #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 8   #stopGrazing
                apex_string += sprintf("%5d", 0)    #
                apex_string += sprintf("%8.2f", 0)
                items[0] = "Stop Grazing"
                values[0] = 0
                apex_string += sprintf("%8.2f", 0)       #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
            when 10   # liming
                apex_string += sprintf("%5d", 0)    #
                apex_string += sprintf("%8.2f", operation.opv1)  #kg/ha of fertilizer applied
            else                                               #No entry needed.
                apex_string += sprintf("%5d", 0)    #
                apex_string += sprintf("%8.2f", 0)       #opval1
                apex_string += sprintf("%8.2f", 0)       #opval2
                apex_string += sprintf("%8.2f", 0)                      #Opv3. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv4. No entry needed.
                apex_string += sprintf("%8.2f", 0)                      #Opv5. No entry neede.
        end #end case true

        apex_string += sprintf("%8.2f", operation.opv6)                    #Opv6
        apex_string += sprintf("%8.2f", operation.opv7)                    #Opv7
        j += 1
        @opcs_file.push(apex_string + "\n")

        #add operations in list for fem.
		#scenario = Scenario.find(params[:id])
        #With _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)
		operation_name = ""
		case operation.activity_id
			when 1, 3
				operation_name = Tillage.find_by_code(operation.apex_operation).name
			else
				operation_name = Activity.find(operation.activity_id).name
		end 
        @fem_list.push(@scenario.name + COMA + @scenario.name + COMA + State.find(Location.find(session[:location_id]).state_id).state_abbreviation + COMA + operation.year.to_s + COMA + operation.month.to_s + COMA + operation.day.to_s + COMA + operation.apex_operation.to_s + COMA + operation_name + COMA + operation.apex_crop.to_s +
                COMA + Crop.find(operation.apex_crop).name + COMA + @soil_operations.last.year.to_s + COMA + "0" + COMA + "0" + COMA + items[0].to_s + COMA + values[0].to_s + COMA + items[1].to_s + COMA + values[1].to_s + COMA + items[2].to_s + COMA + values[2].to_s + COMA + items[3].to_s + COMA + values[3].to_s + COMA + items[4].to_s + COMA +
				values[4].to_s + COMA + items[5] + COMA + values[5].to_s + COMA + items[6] + COMA + values[6].to_s + COMA + items[7] + COMA + values[7].to_s + COMA + items[8] + COMA + values[8].to_s)
        #End With
    end  # end add_operation method

	def append_file(original_file, copy_file, target_file, file_type)
		path = File.join(APEX, "APEX" + session[:session_id])
		if copy_file then
			FileUtils.cp(File.join(APEX_ORIGINAL, original_file), File.join(path, target_file))
		else
			target_file = original_file
		end
		case file_type
			when "till"
				File.open(File.join(path, target_file), "a+") do |f| 
					@change_till_depth.each do |row| f << row end
				end
			when "fert"				
				File.open(File.join(path, target_file), "a+") do |f| 
					@new_fert_line.each do |row| f << row end
				end
		end #end case file_type
		msg = send_file_to_APEX(read_file(target_file, false), target_file)
		#todo chcek how this will work with fert changing for grazing and fert appliction at the same time. Suggestion. firs get the changes for both and then change the fert file.
	end

	def add_fert(no3n, po4p, orgN, orgP, type, nh3, subtype)
        k = 0
        exist = false
        count = 0

        @current_nutrients.each do |current_nutrient|
            if current_nutrient.no3 == no3n && current_nutrient.po4 == po4p && current_nutrient.orgn == orgN && current_nutrient.orgp == orgP then
                exist = true
                @fert_code = current_nutrient.code
                break
            end
        end
		
        if !exist then		
            @fert_code += 1
			@current_nutrients.push(@nutrients_structure.new(@fert_code, no3n, po4p, orgN, orgP))
            newLine = sprintf("%5d", @fert_code)
            newLine = newLine + " " + "Fert " + sprintf("%2d", @fert_code) + " "
            if no3n == nil then newLine += sprintf("%8.4f", 0) else newLine += sprintf("%8.4f", no3n) end
            if po4p == nil then newLine += sprintf("%8.4f", 0) else newLine += sprintf("%8.4f", po4p) end
            if k == nil then newLine += sprintf("%8.4f", 0) else newLine += sprintf("%8.4f", k) end
            if orgN == nil then newLine += sprintf("%8.4f", 0) else newLine += sprintf("%8.4f", orgN) end
            if orgP == nil then newLine += sprintf("%8.4f", 0) else newLine += sprintf("%8.4f", orgP) end
            orgC = 0
            case type
                when 1   #commercial
                    nh3 = 0
                when 2   #Manure
					if subtype == 57 then
						orgC = 0.15   #liquide
					else
						orgC = 0.35   #solid
					end 
            end
			if nh3 == nil then newLine = newLine + " " + sprintf("%7.4f", 0) else newLine = newLine + " " + sprintf("%7.4f", nh3) end
            if orgC == nil then newLine = newLine + " " + sprintf("%7.4f", 0) else newLine = newLine + " " + sprintf("%7.4f", orgC) end
            newLine = newLine + "   0.000   0.000\n"
            @new_fert_line.push(newLine)
        end
    end  #end add_fert method

	def change_till_for_depth(oper, depthAnt)
        newLine = "  " + oper.to_s	
        newLine += " C:FERT 5 CUST      5.      0.      0.      0.      0.     0.0    0.00   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000"
        newLine += sprintf("%8.2f", depthAnt * 25.4)
        newLine += "   0.000   0.000   0.000   0.000   9.000   0.000   0.000   0.000   0.000   5.000   5.363  FERTILIZER APP        " + oper.to_s + "\n"
        @change_till_depth.push(newLine)
    end

    def change_fert_for_grazing(no3n, po4p, org_n, org_p, fert, nh3)
        newLine = sprintf("%5d", fert)
        newLine = newLine + " " + "Manure  "
        newLine = newLine + " " + sprintf("%7.4f", no3n)
        newLine = newLine + " " + sprintf("%7.4f", po4p)
        newLine = newLine + " " + sprintf("%7.4f", 0)
        newLine = newLine + " " + sprintf("%7.4f", org_n)
        newLine = newLine + " " + sprintf("%7.4f", org_p)
        newLine = newLine + " " + sprintf("%7.4f", nh3)
        newLine = newLine + "   0.350   0.000   0.000"
        @change_fert_for_grazing_line.Add(newLine)
    end

	def print_string_to_file(data, file)
		path = File.join(APEX, "APEX" + session[:session_id])
		FileUtils.mkdir(path) unless File.directory?(path)
		path = File.join(path, file)
		File.open(path, "w+") do |f|
			f << data
			f.close  
		end
	end

	def print_array_to_file(data, file)
		path = File.join(APEX, "APEX" + session[:session_id])
		FileUtils.mkdir(path) unless File.directory?(path)
		path = File.join(path, file)
		File.open(path, "w+") do |f|
			data.each do |row| 
				f << row
			end
			f.close  
		end
	end

	def print_wind_to_file(data, file)
		path = File.join(APEX, "APEX" + session[:session_id])
		FileUtils.mkdir(path) unless File.directory?(path)
		path = File.join(path, file)
		File.open(path, "w+") do |f|
			data.each do |row| 
				f << row 
				f << "\n"
			end
			f.close  
		end
	end

	def cal_satc(sand_in, clay_in, org_matter_in, density_factor_in, gravels_in, salinity_in) 
		wilt_out = -0.024 * sand_in + 0.487 * clay_in + 0.006 * org_matter_in + 0.005 * sand_in * org_matter_in - 0.013 * clay_in * org_matter_in + 0.068 * sand_in * clay_in + 0.031 + 
				0.14 * (-0.024 * sand_in + 0.487 * clay_in + 0.006 * org_matter_in + 0.005 * sand_in * org_matter_in - 0.013 * clay_in * org_matter_in + 0.068 * sand_in * clay_in + 0.031) - 0.02

		y = -0.251 * sand_in + 0.195 * clay_in + 0.011 * org_matter_in + 0.006 * sand_in * org_matter_in - 0.027 * clay_in * org_matter_in + 0.452 * sand_in * clay_in + 0.299

		x = 0.278 * sand_in + 0.034 * clay_in + 0.022 * org_matter_in - 0.018 * sand_in * org_matter_in - 0.027 * clay_in * org_matter_in - 0.584 * sand_in * clay_in + 0.078 + 
			(0.636 * (0.278 * sand_in + 0.034 * clay_in + 0.022 * org_matter_in - 0.018 * sand_in * org_matter_in - 0.027 * clay_in * org_matter_in - 0.584 * sand_in * clay_in + 0.078) - 0.107) + 
			y + (1.283 * y * y - 0.374 * y - 0.015) + -0.097 * sand_in + 0.043

		#I18=1.0
		matric_den_out = (1 - x) * 2.65 * 1.0
		field_cap_out = y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65))

		saturation_out = 1 - (matric_den_out / 2.65)

		plant_avail_out = (field_cap_out - wilt_out) * (1 - ((matric_den_out / 2.65) * gravels_in) / (1 - gravels_in * (1 - matric_den_out / 2.65)))

		z = -0.024 * sand_in + 0.487 * clay_in + 0.006 * org_matter_in + 0.005 * sand_in * org_matter_in - 0.013 * clay_in * org_matter_in + 0.068 * sand_in * clay_in + 0.031 + 
			0.14 * (-0.024 * sand_in + 0.487 * clay_in + 0.006 * org_matter_in + 0.005 * sand_in * org_matter_in - 0.013 * clay_in * org_matter_in + 0.068 * sand_in * clay_in + 0.031) - 0.02
		i = (Math::log(y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65))) / Math::log(2.718281828) - Math::log(z) / Math::log(2.718281828)) / (Math::log(1500) / Math::log(2.718281828) - Math::log(33) / Math::log(2.718281828))
		sat_cond_out = 1930 * ((1 - (matric_den_out / 2.65)) - (y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65)))) ** (3 - i) * (1 - gravels_in) / (1 - gravels_in * (1 - 1.5 * (matric_den_out / 2.65)))

		j = 1 - (matric_den_out / 2.65) - (y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65)))
		k = -21.674 * sand_in - 27.932 * clay_in - 81.975 * j + 71.121 * sand_in * j + 8.294 * clay_in * j + 14.05 * sand_in * clay_in + 27.161

		air_entry_out = y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65)) - (10 - 33) * ((1 - (matric_den_out / 2.65)) - (y + (1.283 * y * y - 0.374 * y - 0.015) + 0.2 * ((1 - matric_den_out / 2.65) - (1 - ((1 - x) * 2.65) / 2.65)))) / (33 - (k + (0.02 * k ** 2 - 0.113 * k - 0.7)))

		gravels_out = ((matric_den_out / 2.65) * gravels_in) / (1 - gravels_in * (1 - matric_den_out / 2.65))

		bulk_density_out = gravels_out * 2.65 + (1 - gravels_out) * matric_den_out
		return sat_cond_out
	end

	def run_scenario()
		#path = File.join(APEX, "APEX" + session[:session_id])
		#file_name = File.join(path, "APEX001.NTT")
		#File.delete(file_name) if File.exist?(file_name)				
		#file_name = File.join(path, "APEX001.msw")  #monthly values for flow, nutrients, and sediment
		#File.delete(file_name) if File.exist?(file_name)					
		#file_name = File.join(path, "APEX001.mws")  #monthly values for flow, nutrients, and sediment
		#File.delete(file_name) if File.exist?(file_name)
		#curret_directory = Dir.pwd
		#Dir.chdir path
		#result = system("apex0806.exe")
		#Dir.chdir curret_directory
	end

end
