class ScenariosController < ApplicationController
################################  list of bmps #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_bmps
    session[:scenario_id] = params[:id]
    redirect_to list_bmp_path(params[:id])	
  end
################################  list of operations   #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def scenario_operations
    session[:scenario_id] = params[:id]
    redirect_to list_operation_path(params[:id])	
  end
################################  scenarios list   #################################
  # GET /scenarios/1
  # GET /1/scenarios.json
  def list
    @scenarios = Scenario.where(:field_id => params[:id])
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(session[:field_id]).field_name
		respond_to do |format|
		  format.html # list.html.erb
		  format.json { render json: @fields }
		end
  end
################################  index   #################################
  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.where(:field_id => session[:field_id])
    render "list"
  end

################################  simulate the selected scenario  #################################
  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
	
    @doc = "Nothing"
    @scenario = Scenario.find(params[:id])
	dir_name = APEX + "/APEX" + session[:session_id]
	#dir_name = "#{Rails.root}/data/#{session[:session_id]}"
	if !File.exists?(dir_name)
		Dir.mkdir(dir_name) 
		FileUtils.cp_r(Dir['public/APEX1/*'], dir_name)
	end 
	create_weather_file(dir_name)
	create_soils()
	build_xml()

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scenario }
    end
  end
################################  NEW   #################################
  # GET /scenarios/new
  # GET /scenarios/new.json
  def new
     @scenario = Scenario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

