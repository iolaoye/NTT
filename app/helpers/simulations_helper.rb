module SimulationsHelper
  PHMIN = 3.5
  PHMAX = 9.0
  OCMIN = 0.0 #change from 0.5 to 0 according to Ali. APEX calculate it if 0.
  OCMAX = 2.5
  OM_TO_OC = 1.724
  BDMIN = 1.1
  BDMAX = 1.79
  SoilPMaxForSoilDepth = 15.24
  SoilPDefault = 3.0
  CropMixedGrass = 367
  COMA = ", "

  def create_control_file()
    @apex_control = ""
    @apex_controls = ApexControl.where(:project_id => params[:project_id])
    require 'net/http'
	if @apex_controls.count == 76 then
		ap = ApexControl.new
		ap.project_id = @project.id
		ap.control_description_id = 77
		ap.value = 0
		ap.save
		ap = ApexControl.new
		ap.project_id = @project.id
		ap.control_description_id = 78
		ap.value = 1
		ap.save
	end
	@apex_controls = ApexControl.where(:project_id => params[:project_id])
    @apex_controls.each do |c|
      case c.control_description_id
        when 1..19 #line 1
          @apex_control += sprintf("%4d", c.value)
        when 20
          @apex_control += sprintf("%4d", c.value) + "\n"
        when 21..37 #line 2
          @apex_control += sprintf("%4d", c.value)
        when 38
          @apex_control += sprintf("%4d", c.value) + "\n"
        when 39..47 #line 3
          @apex_control += sprintf("%8.2f", c.value)
        when 48
          @apex_control += sprintf("%8.2f", c.value) + "\n"
        when 49..57 #line 4
          @apex_control += sprintf("%8.2f", c.value)
        when 58
          @apex_control += sprintf("%8.2f", c.value) + "\n"
        when 59..67 #line 5
          @apex_control += sprintf("%8.2f", c.value)
        when 68
          @apex_control += sprintf("%8.2f", c.value) + "\n"
        when 69..77 #line 6
          @apex_control += sprintf("%8.2f", c.value)
        when 78
          @apex_control += sprintf("%8.2f", c.value) + "\n"
		  #line 7
		  @apex_control += sprintf("%8.2f", 200)  #todo. this is temporary adding BNO3  Line 7 col 1
		  @apex_control += sprintf("%8.2f", 60)  #todo. this is temporary adding BAP(1)  Line 7 col 2
		  @apex_control += sprintf("%8.2f", 120)  #todo. this is temporary adding BAP(2)  Line 7 col 3
		  @apex_control += sprintf("%8.2f", 200)  #todo. this is temporary adding BAP(3)  Line 7 col 4
      end
    end
    #msg = send_file_to_APEX(apex_string, "Apexcont.dat")
	msg = "OK"
  end

  def send_files_to_APEX(file)
    uri = URI('http://nn.tarleton.edu/NNMultipleStates/NNRestService.ashx')
    #uri = URI('http://45.40.132.224/NNMultipleStates/NNRestService.ashx')
    res = Net::HTTP.post_form(uri, "data" => @apex_control, "file" => file, "folder" => session[:session_id], "rails" => "yes", "parm" => @apex_parm, "site" => @apex_site, "wth" => @apex_wth)
    if res.body.include?("Created") then
      return "OK"
    else
      return res.body
    end
  end

  def send_files1_to_APEX(file)
    uri = URI('http://nn.tarleton.edu/NNMultipleStates/NNRestService.ashx')
    #uri = URI('http://45.40.132.224/NNMultipleStates/NNRestService.ashx')
    res = Net::HTTP.post_form(uri, "data" => "RUN", "file" => file, "folder" => session[:session_id], "rails" => "yes", "parm" => @soil_list, "site" => @subarea_file, "wth" => @opcs_list_file)
    if res.body.include?("Created") then
      return "OK"
    else
      return res.body
    end
  end

  def send_file_to_APEX(apex_string, file)
    uri = URI('http://nn.tarleton.edu/NNMultipleStates/NNRestService.ashx')
    #uri = URI('http://45.40.132.224/NNMultipleStates/NNRestService.ashx')
    res = Net::HTTP.post_form(uri, "data" => apex_string, "file" => file, "folder" => session[:session_id], "rails" => "yes", "parm" => "", "site" => "", "wth" => "")
    if res.body.include?("Created") then
      return "OK"
    else
      return res.body
    end
  end

  def send_file1_to_APEX(apex_string, file)
    uri = URI('http://nn.tarleton.edu/NNMultipleStates/NNRestService.ashx')
    res = Net::HTTP.post_form(uri, "data" => apex_string, "file" => file, "folder" => session[:session_id], "rails" => "yes", "parm" => "", "site" => "", "wth" => "")
    if res.body.include?("Created") then
      return "OK"
    else
      return res.body
    end
  end

  def create_parameter_file()
    @apex_parm = ""
    @apex_parm +="  90.050  99.950" + "\n"
    @apex_parm +="   10.50  100.95" + "\n"
    @apex_parm +="   50.10   95.95" + "\n"
    @apex_parm +="    0.00    0.00" + "\n"
    @apex_parm +="   25.05   75.90" + "\n"
    @apex_parm +="    5.10  100.95" + "\n"
    @apex_parm +="    5.25   50.95" + "\n"
    @apex_parm +="    20.5   80.99" + "\n"
    @apex_parm +="    1.10   10.99" + "\n"
    @apex_parm +="   10.05  100.90" + "\n"
    @apex_parm +="    5.01   20.90" + "\n"
    @apex_parm +="    5.05  100.50" + "\n"
    @apex_parm +="    1.80    3.99" + "\n"
    @apex_parm +="    5.10   20.95" + "\n"
    @apex_parm +="   10.10  100.95" + "\n"
    @apex_parm +="    3.10   20.99" + "\n"
    @apex_parm +="   20.10   50.95" + "\n"
    @apex_parm +="    5.10   50.30" + "\n"
    @apex_parm +="   10.01   25.95" + "\n"
    @apex_parm +="  400.05  600.80" + "\n"
    @apex_parm +="    10.5   100.9" + "\n"
    @apex_parm +="  100.01  1000.9" + "\n"
    @apex_parm +="    1.50    3.99" + "\n"
    @apex_parm +="    1.25    5.95" + "\n"
    @apex_parm +="   50.10   55.90" + "\n"
    @apex_parm +="                " + "\n"
    @apex_parm +="                " + "\n"
    @apex_parm +="                " + "\n"
    @apex_parm +="                " + "\n"
    @apex_parm +="   50.00   10.00" + "\n"
    apex_parameter = ApexParameter.where(:project_id => params[:project_id])
    apex_parameter.each do |p|
      #number = Parameter.find(p.parameter_description_id).number
      case p.parameter_description_id
        when 10, 20, 30, 50, 60, 70, 80, 90
          @apex_parm += sprintf("%8.2f", p.value) + "\n"
        when 19, 36, 65, 76, 87, 88
          @apex_parm += sprintf("%8.3f", p.value)
        when 40
          @apex_parm += sprintf("%8.3f", p.value) + "\n"
        when 23, 43, 55, 58, 84, 85
          @apex_parm += sprintf("%8.4f", p.value)
        when 39
          @apex_parm += sprintf("%8.5f", p.value)
        else
          @apex_parm += sprintf("%8.2f", p.value)
      end #end case p.line
    end #end each do p
    @apex_parm +="\n"
    @apex_parm +="    .044     31.     .51     .57     10." + "\n"
    @apex_parm +=" " + "\n"
    #msg = send_files_to_APEX("FILES")
	return "OK"
  end

  def create_site_file(field_id)
    site = Site.find_by_field_id(field_id)
    #site_file = Array.new
    @apex_site = ""
    @apex_site +=
    @apex_site += " .sit file Subbasin:1  Date: " + @dtNow1 + "\n"
    @apex_site += "" + "\n"
    @apex_site += "" + "\n"
    @apex_site += sprintf("%8.2f", site.ylat) + sprintf("%8.2f", site.xlog) + sprintf("%8.2f", site.elev) +
    sprintf("%8.2f", site.apm) + sprintf("%8.2f", site.co2x) + sprintf("%8.2f", site.cqnx) + sprintf("%8.2f", site.rfnx) +
    sprintf("%8.2f", site.upr) + sprintf("%8.2f", site.unr) + sprintf("%8.2f", site.fir0)
    for i in 5..25 #print 21 additonal lines in the site file, which do not need any information at this time.
      @apex_site += "" + "\n"
    end # end for
    #msg = send_files_to_APEX("FILES")
    #print_array_to_file(site_file, "APEX.sit")
	return "OK"
  end

  def create_wind_wp1_files()
	county_id = @project.location.county_id
	if county_id > 0
		county = County.find(county_id)
	else
		county = nil
	end
    if county != nil then
		wind_wp1_name = county.wind_wp1_name
		wind_wp1_code = county.wind_wp1_code
	else
		wind_wp1_name = "CHINAG"
		wind_wp1_code = 999
	end
    apex_run_string = "APEX001   1IWPNIWND   1   0   0"
    client = Savon.client(wsdl: URL_Weather)
	###### create wp1 file from weather and send to server ########
    #response = client.call(:create_wp1_from_weather1, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => wind_wp1_name, "code" => wind_wp1_code})
    #response = client.call(:create_wp1_from_weather2, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => wind_wp1_name, "pgm" => 'APEX'})
	response = client.call(:create_wp1_from_weather2, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => wind_wp1_name, "code" => county.county_state_code})
    #weather_data = response.body[:create_wp1_from_weather2_response][:create_wp1_from_weather2_result][:string]
    if response.body[:create_wp1_from_weather2_response][:create_wp1_from_weather2_result] == "created" then
		return "OK"
	else
		return "Error creating wp1 and wind files"
	end

    #msg = send_file_to_APEX(weather_data.join("\n"), wind_wp1_name + ".wp1")
    #client = Savon.client(wsdl: URL_Weather)
	######### create eind file and send to server ########
    #response = client.call(:get_weather, message: {"path" => WIND + "/" + wind_wp1_name + ".wnd"})
    #weather_data = response.body[:get_weather_response][:get_weather_result][:string]
    #msg = send_file_to_APEX(weather_data.join("\n"), wind_wp1_name + ".wnd")
	######### create apexrun file and send to server ########
    #apex_run_string["IWPN"] = sprintf("%4d", wind_wp1_code)
    #apex_run_string["IWND"] = sprintf("%4d", wind_wp1_code)
    #msg = send_file_to_APEX(apex_run_string, "Apexrun.dat")
  end

  def create_weather_file(dir_name, field_id)
    #todo weather file are more than one when there are different fields such as in watershed simulation.
    weather = Weather.find_by_field_id(field_id)
    if (weather.way_id == 2)
      #copy the file path
      path = File.join(OWN, weather.weather_file)
	  if File.exist?(path) then FileUtils.cp_r(path, dir_name + "/APEX.wth") else return "You need to upload your weather file before trying to simulate scenarios" end
      @apex_wth = read_file(File.join(OWN, weather.weather_file), true)
    else
      path = File.join(PRISM1, weather.weather_file)
      #client = Savon.client(wsdl: URL_Weather)
      #response = client.call(:get_weather, message:{"path" => PRISM + "/" + weather.weather_file})
      #weather_data = response.body[:get_weather_response][:get_weather_result][:string]
      #print_array_to_file(PATH, "APEX.wth")
      @apex_wth = send_file1_to_APEX("WTH", path)
    end
    #todo after file is copied if climate bmp is in place modified the weather file.
    bmp_id = Bmp.select(:id).where(:scenario_id => @scenario.id)
    climate_array = Array.new
    climates = Climate.where(:bmp_id => bmp_id)
    climates.each do |climate|
      climate_array = update_hash(climate, climate_array)
    end
    if climates.first != nil
      @apex_wth.each_line do |day|
        month = @apex_wth[6, 4].to_i
        max_input = climate_array[month]["max"]
        min_input = climate_array[month]["min"]
        pcp_input = climate_array[month]["pcp"] / 100
        max_file = @apex_wth[20, 6].to_f
        min_file = @apex_wth[26, 6].to_f
        pcp_file = @apex_wth[32, 7].to_f
        if max_input != 0
          max = max_file + max_input
          max = sprintf("%.1f", max)
          while max.length < 6
            max = " " + max
          end
          @apex_wth[20, 6] = max
        end #end if max
        if min_input != 0
          min = min_file + min_input
          min = sprintf("%.1f", min)
          while min.length < 6
            min = " " + min
          end
          @apex_wth[26, 6] = min
        end #end if min
        if pcp_input != 0
          pcp = pcp_file + pcp_file * pcp_input
          pcp = sprintf("%.2f", pcp)
          while pcp.length < 7
            pcp = " " + pcp
          end
          @apex_wth[32, 7] = pcp
        end #end if pcp
      end # end each
    end #end if
    #msg = send_file_to_APEX(@apex_wth, "APEX.wth")
    #todo fix widn and wp1 files with the real name
	#msg = send_files_to_APEX("FILES")
	return "OK"
  end

  def create_soils()
    msg = "OK"
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
      end # end layers do

      @bulk_density = bulk_density
      #if first layer is less than 0.1 m a new layer is added as first one
      initial_layer = 1
      #if (depth[initial_layer] / 100).round(3) > 0.100
        #initial_layer = 0
        #depth[initial_layer] = 10.0
        #bulk_density[initial_layer] = bulk_density[initial_layer + 1]
        #uw[initial_layer] = uw[initial_layer + 1]
        #fc[initial_layer] = fc[initial_layer + 1]
        #sand[initial_layer] = sand[initial_layer + 1]
        #silt[initial_layer] = silt[initial_layer + 1]
        #wn[initial_layer] = wn[initial_layer + 1]
        #ph[initial_layer] = ph[initial_layer + 1]
        #smb[initial_layer] = smb[initial_layer + 1]
        #woc[initial_layer] = woc[initial_layer + 1]
        #cac[initial_layer] = cac[initial_layer + 1]
        #cec[initial_layer] = cec[initial_layer + 1]
        #rok[initial_layer] = rok[initial_layer + 1]
        #cnds[initial_layer] = cnds[initial_layer + 1]
        #ssf[initial_layer] = ssf[initial_layer + 1]
        #rsd[initial_layer] = rsd[initial_layer + 1]
        #bdd[initial_layer] = bdd[initial_layer + 1]
        #psp[initial_layer] = psp[initial_layer + 1]
        #satc[initial_layer] = satc[initial_layer + 1]
        #hcl[initial_layer] = hcl[initial_layer + 1]
        #wpo[initial_layer] = wpo[initial_layer + 1]
        #cprv[initial_layer] = cprv[initial_layer + 1]
        #cprh[initial_layer] = cprh[initial_layer + 1]
      #end #end depth
      #Line 2 and line 3 col 5 and 7
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
      soil.wtmx = 0 unless !(soil.wtmx==nil)
      soil.wtbl = 0 unless !(soil.wtbl==nil)
      soil.zqt = 0 unless !(soil.zqt==nil)
      soil.ztk = 0 unless !(soil.ztk==nil)
  	  ##if tile drain was set up wtmx, wtmn, and wtbl should be zero. Otherwise keep the numbers. 11 06 2016.
      ##Goin back to the values for drainage type as before. Keep this here just in case Ali wants to have it latter 11 08 2016. Oscar Gallego
	  bmp = Bmp.find_by_scenario_id_and_bmpsublist_id(@scenario.id, 3)
	  if !(bmp == nil) and bmp.depth > 0 then
		  records = records + sprintf("%8.2f", 0)
		  records = records + sprintf("%8.2f", 0)
		  records = records + sprintf("%8.2f", 0)
		  records = records + sprintf("%8.2f", 0)
		  #soil.zqt = 0
		  #soil.ztk = 0
	  else
		  records = records + sprintf("%8.2f", soil.wtmn)
		  records = records + sprintf("%8.2f", soil.wtmx)
		  records = records + sprintf("%8.2f", soil.wtbl)
	  end
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
	  records = records + sprintf("%8.2f", soil.zqt)
      soil.zf = 0 unless !(soil.zf==nil)
      records = records + sprintf("%8.2f", soil.zf)
	  records = records + sprintf("%8.2f", soil.ztk)
      soil_info.push(records + "\n")
      #line 4 to 24 Layers information
      records = ""
      for layers in initial_layer..layer_number - 1
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
	    if ssf[layers] == nil then
			ssf[layers] = 0
		end
        if ssf[layers] > SoilPMaxForSoilDepth
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
      @soil_list.push("  " + sprintf("%3d", last_soil1) + " " + soil_file_name + "\n")
      i += 1
      #print_array_to_file(soil_info, soil_file_name)
      msg = send_file_to_APEX(soil_info, soil_file_name)
    end # end soils do
    @last_soil = last_soil1
    return msg
  end  # end method create_soils

  #this is the new subarea creation method. This take first the subareas for the scenario and then choose those soils selected and bmp buffers.
  def create_subareas(operation_number)  # operation_number is used for subprojects. for simple scenarios is 1
    last_owner1 = 0
    i=0
	nirr = 0
	subareas = Subarea.where("scenario_id = " + @scenario.id.to_s + " AND soil_id > 0")
	subareas.each do |subarea|
		soil = Soil.find(subarea.soil_id)
		if soil.selected then
			create_operations(soil.id, soil.percentage, operation_number, 0)   # 0 for subarea from soil. Subarea_type = Soil
			add_subarea_file(subarea, operation_number, last_owner1, i, nirr, false, @soils.count)
			i+=1
			@soil_number += 1
		end  # end if soil.selected
	end  # end subareas.each for soil_id > 0
	#add subareas and operations for buffer BMPs.
	subareas = Subarea.where("scenario_id = " + @scenario.id.to_s + " AND soil_id = 0 AND bmp_id > 0")
	buffer_type = 2
	subareas.each do |subarea|
		add_subarea_file(subarea, operation_number, last_owner1, i, nirr, true, @soils.count)
		if !(subarea.subarea_type == "PPDE" || subarea.subarea_type == "PPTW") then
			if subarea.subarea_type == "RF" then
				buffer_type = 1
			end
			create_operations(subarea.bmp_id, 0, operation_number, buffer_type)
			i+=1
			@soil_number += 1
		end # end if bmp types PPDE and PPTW
	end  # end subareas.each for buffers
	msg = send_file_to_APEX(@subarea_file, "APEX.sub")
	return msg
  end   # end create_subareas

  def create_subareas1(operation_number) # operation_number is used for subprojects as for now it is just 1 - todo
    @last_soil2 = 0
    last_owner1 = 0
    i=0
	  nirr = 0
    @soils.each do |soil|
      #create the operation file for this subarea.
      nirr = create_operations(soil, operation_number)
      #create the subarea file
      bmp = Bmp.where(:scenario_id => params[:id]).find_by_bmpsublist_id(15)
      if (bmp == nil) # todo if contour buffer this need to be different
        #if !(bmps.CBCWidth > 0 && _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBBWidth > 0 && _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBCrop > 0) then
        #addSubareaFile(soil._scenariosInfo(currentScenarioNumber)._subareasInfo, operation_number, last_soil1, last_owner1, @soil_number, nirr, false)
        #operation number is used to control subprojects. Therefore here is going to be 1.
        add_subarea_file(Subarea.find_by_soil_id_and_scenario_id(soil.id, @scenario.id), operation_number, last_owner1, i, nirr, false, @soils.count)
        @soil_number += 1
        i+=1
      end
	  msg = send_file_to_APEX(@subarea_file, "APEX.sub")
	  return msg
    end

    if @last_soil2 > 0
      @last_soil_sub = @last_soil2 - 1
    else
      @last_soil_sub = 0
    end
    @last_subarea = 0

    #for Each buf In _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bufferInfo
	  buffer = Subarea.where("scenario_id = " + @scenario.id.to_s + " AND bmp_id != 'nil' AND bmp_id != 0 AND soil_id = 0")
      buffer.each do |buf|
        if !(buf.subarea_type == "PPDE" || buf.subarea_type == "PPTW" || buf.subarea_type == "AITW" || buf.subarea_type == "CBMain")
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
          opcsFile.Add("End " & buf.description)
		else
			i -= 1
        end
        add_subarea_file(buf, operation_number, last_owner1, i, nirr, true, 0)
		i+=1
      end

    @last_soil_sub = @last_soil2
    last_owner = last_owner1
    #todo check this one.
    #$last_subarea += _fieldsInfo1(currentFieldNumber)._soilsInfo(i - 1)._scenariosInfo(currentScenarioNumber)._subareasInfo_subarea_info..Iops
    #print_array_to_file(@subarea_file, "APEX.sub")
    #msg = send_file_to_APEX(@subarea_file, "APEX.sub")
	msg = "OK"
    return msg
  end  #end method create_subarea1

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
    last_owner1 = @last_soil2
	if buffer then
		#sLine = sprintf("%4d", @last_soil2-1)  #soil
		sLine = sprintf("%4d", _subarea_info.inps)  #soil
		if (_subarea_info.subarea_type == "PPDE" || _subarea_info.subarea_type == "PPTW") then
			sLine += sprintf("%4d", _subarea_info.iops) #operation
		else
			#sLine += sprintf("%4d", @soil_number + 1)   #operation
			sLine += sprintf("%4d", _subarea_info.iops)   #operation
		end
		#sLine += sprintf("%4d", last_owner1-1) #owner id. Should change for each field
		sLine += sprintf("%4d", _subarea_info.iow) #owner id. Should change for each field
	else
		#sLine = sprintf("%4d", @soil_number + 1)  #soil
		#sLine += sprintf("%4d", @soil_number + 1)   #operation
		#sLine += sprintf("%4d", last_owner1) #owner id. Should change for each field
		sLine = sprintf("%4d", _subarea_info.inps)  #soil
		sLine += sprintf("%4d", _subarea_info.iops)   #operation
		sLine += sprintf("%4d", _subarea_info.iow) #owner id. Should change for each field
	end
    if _subarea_info.iow == 0 then
      _subarea_info.iow = 1
    end
    sLine += sprintf("%4d", _subarea_info.ii)
    sLine += sprintf("%4d", _subarea_info.iapl)
    sLine += sprintf("%4d", 0) #column 6 line 1 is not used
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
    if _subarea_info.wsa > 0 && i > 0 && !buffer then
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
	if (_subarea_info.bmp_id == 0 || _subarea_info.bmp_id == nil)  && _subarea_info.subarea_type == "Soil"
		if (_subarea_info.chl != _subarea_info.rchl && i > 0) || total_soils == 1 then
		  _subarea_info.rchl = _subarea_info.chl
		end
		if (operation_number > 1 && i == 0) || i > 0 then
		  #if (operation_number > 1 && i == 0) || (total_soils == i + 1 && total_soils > 1) then
		  #_subarea_info.rchl = (_subarea_info.chl * 0.9).round(4)
		  #sLine = sprintf("%8.4f", _subarea_info.rchl * 0.9)
		end
	end
    sLine = sprintf("%8.4f", _subarea_info.rchl)
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
    sLine = sprintf("%8.2f", _subarea_info.rsee)
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
	if _subarea_info.pcof == nil then
		_subarea_info.pcof = 0
	end
    sLine += sprintf("%8.2f", _subarea_info.pcof)
	if _subarea_info.bcof == nil then
		_subarea_info.bcof = 0
	end
    sLine += sprintf("%8.2f", _subarea_info.bcof)
    sLine += sprintf("%8.2f", _subarea_info.bffl)
    @subarea_file.push(sLine + "\n")
    #/line 8
	sLine = "  0"
    if _subarea_info.nirr > 0 then
      sLine += sprintf("%1d", _subarea_info.nirr)
    else
      sLine += sprintf("%1d", _subarea_info.nirr)
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
	if @grazingb == true and _subarea_info.xtp1 == 0 then
		sLine = sprintf("%4d", 1)
	else
		sLine = sprintf("%4d", _subarea_info.ny1)
	end
    sLine += sprintf("%4d", _subarea_info.ny2)
    sLine += sprintf("%4d", _subarea_info.ny3)
    sLine += sprintf("%4d", _subarea_info.ny4)
    @subarea_file.push(sLine + "\n")
    #/line 12
	if @grazingb == true and _subarea_info.xtp1 == 0 then
		sLine = sprintf("%8.2f", 0.01)
	else
		sLine = sprintf("%8.2f", _subarea_info.xtp1)
	end
    sLine += sprintf("%8.2f", _subarea_info.xtp2)
    sLine += sprintf("%8.2f", _subarea_info.xtp3)
    sLine += sprintf("%8.2f", _subarea_info.xtp4)
    @subarea_file.push(sLine + "\n")

    return "OK"
  end

  def create_operations(soil_id, soil_percentage, operation_number, buffer_type)
    #This suroutine create operation files using information entered by user.
    nirr = 0
    @fert_code = 79
    @grazingb = false
    @opcs_file = Array.new
    irrigation_type = 0
    bmp = Bmp.where("scenario_id = " + @scenario.id.to_s + " and irrigation_id > 0").first
    irrigation_type = Irrigation.find(bmp.irrigation_id).code unless bmp == nil
    #check and fix the operation list
	if buffer_type == 0 then   #when subarea from soils
		@soil_operations = SoilOperation.where(:soil_id => soil_id.to_s, :scenario_id => @scenario.id.to_s)
	else   # when subarea from BMP. soil_id is the bmp_id.
		@soil_operations = SoilOperation.where(:bmp_id => soil_id.to_s, :scenario_id => @scenario.id.to_s, :opv6 => buffer_type.to_s)
	end  # end if type
    if @soil_operations.count > 0 then
      fix_operation_file()
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
          add_operation(soil_operation, irrigation_type, nirr, soil_percentage, j)
        end # end if
        j+=1
      end #end soil_operations.each do
      # add to the tillage file the new fertilizer operations - one for each depth
      append_file("tillOrg.dat", "till.dat", "till")
      append_file("ferts.dat", "fert.dat", "fert")
      msg = send_file_to_APEX(@opcs_file, "APEX" + (@soil_number+1).to_s.rjust(3, '0') + ".opc")
      @opcs_list_file.push((@soil_number+1).to_s.rjust(5, '0') + " " + "APEX" + (@soil_number+1).to_s.rjust(3, '0') + ".opc" + "\n")
    end #end if
    return nirr
  end  #end Create Operations

  def fix_operation_file()
    if @soil_operations.count > 0 then
      total_records = @soil_operations.count - 1
      first_date = sprintf("%2d", @soil_operations[0].month) + sprintf("%2d", @soil_operations[0].day)
      last_date = sprintf("%2d", @soil_operations[total_records].month) + sprintf("%2d", @soil_operations[total_records].day)
      if first_date > last_date then
        last_year = sprintf("%2d", @soil_operations[total_records].year)
        #if this is the case the operation for the last year need to be put before the first record.
        for i in 0..@soil_operations.count-1
          if last_year.strip.to_i == @soil_operations[i].year then
            break
          end
        end
        for j in i..@soil_operations.count - 1
          #drOut = SoilOperation.new
          #drOut = drIn(j)
          @soil_operations[j].year = "1"
          #drOuts.Add(drOut)
        end
		@soil_operations.sort_by! { |date| [date.year, date.month, date.day, date.activity_id, date.id] }
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
    apex_string += sprintf("%3d", operation.year) #Year
    apex_string += sprintf("%3d", operation.month) #Month
    if operation.month == 12 && operation.day == 31 then
      apex_string += sprintf("%3d", 30) #Day
    else
      apex_string += sprintf("%3d", operation.day) #Day
    end
    #planting =1, tillage = 3, harvest = 4
    if operation.activity_id == 1 || operation.activity_id == 3 || operation.activity_id == 4 || operation.activity_id == 6 then
      apex_string += sprintf("%5d", operation.apex_operation) #Operation Code        #APEX0604
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
        apex_string += sprintf("%5d", oper_ant) #Operation Code        #APEX0604
      else
        #apex_string += operation.ApexTillCode.ToString.PadLeft(5))    #Operation Code        #APEX0604
        apex_string += sprintf("%5d", operation.apex_operation) #Operation Code        #APEX0604
      end
    end #end if 1, 3, or 4

    apex_string += "     " #Tractor ID. Not Used  #APEX0604
    apex_string += sprintf("%5d", operation.apex_crop) #Crop Code             #APEX0604
    case operation.activity_id
      when 1 #planting
        if operation.apex_crop == "18" then    # rice
          rice_crop = true
        end
        if lu_number == 28 then
          if operation.apex_crop == 108 || operation.apex_crop = 152 then

          end
          apex_string += sprintf("%5d", filter_strip)
        else
          apex_string += sprintf("%5d", 0) #TIME TO MATURITY       #APEX0604
        end
        #if operation.opv1 == 0 then
        #uri = URI.parse(URL_HU +  "?op=getHU&crop=operation.apex_crop&nlat=" + Weather.find_by_field_id(@field.id).latitude.to_s + "&nlon=" + Weather.find_by_field_id(@field.id).longitude.to_s)
        #uri.open
        #operation.opv1 = uri.read
        #operation.opv1 = endpoint.post("op=getHU&crop=operation.apex_crop&nlat=" + Weather.find_by_field_id(@field.id).latitude + "&nlon=" + Weather.find_by_field_id(@field.id).longitude)
        #Dim getHu As New GetHU
        #operation.opv1 = getHu.calcHU(operation.apex_crop, wp1Files + "\" + _startInfo.Wp1Name + ".WP1", folder + "\App_Data\PHUCRP.DAT")
        #operation.opv1 = calcHU(operation.apex_crop, _crops, _startInfo)
        #end
        apex_string += sprintf("%8.2f", operation.opv1)
        items[0] = "Heat Units"
        values[0] = operation.opv1
        items[1] = "Curve Number"
        values[1] = operation.opv2
		#find if there are Pads & Pipes Bmps set up.
        bmps_count = Bmp.where("(bmpsublist_id = 4 OR bmpsublist_id = 5 OR bmpsublist_id = 6 OR bmpsublist_id = 7) AND scenario_id = " + @scenario.id.to_s).count
        if bmps_count > 0 then
          apex_string += sprintf("%8.1f", (operation.opv2 * 0.9)) #curve number
        else
          apex_string += sprintf("%8.1f", operation.opv2) #curve number
        end
        apex_string += sprintf("%8.2f", operation.opv3) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", operation.opv4) #Opv4. No entry needed.

        operation.opv5 == nil ? apex_string += sprintf("%8.2f", 0) : operation.opv5 < 0.01 ? apex_string += sprintf("%8.6f", operation.opv5) : apex_string += sprintf("%8.2f", operation.opv5) #Opv 5 Plant Population.
      when 6 #irrigation
        apex_string += sprintf("%5d", 0) #
        items[0] = "Irrigation"
        values[0] = operation.opv2
        apex_string += sprintf("%8.2f", operation.opv1) #Volume applied for irrigation in mm
        nirr = 1
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) & sprintf("%8.2f", operation.opv2) #Opv4 Irrigation Efficiency
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 2 # fertilizer            #fertilizer or fertilizer(folier)
        #if operation.activetApexTillName.ToString.ToLower.Contains("fert") then
        oper = Operation.where(:id => operation.operation_id).first
		    bmp = Bmp.find_by_scenario_id_and_bmpsublist_id(@scenario.id, 18)
		    if oper.activity_id == 2 && oper.type_id == 2 && Fertilizer.find(oper.subtype_id).animal && !(bmp == nil) then
			     add_fert(oper.no3_n * bmp.no3_n, oper.po4_p * bmp.po4_p, oper.org_n * bmp.org_n, oper.org_p * bmp.org_p, Operation.find(operation.operation_id).type_id, oper.nh3, oper.subtype_id)
		    else
			     add_fert(oper.no3_n, oper.po4_p, oper.org_n, oper.org_p, Operation.find(operation.operation_id).type_id, oper.nh3, oper.subtype_id)
		    end
        apex_string += sprintf("%5d", @fert_code) #Fertilizer Code       #APEX0604
        items[0] = @fert_code
        if oper.activity_id == 2 && oper.type_id == 2 Then
          apex_string += sprintf("%8.2f", operation.opv1 * 2000) #kg/ha of fertilizer applied
        else
          apex_string += sprintf("%8.2f", operation.opv1) #kg/ha of fertilizer applied
        end  
        values[0] = operation.opv1
        apex_string += sprintf("%8.2f", operation.opv2)
        items[1] = "Depth"
        values[1] = operation.opv2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 7 # grazing              #Grazing - kind and number of animals
        apex_string += sprintf("%5d", 0) #
        #if number of animals were enter in modify page and it is the first grazing operation
        if @grazingb == false then
          items[3] = "DryMatterIntake"
          #create_herd file and send to APEX
		  current_oper = Operation.find(operation.operation_id)
          values[3] = create_herd_file(current_oper.amount, current_oper.depth, current_oper.type_id, soil_percentage)
          #animalB = operation.ApexTillCode
          @grazingb = true
          if current_oper.no3_n != 0 || current_oper.po4_p != 0 || current_oper.org_n != 0 || current_oper.org_p != 0 || current_oper.nh3 != 0 then
            #animal_code = get_animal_code(operation.type_id)
            change_fert_for_grazing(current_oper.no3_n, current_oper.po4_p, current_oper.org_n, current_oper.org_p, current_oper.type_id, current_oper.nh3)
          end
        end
        apex_string += sprintf("%8.4f", operation.opv1)
        items[0] = "Kind"
        values[0] = operation.type_id
        items[1] = "Animals"
        values[1] = operation.opv1
        items[2] = "Hours"
        values[2] = operation.opv2
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 3 #tillage
        apex_string += sprintf("%5d", 0)
        apex_string += sprintf("%8.2f", 0)
        items[0] = "Tillage"
        values[0] = 0
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 4 #harvest
        apex_string += sprintf("%5d", 0) #
        apex_string += sprintf("%8.2f", 0)
        items[1] = "Curve Number"
        values[1] = operation.opv2
        if Field.find(@field.id).field_type then
          change_till_for_HE(operation.type_id, operation.opv1)
        end
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 5 #kill
        apex_string += sprintf("%5d", 0) #
        apex_string += sprintf("%8.2f", 0)
        items[0] = "Curve Number"
        values[0] = operation.opv2
        items[1] = "Time of Operation"
        values[1] = operation.opv2
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 8 #stopGrazing
        apex_string += sprintf("%5d", 0) #
        apex_string += sprintf("%8.2f", 0)
        items[0] = "Stop Grazing"
        values[0] = 0
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
      when 10 # liming
        apex_string += sprintf("%5d", 0) #
        apex_string += sprintf("%8.2f", operation.opv1) #kg/ha of fertilizer applied
      else #No entry needed.
        apex_string += sprintf("%5d", 0) #
        apex_string += sprintf("%8.2f", 0) #opval1
        apex_string += sprintf("%8.2f", 0) #opval2
        apex_string += sprintf("%8.2f", 0) #Opv3. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv4. No entry needed.
        apex_string += sprintf("%8.2f", 0) #Opv5. No entry neede.
    end #end case true

    apex_string += sprintf("%8.2f", 0) #Opv6 for now is always zero. opv6 is used to know if the operations belong to the sme file.
    apex_string += sprintf("%8.2f", operation.opv7) #Opv7
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
	state_id = Location.find(session[:location_id]).state_id
	if state_id == 0 or state_id == nil then
		state_abbreviation = "**"
	else
		state_abbreviation = State.find(state_id).state_abbreviation
	end
    @fem_list.push(@scenario.name + COMA + @scenario.name + COMA + state_abbreviation + COMA + operation.year.to_s + COMA + operation.month.to_s + COMA + operation.day.to_s + COMA + operation.apex_operation.to_s + COMA + operation_name + COMA + operation.apex_crop.to_s +
                   COMA + Crop.find_by_number(operation.apex_crop).name + COMA + @soil_operations.last.year.to_s + COMA + "0" + COMA + "0" + COMA + items[0].to_s + COMA + values[0].to_s + COMA + items[1].to_s + COMA + values[1].to_s + COMA + items[2].to_s + COMA + values[2].to_s + COMA + items[3].to_s + COMA + values[3].to_s + COMA + items[4].to_s + COMA +
                   values[4].to_s + COMA + items[5] + COMA + values[5].to_s + COMA + items[6] + COMA + values[6].to_s + COMA + items[7] + COMA + values[7].to_s + COMA + items[8] + COMA + values[8].to_s)
    #End With
  end  # end add_operation method

  def append_file(original_file, target_file, file_type)
    path = File.join(APEX, "APEX" + session[:session_id])
	if File.exists?(File.join(APEX_ORIGINAL + "_" + State.find(@project.location.state_id).state_abbreviation.downcase)) then
		FileUtils.cp(File.join(APEX_ORIGINAL + "_" + State.find(@project.location.state_id).state_abbreviation.downcase, original_file), File.join(path, target_file))
    else
		FileUtils.cp(File.join(APEX_ORIGINAL, original_file), File.join(path, target_file))
    end
    case file_type
      when "till"
        File.open(File.join(path, target_file), "a+") do |f|
          @change_till_depth.each do |row|
            f << row
          end
        end
      when "fert"
        File.open(File.join(path, target_file), "a+") do |f|
          @new_fert_line.each do |row|
            f << row
          end
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
      if no3n == nil then
        newLine += sprintf("%8.4f", 0)
      else
        newLine += sprintf("%8.4f", no3n)
      end
      if po4p == nil then
        newLine += sprintf("%8.4f", 0)
      else
        newLine += sprintf("%8.4f", po4p)
      end
      if k == nil then
        newLine += sprintf("%8.4f", 0)
      else
        newLine += sprintf("%8.4f", k)
      end
      if orgN == nil then
        newLine += sprintf("%8.4f", 0)
      else
        newLine += sprintf("%8.4f", orgN)
      end
      if orgP == nil then
        newLine += sprintf("%8.4f", 0)
      else
        newLine += sprintf("%8.4f", orgP)
      end
      orgC = 0
      case type
        when 1 #commercial
          nh3 = 0
        when 2 #Manure
          if subtype == 57 then
            orgC = 0.15 #liquide
          else
            orgC = 0.35 #solid
          end
      end
      if nh3 == nil then
        newLine = newLine + " " + sprintf("%7.4f", 0)
      else
        newLine = newLine + " " + sprintf("%7.4f", nh3)
      end
      if orgC == nil then
        newLine = newLine + " " + sprintf("%7.4f", 0)
      else
        newLine = newLine + " " + sprintf("%7.4f", orgC)
      end
      newLine = newLine + "   0.000   0.000\n"
      @new_fert_line.push(newLine)
    end
  end
  #end add_fert method

  def change_till_for_depth(oper, depthAnt)
    newLine = "  " + oper.to_s
    newLine += " C:FERT 5 CUST      5.      0.      0.      0.      0.     0.0    0.00   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000   0.000"
    newLine += sprintf("%8.2f", depthAnt)
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
	if nh3 == nil then
		nh3 = 0.350
	end
    newLine = newLine + " " + sprintf("%7.4f", nh3)
    newLine = newLine + "   0.350   0.000   0.000"
    @change_fert_for_grazing_line.push(newLine)
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

  def read_file(file, name_composed)
    if name_composed == false then
      return File.read(File.join(APEX, "APEX" + session[:session_id], file))
    else
      return File.read(file) #means the whole path is coming in the file variable.
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

  def read_apex_results(msg)
    ActiveRecord::Base.transaction do
      begin
	    #clean all of the results exiting for this scenario.
		if session[:simulation] == "scenario" then
			# clean results for scenario to avoid keeping some results from previous simulation
			Result.where(:scenario_id => @scenario.id, :field_id => params[:field_id]).delete_all
			Chart.where(:scenario_id => @scenario.id, :field_id => params[:field_id]).delete_all
		else
			# clean results for watershed to avoid keeping some results from previous simulation
			Result.where(:watershed_id => @watershed.id).delete_all
			Chart.where(:watershed_id => @watershed.id).delete_all
		end
        ntt_apex_results = Array.new
        #check this with new projects. Check if the simulation_initial_year has the 5 years controled.
        start_year = Weather.find_by_field_id(Scenario.find(@scenario.id).field_id).simulation_initial_year - 5
        apex_start_year = start_year + 1
        #take results from .NTT file for all but crops
        msg = load_results(apex_start_year, msg)
        msg = load_crop_results(apex_start_year)
      rescue => e
        msg = "Failed, Error: " + e.inspect
        raise ActiveRecord::Rollback
      ensure
        return msg
      end
    end
  end

  def load_results(apex_start_year, data)
    msg = "OK"
    results_data = Array.new
    oneResult = Struct.new(:sub1, :year, :flow, :qdr, :surface_flow, :sed, :ymnu, :orgp, :po4, :orgn, :no3, :qdrn, :qdrp, :qn, :dprk, :irri, :pcp, :prkn, :n2o)
    sub_ant = 99
    irri_sum = 0
    dprk_sum = 0
	prkn_sum = 0
	n2o_sum = 0
    pcp = 0
    total_subs = 0
    i=1
    #apex_control = ApexControl.where(:project_id => params[:project_id])
    initial_chart_year = @apex_controls[0].value - 12 + @apex_controls[1].value
    data.each_line do |tempa|
      if i > 3 then
        year = tempa[7, 4].to_i
        subs = tempa[0, 5].to_i
        next if year < apex_start_year #take years greater or equal than ApexStartYear.
        if subs != 0 and subs != sub_ant then
          total_subs += 1
        end
        #next if (subs == sub_ant || (session[:simulation] == "watershed" && subs != 0)) && subs != 0 #if subs and subant equal means there are more than one CROP. So info is going to be duplicated. Just one record saved
        next if subs == sub_ant  #if subs and subant equal means there are more than one CROP. So info is going to be duplicated. Just one record saved
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
        # <!--deep percolation hidden according to Dr. Saleh on 7/31/2017-->
        # one_result.dprk = tempa[135, 9].to_f * MM_TO_IN
        one_result.dprk = 0 # Deep percolation hidden in results table
        one_result.irri = tempa[237, 8].to_f * MM_TO_IN
        one_result.pcp = tempa[229, 8].to_f * MM_TO_IN
        one_result.prkn = tempa[13, 9].to_f * (KG_TO_LBS / HA_TO_AC)
        one_result.n2o = tempa[153, 9].to_f
        if subs == 0 then
          one_result.dprk = dprk_sum / total_subs
          one_result.irri = irri_sum / total_subs
          one_result.prkn = prkn_sum / total_subs
          one_result.n2o = n2o_sum / total_subs
          one_result.pcp = pcp / total_subs
          irri_sum = 0
          dprk_sum = 0
		  prkn_sum = 0
		  n2o_sum = 0
          pcp = 0
          total_subs = 0
          if initial_chart_year <= year then
            add_value_to_chart_table(one_result.orgn, 21, 0, year,0)
            add_value_to_chart_table(one_result.qn, 22, 0, year,0)
            add_value_to_chart_table(one_result.no3, 23, 0, year,0)
            add_value_to_chart_table(one_result.qdrn, 24, 0, year,0)
            add_value_to_chart_table(one_result.qn+one_result.qdrn+one_result.no3+one_result.orgn, 20, 0, year,0)
            add_value_to_chart_table(one_result.orgp, 31, 0, year,0)
            add_value_to_chart_table(one_result.po4, 32, 0, year,0)
            add_value_to_chart_table(one_result.qdrp, 33, 0, year,0)
            add_value_to_chart_table(one_result.po4+one_result.qdrp+one_result.orgp, 30, 0, year,0)
            add_value_to_chart_table(one_result.surface_flow, 41, 0, year,0)
            add_value_to_chart_table(one_result.flow - one_result.surface_flow, 42, 0, year,0)
            add_value_to_chart_table(one_result.qdr, 43, 0, year,0)
            add_value_to_chart_table(one_result.qdr, 33, 0, year,0)
            add_value_to_chart_table(one_result.flow + one_result.qdr, 40, 0, year,0)
            add_value_to_chart_table(one_result.irri, 51, 0, year,0)
            add_value_to_chart_table(one_result.dprk, 52, 0, year,0)
            add_value_to_chart_table(one_result.irri + one_result.dprk, 50, 0, year,0)
            add_value_to_chart_table(one_result.sed, 61, 0, year,0)
            add_value_to_chart_table(one_result.ymnu, 62, 0, year,0)
            add_value_to_chart_table(one_result.sed + one_result.ymnu, 60, 0, year,0)
            add_value_to_chart_table(one_result.prkn, 91, 0, year,0)
            add_value_to_chart_table(one_result.n2o, 92, 0, year,0)
            add_value_to_chart_table(one_result.n2o + one_result.prkn, 90, 0, year,0)
            add_value_to_chart_table(one_result.pcp, 100, 0, year,0)
          end   # end initial_chart
        else
          irri_sum += one_result.irri
          dprk_sum += one_result.dprk
          prkn_sum += one_result.prkn
          n2o_sum += one_result.n2o
          pcp += one_result.pcp
        end  # end if sub == 0
        results_data.push(one_result)
      else
        i = i + 1
      end   # end if i > 3
    end   #end data.each_line
    msg = average_totals(results_data) # average totals
    msg = load_monthly_values(apex_start_year)
    #This calculate fencing nutrients for each scenario and add to nutrients of results. check for scenarios and watershed
    return update_results_table_with_fencing
  end

  def average_totals(results_data)
    #0:sub1,1:year,2:flow,3:qdr,4:surface_flow,5:sed,6:ymnu,7:orgp,8:po4,9:orgn,10:no3,11:qdrn,12:qdrp,13:qn,14:dprk,15:irri,16:pcp)
    #Results description_ids
    require 'enumerable/confidence_interval'
    #calculate average and confidence interval
    orgn = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:orgn).mean] }
    orgn_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:orgn).confidence_interval] }
    add_summary_to_results_table(orgn, 21, orgn_ci)
    runoff_n = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qn).mean] }
    runoff_n_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qn).confidence_interval] }
    add_summary_to_results_table(runoff_n, 22, runoff_n_ci)
    sub_surface_n = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:no3).mean - v.map(&:qn).mean] }
    sub_surface_n_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:no3).confidence_interval - v.map(&:qn).confidence_interval] }
    add_summary_to_results_table(sub_surface_n, 23, sub_surface_n_ci)
    tile_drain_n = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdrn).mean] }
    tile_drain_n_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdrn).confidence_interval] }
    add_summary_to_results_table(tile_drain_n, 24, tile_drain_n_ci)
    orgp = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:orgp).mean] }
    orgp_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:orgp).confidence_interval] }
    add_summary_to_results_table(orgp, 31, orgp_ci)
    po4 = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:po4).mean] }
    po4_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:po4).confidence_interval] }
    add_summary_to_results_table(po4, 32, po4_ci)
    tile_drain_p = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdrp).mean] }
    tile_drain_p_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdrp).confidence_interval] }
    add_summary_to_results_table(tile_drain_p, 33, tile_drain_p_ci)
    runoff = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:surface_flow).mean] }
    runoff_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:surface_flow).confidence_interval] }
    add_summary_to_results_table(runoff, 41, runoff_ci)
    sub_surface_flow= results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:flow).mean - v.map(&:surface_flow).mean] }
    sub_surface_flow_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:flow).confidence_interval - v.map(&:surface_flow).confidence_interval] }
    #sub_surface_flow = flow - runoff
    #sub_surface_flow_ci = flow_ci - runoff_ci
    add_summary_to_results_table(sub_surface_flow, 42, sub_surface_flow_ci)
    tile_drain_flow = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdr).mean] }
    tile_drain_flow_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:qdr).confidence_interval] }
    add_summary_to_results_table(tile_drain_flow, 43, tile_drain_flow_ci)
    irrigation = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:irri).mean] }
    irrigation_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:irri).confidence_interval] }
    add_summary_to_results_table(irrigation, 51, irrigation_ci)
    deep_percolation_flow = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:dprk).mean] }
    deep_percolation_flow_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:dprk).confidence_interval] }
    add_summary_to_results_table(deep_percolation_flow, 52, deep_percolation_flow_ci)
    sediment = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:sed).mean] }
    sediment_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:sed).confidence_interval] }
    add_summary_to_results_table(sediment, 61, sediment_ci)
    manure_erosion = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:ymnu).mean] }
    manure_erosion_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:ymnu).confidence_interval] }
    add_summary_to_results_table(manure_erosion, 62, manure_erosion_ci)
    prkn = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:prkn).mean] }
    prkn_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:prkn).confidence_interval] }
    add_summary_to_results_table(prkn, 91, prkn_ci) #error that causes code not to continue?
    n2o = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:n2o).mean] }
    n2o_ci = results_data.group_by(&:sub1).map { |k, v| [k, v.map(&:n2o).confidence_interval] }
    add_summary_to_results_table(n2o, 92, n2o_ci) #error that causes code not to continue?
    return "OK"
  end

  def update_results_table_with_fencing
    no3 = 0
    po4 = 0
    org_n = 0
    org_p =0

    bmp = Bmp.find_by_scenario_id_and_bmpsublist_id(@scenario.id, 10)
	if !(bmp.blank? || bmp == nil) then
		total_manure = bmp.number_of_animals.to_f * bmp.hours.to_f / 24 * bmp.dry_manure
		no3 += total_manure * bmp.days * bmp.no3_n
		po4 += total_manure * bmp.days * bmp.po4_p
		org_n += total_manure * bmp.days * bmp.org_n
		org_p += total_manure * bmp.days * bmp.org_p
		if session[:simulation] == 'scenario'
		  soils = Soil.where(:field_id => @field.id, :selected => true)
		  soils.each do |soil|
			results = Result.where(:soil_id => soil.id, :field_id => @field.id, :scenario_id => @scenario.id)
			results.each do |result|
			  update_value_of_results(result, false, Field.find(@field.id).field_area * (soil.percentage / 100), no3, po4, org_n, org_p)
			  result.save
			end
		  end
		end
		if session[:simulation] == 'scenario'
		  results = Result.where(:soil_id => 0, :field_id => @field.id, :scenario_id => @scenario.id)
		else
		  results = Result.where(:watershed_id => @watershed.id)
		end

		results.each do |result|
		  update_value_of_results(result, true, Field.find(@field.id).field_area, no3, po4, org_n, org_p)
		  result.save
		end
	end  # end if bmp blank or nil
	return "OK"
  end

  def update_value_of_results(result, is_total, percentage, no3, po4, org_n, org_p)
    #if is_total
      #percentage = 1
    #else
      #percentage = soil.percentage / 100
    #end
    case result.description_id
      when 20
        result.value += no3 / percentage + org_n / percentage
      when 21
        result.value += org_n / percentage
      when 22
        result.value += no3 / percentage
      when 30
        result.value += po4 / percentage + org_p / percentage
      when 31
        result.value += org_p / percentage
      when 32
        result.value += po4 / percentage
    end
  end

  def update_hash(climate, climate_array)
    hash = Hash.new
    hash["max"] = climate.max_temp * 9/5 + 32  #convert from F to C because in climate temp is in F but in APEX weather file it is C
    hash["min"] = climate.min_temp * 9/5 + 32  #convert from F to C because in climate temp is in F but in APEX weather file it is C
    hash["pcp"] = climate.precipitation
    climate_array.push(hash)
    return climate_array
  end

  def add_value_to_chart_table(value, description_id, soil_id, year,crop_id)
    field = 0
    soil = 0
    scenario = 0
    watershed = 0
    if session[:simulation] == "scenario" then
      chart = Chart.where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => soil_id, :description_id => description_id, :month_year => year).first
      field = @scenario.field_id
      soil = soil_id
      scenario = @scenario.id
    else
      chart = Chart.where(:watershed_id => @watershed.id, :description_id => description_id, :month_year => year).first
      watershed = @watershed.id
    end
    if chart == nil then
      chart = Chart.new
      chart.month_year = year
      chart.field_id = field
      chart.soil_id = soil
      chart.scenario_id = scenario
      chart.watershed_id = watershed
      chart.description_id = description_id
	  chart.crop_id = crop_id
    end
    chart.value = value
    if chart.save then
	  a = 2
    else
	  a = 1
    end
  end

  def add_summary_to_results_table(values, description_id, cis)
    #total Area =10, main area= 11, additional area 12..19
    #total N = 20, orgn=21, runoffn=22, subsurface n=23, tile drain n = 24
    #total p = 30, orgp=31, po4_p=32, tile drain p = 33
    #total Flow = 40, surface runoff = 41, subsurface runoff = 42, tile drain flow = 43
    #total other water info = 50, irrigation = 51, deep percolation = 52
    #total sediment = 60, sediment = 61, manure erosion = 62
    #total other N = 90, leaching = 91, n20 = 92
    for i in 0..values.count-1
	# todo. this is not taken the buffer subareas such as FS, WL, etc.
	  if values[i][0] <= @soils.count then
		  values[i][0] == 0 ? soil_id = 0 : soil_id = @soils[values[i][0]-1].id
		  if session[:simulation].eql?('scenario') then
			add_summary(values[i][1], description_id, soil_id, cis[i][1], 0)
			case description_id #Total area for summary report is beeing calculated
			  when 4 #calculate total area
				#todo
			  when 24 #calculate total N
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 20"), 20, soil_id)
			  when 33 #calculate total P
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 30"), 30, soil_id)
			  when 43 #calculate total flow
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 40"), 40, soil_id)
        when 52 #calculate total other water info
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 50"), 50, soil_id)
			  when 62 #calculate total sediment
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 60"), 60, soil_id)
			  when 92 # calculate total other N
				add_totals(Result.where("soil_id = " + soil_id.to_s + " AND field_id = " + @scenario.field_id.to_s + " AND scenario_id = " + @scenario.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 90"), 90, soil_id)
			end #end case when
		  else
			if values[i][0] > 0 then next end
			add_summary(values[i][1], description_id, soil_id, cis[i][1], 0)
			case description_id #Total area for summary report is beeing calculated
			  when 4 #calculate total area
				#todo
			  when 24 #calculate total N
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 20"), 20, soil_id)
			  when 33 #calculate total P
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 30"), 30, soil_id)
			  when 43 #calculate total flow
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 40"), 40, soil_id)
			  when 52 #calculate total other water info
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 50"), 50, soil_id)
			  when 62 #calculate total sediment
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 60"), 60, soil_id)
			  when 91  # calculate total other N
				add_totals(Result.where("watershed_id = " + @watershed.id.to_s + " AND description_id <= " + description_id.to_s + " AND description_id > 90"), 90, soil_id)
			end #end case when
		  end # end if simulation == scenario
	  end  # end if <= @soils
    end #end for i
    return "OK"
  end

  def add_totals(results, description_id, soil_id)
    msg = add_summary(results.sum(:value), description_id, soil_id, results.sum(:ci_value), 0)
  end

  def add_summary(value, description_id, soil_id, ci, crop_id)
    field = 0
    soil = 0
    scenario = 0
    watershed = 0
    if session[:simulation] == "scenario" then
      result = Result.where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => soil_id, :description_id => description_id).first
      field = @scenario.field_id
      soil = soil_id
      scenario = @scenario.id
    else
      result = Result.where(:watershed_id => @watershed.id, :description_id => description_id).first
      watershed = @watershed.id
    end
    if result == nil then
      result = Result.new
      result.field_id = field
      result.scenario_id = scenario
      result.soil_id = soil
      result.description_id = description_id
      result.watershed_id = watershed
      result.crop_id = crop_id
    end
    result.value = value
    if !ci.to_f.nan? then
      result.ci_value = ci.round(2)
    else
      result.ci_value = 0.00
    end
    result.crop_id = crop_id
    if result.save then
      return "OK"
    else
      return "Results couldn't be saved"
    end
  end

  def load_monthly_values(apex_start_year)
    data = send_file_to_APEX("MSW", session[:session_id]) #this operation will ask for MSW file
    #todo validate that the file was uploaded correctly

    annual_flow = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_sediment = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_orgn = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_orgp = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_no3 = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_po4 = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_precipitation = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    annual_crop_yield = fixed_array(12, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
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
          annual_orgn[i-1] += tempa[34, 10].to_f * 10 * KG_TO_LBS / HA_TO_AC #this values is multiply by 10 because the MSW file does this total divided by 10 comparing withthe value in the output file.
          annual_orgp[i-1] += tempa[45, 10].to_f * 20 * KG_TO_LBS / HA_TO_AC #this values is multiply by 20 because the MSW file does this total divided by 20 comparing withthe value in the output file.
          annual_no3[i-1] += tempa[56, 10].to_f * KG_TO_LBS / HA_TO_AC
          annual_po4[i-1] += tempa[67, 10].to_f * KG_TO_LBS / HA_TO_AC
          last_year = year
        end # end if not end of data
      end #end if
      j+=1
    end # end data.each

    last_year -= apex_start_year + 1

    data = send_file_to_APEX("MWS", session[:session_id]) #this operation will ask for MWS file
    #todo validate that the file was uploaded correctly
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
            end # end if year ok

          end # end if valid year
        end # end if tempa nil or empty
      end #end if i>9
      i += 1
    end # end data.each file apex001.mws
    for i in 0..11
      annual_flow[i] /= last_year
      add_value_to_chart_table(annual_flow[i], 41, 0, i+1, 0)
      annual_sediment[i] /= last_year
      add_value_to_chart_table(annual_sediment[i], 61, 0, i+1, 0)
      annual_orgn[i] /= last_year
      add_value_to_chart_table(annual_orgn[i], 21, 0, i+1, 0)
      annual_orgp[i] /= last_year
      add_value_to_chart_table(annual_orgp[i], 31, 0, i+1, 0)
      annual_no3[i] /= last_year
      add_value_to_chart_table(annual_no3[i], 22, 0, i+1, 0)
      annual_po4[i] /= last_year
      add_value_to_chart_table(annual_po4[i], 32, 0, i+1, 0)
      annual_precipitation[i] /= last_year
      add_value_to_chart_table(annual_precipitation[i], 100, 0, i+1, 0)
    end # end for
    return "OK"
  end

  def fixed_array(size, other)
    Array.new(size) { |i| other[i] }
  end

  def load_crop_results(apex_start_year)
    msg = "OK"
    crops_data = Array.new
    oneCrop = Struct.new(:sub1, :name, :year, :yield, :ws, :ts, :ns, :ps, :as1)
    data = send_file_to_APEX("ACY", session[:session_id]) #this operation will ask for ACY file
    #todo validate that the file was uploaded correctly
    j = 1
    data.each_line do |tempa|
      if j >= 10 then
        year1 = tempa[18, 4].to_i
        subs = tempa[5, 5].to_i
        next if year1 < apex_start_year #take years greater or equal than ApexStartYear.
        one_crop = oneCrop.new
        one_crop.sub1 = subs
        one_crop.year = year1
        one_crop.name = tempa[28, 4]
        one_crop.yield = tempa[33, 9].to_f
        one_crop.yield += tempa[43, 9].to_f unless (one_crop.name == "COTS" || one_crop.name == "COTP")
        one_crop.ws = tempa[63, 9].to_f
        one_crop.ns = tempa[73, 9].to_f
        one_crop.ps = tempa[83, 9].to_f
        one_crop.ts = tempa[93, 9].to_f
        one_crop.as1 = tempa[103, 9].to_f
        crops_data.push(one_crop)
      end # end if j>=10
      j+=1
    end #end data.each
    crops_data_by_crop_year = crops_data.group_by { |s| [s.name, s.year] }.map { |k, v| [k, v.map(&:yield).mean, v.map(&:ns).mean, v.map(&:ts).mean, v.map(&:ps).mean, v.map(&:ws).mean] }
    average_crops_result(crops_data_by_crop_year, 70) #crop results
    return "OK"
  end #end method

  def average_crops_result(items, desc_id)
    yield_by_name = Array.new
    description_id = desc_id
    items.each do |item|
      found = false
      yield_by_name.each do |array|
        if array["name"] == item[0][0] then
          found = true
          array["yield"] += item[1]
          array["total"] += 1 unless item[1] == 0
          array["ws"] += item[5]
          array["ns"] += item[2]
          array["ts"] += item[3]
          array["ps"] += item[4]
          add_value_to_chart_table(item[1] * array["conversion"], array["description_id"], 0, item[0][1],Crop.find_by_code(item[0][0].strip).id)
          break
        end # end if same crop
      end # end each name
	  if item[1] != 0 then
		  if found == false then
			description_id += 1
			yield_by_name.push(create_hash_by_name(item, description_id))
		  end # end if found
	  end
      #first = false
    end
    yield_by_name.each do |crop|
      if session[:simulation] == "scenario"
        crop_ci = Chart.select("value, month_year").where(:field_id => @scenario.field_id, :scenario_id => @scenario.id, :soil_id => 0, :description_id => crop["description_id"])
      else
        crop_ci = Chart.select("value, month_year").where(:watershed_id => @watershed.id, :description_id => crop["description_id"])
      end
      ci = Array.new
      crop_ci.each do |c|
        ci.push c.value
      end
      crop["ws"] = crop["ws"] / crop["total"]
      crop["ns"] = crop["ns"] / crop["total"]
      crop["ts"] = crop["ts"] / crop["total"]
      crop["ps"] = crop["ps"] / crop["total"]
      crop["yield"] = (crop["yield"] * crop["conversion"]) / crop["total"]
      #todo check why the ci is crashing with watershed simulations
      if session[:simulation].eql?('scenario')
        if (crop["description_id"] > 70 && crop["description_id"] < 80)
          add_summary(crop["yield"], crop["description_id"], 0, ci.confidence_interval, crop["crop_id"])
          add_summary(crop["ns"], crop["description_id"]+130, 0, ci.confidence_interval, crop["crop_id"])
          add_summary(crop["ps"], crop["description_id"]+140, 0, ci.confidence_interval, crop["crop_id"])
          add_summary(crop["ts"], crop["description_id"]+150, 0, ci.confidence_interval, crop["crop_id"])
          add_summary(crop["ws"], crop["description_id"]+160, 0, ci.confidence_interval, crop["crop_id"])
        end
      else
        #0 used for ci.confidence_interval because it is crashing with watersheds.
        add_summary(crop["yield"], crop["description_id"], 0, 0, crop["crop_id"])
        add_summary(crop["ns"], crop["description_id"]+130, 0, 0, crop["crop_id"])
        add_summary(crop["ps"], crop["description_id"]+140, 0, 0, crop["crop_id"])
        add_summary(crop["ts"], crop["description_id"]+150, 0, 0, crop["crop_id"])
        add_summary(crop["ws"], crop["description_id"]+160, 0, 0, crop["crop_id"])
      end
    end
    add_summary(0, 70, 0, 0, 0) # add total for crops. Just in case is needed for some reason
    add_summary(0, 200, 0, 0, 0) # add total for stress n.
    add_summary(0, 210, 0, 0, 0) # add total for stress p.
    add_summary(0, 220, 0, 0, 0) # add total for stress t.
    add_summary(0, 230, 0, 0, 0) # add total for stress w.
  end

  def create_hash_by_name(item, crop_count)
    conversion_factor = 1 * AC_TO_HA
    dry_matter = 100
    #find the crop to take conversion_factor and dry_matter
    crop = Crop.find_by_code(item[0][0].strip)
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
    new_hash["ns"] = item[2]
    new_hash["ts"] = item[3]
    new_hash["ps"] = item[4]
    new_hash["ws"] = item[5]
    return new_hash
  end

  def create_herd_file(animals, hours, animal_code, soil_percentage)
        #Dim manureProduced, bioConsumed, urineProduced As Single
        #Dim manureId
        #Dim animalField As Integer
        #calculate number of animals.
        case animal_code
            when 43		#"Dairy"    '1
                manureProduced = 3.9
                bioConsumed = 9.1
                urineProduced = 11.8
                manureId = 43
            #when "Dairy-dry cow"    '2
            #    manureProduced = 5.5
            #    bioConsumed = 9.1
            #    urineProduced = 11.8
            #    manureId = 43
            #when "Dairy-calf and heifer"     '3
            #    manureProduced = 5.5
            #    bioConsumed = 9.1
            #    urineProduced = 11.8
            #    manureId = 43
            #when "Dairy bull"     '4
            #    manureProduced = 3.9
            #    bioConsumed = 9.1
            #    urineProduced = 8.2
            #    manureId = 43
            when 44   #"Beef"    '5
                manureProduced = 3.9
                bioConsumed = 9.1
                urineProduced = 8.2
                manureId = 44
            #when "Beef-bull"     '6
            #    manureProduced = 3.9
            #    bioConsumed = 9.1
            #    urineProduced = 8.2
            #    manureId = 44
            #when "Beef-feeder yearling"    '7
            #    manureProduced = 3.9
            #    bioConsumed = 9.1
            #    urineProduced = 8.2
            #    manureId = 44
            #when "Beef-calf"    '8
            #    manureProduced = 3.9
            #    bioConsumed = 9.1
            #    urineProduced = 8.2
            #    manureId = 44
            when 47   #"Sheep"    '9
                manureProduced = 5
                bioConsumed = 9.0
                urineProduced = 6.8
                manureId = 47
            when 49   #"Horse"   '10
                manureProduced = 6.8
                bioConsumed = 9.1
                urineProduced = 4.5
                manureId = 49
            #when "Llama"    '11
            #    manureProduced = 5
            #    bioConsumed = 9.1
            #    urineProduced = 6.8
            #    manureId = 52
            #when "Alpaca"   '12
            #    manureProduced = 5.1
            #    bioConsumed = 9.1
            #    urineProduced = 6.8
            #    manureId = 52
            #when "Buffalo"   '13
            #    manureProduced = 3.9
            #    bioConsumed = 9.1
            #    urineProduced = 8.2
            #    manureId = 52
            #when "Emu (breeding stock)"   '14
            #    manureProduced = 10
            #    bioConsumed = 9.1
            #    urineProduced = 6.8
            #    manureId = 52
            #when "Emu (young birds)"    '15
            #    manureProduced = 9.8
            #    bioConsumed = 9.0
            #    urineProduced = 6.8
            #    manureId = 52
            when 46   #"Swine"    '16
                manureProduced = 5
                bioConsumed = 9.1
                urineProduced = 17.7
                manureId = 46
            when 52   #"Broiler"    '17
                manureProduced = 10.4
                bioConsumed = 10
                urineProduced = 6.8
                manureId = 52
            else
                manureProduced = 12
                bioConsumed = 9.08
                urineProduced = 0
                manureId = 56
        end   # end case

        if animals < 1 then
            animals = 1
        end
        #If _animals.Count = 0 Then LoadAnimalUnits()
        #For Each animal In _animals
        #    If animal.Number.Split("|")(0) = manureId Then
        #        conversionUnit = animal.ConversionUnit
        #    End If
        #Next

		conversion_unit = Fertilizer.find_by_code(manureId).convertion_unit
        @last_herd += 1
        animalField = animals * soil_percentage / 100
        herdFile = sprintf("%4d", @last_herd) #For different owners
        #comentarized because there is not field divided anymore
        #If _fieldsInfo1(currentFieldNumber)._soilsInfo.Count = 1 Then
        #    herdFile &= Format(CInt((animalField(0) / 2) * conversionUnit), "#####0.0").PadLeft(8)
        #Else
        #    herdFile &= Format(CInt(animalField(i) * conversionUnit), "#####0.0").PadLeft(8)
        #End If
        herdFile += sprintf("%8.1f", (animalField * conversion_unit).round(0))
        herdFile += sprintf("%8.1f", animal_code)
        herdFile += sprintf("%8.2f",(24 - hours) / 24)
        herdFile += sprintf("%8.2f",bioConsumed)
        herdFile += sprintf("%8.2f",manureProduced)
        herdFile += sprintf("%8.2f",urineProduced)
        @herd_list.push(herdFile + "\n")
        #duplicate in case it is just one soil because the area is divided in two equal fields.
        #If _fieldsInfo1(currentFieldNumber)._soilsInfo.Count = 1 Then
        #    herdList.Add(herdFile)
        #End If

        herdFile += ""
		msg = send_file_to_APEX(@herd_list, "HERD.dat")
        return bioConsumed
    end #end create_herd_file
end