################################  CREATE  #################################
  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
	@scenario.field_id = session[:field_id]
    
	respond_to do |format|
      if @scenario.save
		@scenarios = Scenario.where(:field_id => session[:field_id])
		format.html { render action: "list" }
      else
        format.html { render action: "new" }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      if @scenario.update_attributes(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario = Scenario.find(params[:id])
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to scenarios_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def scenario_params
      params.require(:scenario).permit(:name, :field_id)
    end

	#define constas to use in this controller.
	IN_TO_CM = 2.54
   def build_xml()
       require 'nokogiri'
	   require 'open-uri'
	   require 'net/http'
	   require 'rubygems'

	   project = Project.find(session[:project_id])
	   weather = Weather.find(session[:field_id])
	   soils = Soil.where(:field_id => session[:field_id], :selected => true)

	   builder = Nokogiri::XML::Builder.new do |xml|
		  xml.project {
			xml.start_info {
				#start information
				xml.weather_file weather.weather_file 
				xml.weather_initial_year weather.simulation_initial_year
				xml.weather_final_year weather.simulation_final_year
				xml.weather_latitude weather.latitude
				xml.weather_longitude weather.longitude
				xml.county County.find(Location.find_by_project_id(project.id).county_id).county_state_code
				xml.project_type "Fields"
			}  #start info end
			#soils and layers information
			soils.each do |soil|
				layers = Layer.where(:soil_id => soil.id)
				xml.soils {
					xml.albedo soil.albedo
					xml.group soil.group
					xml.percentage soil.percentage
					xml.ffc soil.ffc
					xml.wtmn soil.wtmn
					xml.wtmx soil.wtmx
					xml.wtbl soil.wtbl
					xml.gwst soil.gwst
					xml.gwmx soil.gwmx
					xml.rft soil.rft
					xml.rfpk soil.rfpk
					xml.tsla soil.tsla
					xml.xids soil.xids
					xml.rtn1 soil.rtn1
					xml.xidk soil.xidk
					xml.zqt soil.zqt
					xml.zf soil.zf
					xml.ztk soil.ztk
					xml.fbm soil.fbm
					xml.fhp soil.fhp
					layers.each do |layer|
						xml.layers {
						xml.depth layer.depth
						xml.soilp layer.soil_p
						xml.bd layer.bulk_density
						xml.sand layer.sand
						xml.silt layer.silt
						xml.clay layer.clay
						xml.om layer.organic_matter
						xml.ph layer.ph
						}  
					end   #layers.each end
				}  #xml.soils end
			end  #soils each end
		}	 #project end
	   end   #builder end

	   content = builder.to_xml
	   xml_string = content.gsub('<', '[').gsub('>', ']')
	   uri = URI(URL_NTT)	   
       res = Net::HTTP.post_form(uri, 'input' => xml_string)
	   @doc = xml_string
	end

	def create_weather_file(dir_name)
		weather = Weather.find_by_field_id(@scenario.field_id)
		if (weather.way_id == 2)
			#copy the file path
			path = File.join(OWN,weather.weather_file)
		else
			path = File.join(PRISM,weather.weather_file)
		end 
		FileUtils.cp_r(path, dir_name + "/APEX.wth")
		#todo after file is copied if climate bmp is in place modified the weather file.
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
         records = ""
         albedo = 0
         #added to control when information is not available
         texture = ["sandy clay loam", "silty clay loam", "loamy sand", "sandy loam", "sandy clay", "silt loam", "clay loam", "silty clay", "sand", "loam", "silt", "clay"]
         sands = [53.2, 8.9, 80.2, 63.4, 52, 15, 29.1, 7.7, 84.6, 41.2, 4.9, 12.7]
         silts = [20.6, 58.9, 14.6, 26.3, 6, 67, 39.3, 45.8, 11.1, 40.2, 85, 32.7]
         satcs = [9.24, 11.4, 94.66, 48.01, 0.8, 15.55, 7.74, 5.29, 107.83, 19.98, 10.64, 2.1]
         bds = [1.49, 1.2, 1.44, 1.46, 1.49, 1.31, 1.33, 1.21, 1.45, 1.4, 1.42, 1.24]
         soil_file_name = ""
         dtNow1  = Date.today.to_s
         last_soil1 = 0
		 last_soil = 0
		 soil_info = Array.new

		 soils = Soil.where(:field_id => @scenario.field_id)
		 #APEXStrings1 = 0
         #check to see if there are soils selected
         selected = false
		 soils.each do |soil|
             if soil.selected == true 
                selected = true
                break
             end
          end
            #if no soils selected the soils are sorted by area and  selects up to the three most dominant soils.
            if selected = false 
				soils.each do |soil|
                    if i > 2 
						break
					end
                    soil.selected = true
                end
            end

            apex_scenarios = 0
            i = 0
			soils.each do |soil|
				if soil.selected = false 
					next
				end
				layers = Layer.where(:soil_id => soil.id)
                last_soil1 = last_soil + i + 1
                soil_file_name = "APEX" + "00" + last_soil1.to_s + ".sol"
                #total_area = total_area + soil.percentage
                apex_scenarios += 1
                records = " .sol file Soil:APEX" + "00" + last_soil1.to_s + ".sol" + "  Date: " + dtNow1 + "Soil Name:" + soils.name
                soil_info.push records
                records = ""
                layer_number = 1
                result = 0
                hsg = " "
                layers.each do |layer|
                    
					# try to find texture from texture description from database
                    #For j = 0 To texture.Length - 1
                    #    If layer("texture").Contains(texture(j))  Exit For
                    #Next

                    if layer_number == 1
                        #validate if this layer is going to be used for Agriculture Lands
                        if layer.depth <= 5 && layer.sand = 0 && layer.silt = 0 && layer.organic_matter > 25 && layer.bulk_density < 0.8
                            next
                        end
                        if soil.albedo <=0 
                            albedo = soils.Albedo
                        else
                            albedo = 0.37
                        end
                    end 

                    if soil.group == nil
                        hsg = "B"
                    else
                        hsg = soils.group
                    end

                    depth[layer_number] = layer.depth * IN_TO_CM

                    #if current layer is deeper than maxDept  no more layers are needed.
                    #if Depth[layer_number] > maxDepth(i) && maxDepth(i) > 0  Exit For
                    #These statements were added to control duplicated layers in the soil.
                    if layer_number > 1 
                        if depth[layer_number] == depth[layer_number - 1] 
							next
						end
                    end

                    if layer.uw <= 0 && layer_number > 1 
                        uw[layer_number] = uw[layer_number - 1]
                    else
                        uw[layer_number] = layer.uw
                    end
                    if layer.fc <= 0 && layer_number > 1 
                        fc[layer_number] = fc[layer_number - 1]
                    else
                        fc[layer_number] = layer.fc
                    end
                    #These lines were changed to take sand from xml file in case user had changed it
                    if layer.sand <= 0 && layer_number > 1 
                        sand[layer_number] = sand[layer_number - 1]
                    else
                        sand[layer_number] = layer.sand
                    end
                    if layer.silt = 0 && layer_number > 1 
                        silt[layer_number] = silt[layer_number - 1]
                    else
                        silt[layer_number] = layer.silt
                    end

                    if layer.wn <= 0 && layer_number > 1 
                        wn[layer_number] = wn[layer_number - 1]
                    else
                        wn[layer_number] = layer.wn
                    end
                    if layer.ph == 0 
                        ph[layer_number] = ph[layer_number - 1]
                    else
                        ph[layer_number] = layer.ph
                    end
                    if ph[layer_number] < PHMIN
					  ph[layer_number] = PHMIN
					end
                    if ph[layer_number] > PHMAX
					  ph[layer_number] = PHMAX
					end

                    if layer.Cec < 0 
                        cec[layer_number] = cec[layer_number - 1]
                    else
                        cec[layer_number] = layer.Cec
                    end

                    smb[layer_number] = 0
                    if layer.smb == 0 && layer_number > 1 
                        smb[layer_number] = smb[layer_number - 1]
                    else
                        smb[layer_number] = layer.smb
                    end
                    #These lines were changed to take sand from xml file in case user had changed it
                    if layer.organic_matter = 0 
                        woc[layer_number] = woc[layer_number - 1]
                    else
                        woc[layer_number] = layer.OM
                    end
                    woc[layer_number] = woc[layer_number] / OM_TO_OC
                    if woc[layer_number] < OCMIN
					  woc[layer_number] = OCMIN
					end
                    if woc[layer_number] > OCMAX  
						woc[layer_number] = OCMAX
					end

                    if layer.cac == 0 && layer_number > 1 
                        cac[layer_number] = cac[layer_number - 1]
                    else
                        cac[layer_number] = layer.cac
                    end
                    if layer.rok == 0 && layer_number > 1 
                        rok[layer_number] = rok[layer_number - 1]
                    else
                        rok[layer_number] = layer.rok
                    end
                    if layer.cnds == 0 && layer_number > 1
                        cnds[layer_number] = cnds[layer_number - 1]
                    else
                        cnds[layer_number] = layer.cnds
                    end
                    if layer.soilp == 0 && layer_number = 1 
                        ssf[layer_number] = ssf(layer_number-1)
                    else
                        ssf[layer_number] = layer.ssf
                    end

                    if layer.rsd == 0 && layer_number > 1 
                        rsd[layer_number] = rsd[layer_number - 1]
                    else
                        rsd[layer_number] = layer.rsd
                    end
                    #These lines were changed to take silt from xml file in case user had changed it
                    if layer.bulk_density == 0 
                        bulk_density[layer_number] = bulk_density[layer_number - 1]
                    else
                        bulk_density[layer_number] = layer.bulk_density
                    end
                    if bulk_density[layer_number] < BDMIN
					  bulk_density[layer_number] = BDMIN
					end
                    if bulk_density[layer_number] > BDMAX
					  bulk_density[layer_number] = BDMAX
					end
                    bdd[layer_number] = bulk_density[layer_number]
                    #psp
                    if layer.psp == 0 && layer_number > 1 
                        psp[layer_number] = psp[layer_number - 1]
                    else
                        psp[layer_number] = layer.psp
                    end
                    sand_silt = sand[layer_number] + silt[layer_number]

                    if cal_satc(sand[layer_number] / 100, (100 - sand_silt) / 100, woc[layer_number] * OM_TO_OC, 1, 0, 0)
						satCondOut = 0
					end
                    satc[layer_number] = satCondOut
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

                    layer_number = layer_number + 1

                    if soils.Slope <= 0 
                        soilSlope = 0.01
                    else
                        soilSlope = (soils.Slope / 100)
                    end
                    if hsg == "" || hsg = nill
						hsg = "B"
					end 
                end
                #if first layer is less than 0.1 m a new layer is added as first one
                initialLayer = 1
                if Math.Round(Depth(1) / 100, 3) > 0.1 
                    Depth[0] = 10
                    bulk_density[0] = bulk_density(1)
                    uw[0] = uw(1)
                    fc[0] = fc(1)
                    sand[0] = sand(1)
                    silt[0] = silt(1)
                    wn[0] = wn(1)
                    ph[0] = ph(1)
                    smb[0] = smb(1)
                    woc[0] = woc(1)
                    cac[0] = cac(1)
                    cec[0] = cec(1)
                    rok[0] = rok(1)
                    cnds[0] = cnds(1)
                    ssf[0] = ssf(1)
                    rsd[0] = rsd(1)
                    bdd[0] = bdd(1)
                    psp[0] = psp(1)
                    satc[0] = satc(1)
                    hcl[0] = hcl(1)
                    wpo[0] = wpo(1)
                    cprv[0] = cprv(0)
                    cprh[0] = cprh(0)
                    initialLayer = 0
                end

                #Line 2 Column 1 and 2
                if albedo == 0 
					albedo = 0.2
				end
                records = ""
                records = Format(albedo, "####0.00").PadLeft(8)
                case hsg
                    when "A"
                        records += "      1."
                    when "B"
                        records += "      2."
                    when "C"
                        records += "      3."
                    when "D"
                        records += "      4."
                end
                records += soils.Ffc.ToString("F2").PadLeft(8)
                records += soils.Wtmn.ToString("F2").PadLeft(8)
                records += soils.Wtmx.ToString("F2").PadLeft(8)
                records += soils.Wtbl.ToString("F2").PadLeft(8)
                records += soils.Gwst.ToString("F2").PadLeft(8)
                records += soils.Gwmx.ToString("F2").PadLeft(8)
                records += soils.Rftt.ToString("F2").PadLeft(8)
                records += soils.Rfpk.ToString("F2").PadLeft(8)
                soilInfo.Add(records)
                #Line 3 Column 1 to 7
                records = ""
                records += soils.Tsla.ToString("F2").PadLeft(8)
                records += soils.Xids.ToString("F2").PadLeft(8)
                records += soils.Rtn1.ToString("F2").PadLeft(8)
                records += soils.Xidk.ToString("F2").PadLeft(8)
                records += soils.Zqt.ToString("F2").PadLeft(8)
                records += soils.Zf.ToString("F2").PadLeft(8)
                records += soils.Ztk.ToString("F2").PadLeft(8)
                soil_info.push(records)
                records = ""
				for layers in initialLayer..layer_number - 1
                    records += (Depth[layers] / 100).ToString("F3").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""

                for layers in initialLayer..layer_number - 1
                    if bulk_density[layers] = 0
					  bulk_density[layers] = 1.3
					end
                    records += bulk_density[layers].ToString("F3").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += uw[layers].ToString("F3").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += fc[layers].ToString("F3").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += sand[layers].ToString("F2").PadLeft(8)
                    #records += Format(sand[layers], "    0.00").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += silt[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += wn[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += ph[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += smb[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += woc[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += cac[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += cec[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += Format(rok[layers], "    0.00").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += cnds[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    if Depth[layers] > SoilPMaxForSoilDepth
					  ssf[layers] = SoilPDefault
					end
                    if ssf[layers] = 0
					  ssf[layers] = SoilPDefault
					end
                    records += ssf[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += rsd[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += bdd[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += psp[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += satc[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += hcl[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                for layers in initialLayer..layer_number - 1
                    records += wpo[layers].ToString("F2").PadLeft(8)
                end
                soilInfo.Add(records)
                records = ""
                #this lines are not added at this time to reduced the size of the information to be transmited to the server. The server will include them in blanks for now. 5/30/2014.
                #INSERT LINES 25, 26, 27, 28
                soilList.Add("  " + Format(last_soil1, "000").PadLeft(8) + " APEX" + Format(last_soil1, "000").PadLeft(3) + ".sol")
                i += 1
            end
            last_soil = last_soil1
		end
end
