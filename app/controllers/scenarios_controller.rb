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
	create_subareas(1)
	#build_xml()

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
	PHMIN = 3.5
    PHMAX = 9.0
	OCMIN = 0.0      #change from 0.5 to 0 according to Ali. APEX calculate it if 0.
    OCMAX = 2.5
	OM_TO_OC = 1.724
	BDMIN = 1.1
    BDMAX = 1.79
	SoilPMaxForSoilDepth = 15.24
	SoilPDefault = 0.1

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
		 @soil_info = Array.new
		 soil_list = Array.new
		 soils = Soil.where(:field_id => @scenario.field_id).where(:selected => true)
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
                records = " .sol file Soil: " + soil_file_name + " Date: " + dtNow1 + " Soil Name: " + soil.name
				@soil_info.push(records + "\n")                
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
                    #For j = 0 To texture.Length - 1
                    #    If layer("texture").Contains(texture(j))  Exit For
                    #Next

                    if layer_number == 1
                        #validate if this layer is going to be used for Agriculture Lands
                        if layer.depth <= 5 && layer.sand = 0 && layer.silt = 0 && layer.organic_matter > 25 && layer.bulk_density < 0.8
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
                    #if Depth[layer_number] > maxDepth(i) && maxDepth(i) > 0  Exit For
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
                    if layer.cec == 0 
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
                    #These lines were changed to take sand from xml file in case user had changed it
					woc[layer_number] = 0
                    if layer.organic_matter == 0 
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
                    depth[initial_layer] = 10
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
                end
				#Line 2 Column 1 and 2
                if albedo == 0 
					albedo = 0.2
				end
                records = "%4s%.2f" %['',albedo]
                #records =  albedo.to_s
                case hsg
                    when "A"
                        records = records + "      1."
                    when "B"
                        records = records + "      2."
                    when "C"
                        records = records + "      3."
                    when "D"
                        records = records + "      4."
                end
				soil.ffc = 0 unless !(soil.ffc==nil)
                records = records + "%4s%.2f" %['', soil.ffc]
				soil.wtmn = 0 unless !(soil.wtmn==nil)
                records = records + "%4s%.2f" %['', soil.wtmn]
				soil.wtmx = 0 unless !(soil.wtmx==nil)
                records = records + "%4s%.2f" %['', soil.wtmx]
				soil.wtbl = 0 unless !(soil.wtbl==nil)
                records = records + "%4s%.2f" %['', soil.wtbl]
				soil.gwst = 0 unless !(soil.gwst==nil)
                records = records + "%4s%.2f" %['', soil.gwst]
				soil.gwmx = 0 unless !(soil.gwmx==nil)
                records = records + "%4s%.2f" %['', soil.gwmx]
				soil.rft = 0 unless !(soil.rft==nil)
                records = records + "%4s%.2f" %['', soil.rft]
				soil.rfpk = 0 unless !(soil.rfpk==nil)
                records = records + "%4s%.2f" %['', soil.rfpk]
				@soil_info.push(records + "\n")
				#Line 3 Column 1 to 7
                records = ""
				soil.tsla = 0 unless !(soil.tsla==nil)
                records = records + "%4s%.2f" %['', soil.tsla]
				soil.xids = 0 unless !(soil.xids==nil)
                records = records + "%4s%.2f" %['', soil.xids]
				soil.rtn1 = 0 unless !(soil.rtn1==nil)
                records = records + "%4s%.2f" %['', soil.rtn1]
				soil.xidk = 0 unless !(soil.xidk==nil)
                records = records + "%4s%.2f" %['', soil.xidk]
				soil.zqt = 0 unless !(soil.zqt==nil)
                records = records + "%4s%.2f" %['', soil.zqt]
				soil.zf = 0 unless !(soil.zf==nil)
                records = records + "%4s%.2f" %['', soil.zf]
				soil.ztk = 0 unless !(soil.ztk==nil)
                records = records + "%4s%.2f" %['', soil.ztk]
                @soil_info.push(records + "\n")
				records = ""
				session[:layer_number] = layer_number
				for layers in initial_layer..layer_number -1
					records = records + sprintf("%8.3f", (depth[layers] / 100))
                end
                @soil_info.push(records + "\n")
				records = ""
                for layers in initial_layer..layer_number - 1
                    if bulk_density[layers] == 0
					  bulk_density[layers] = 1.3
					end
                    records = records + sprintf("%8.3f", bulk_density[layers])
                end
                @soil_info.push(records + "\n")
				records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.3f", uw[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.3f", fc[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", sand[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", silt[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", wn[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", ph[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", smb[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", woc[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", cac[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", cec[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", rok[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", cnds[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    if depth[layers] > SoilPMaxForSoilDepth
					  ssf[layers] = SoilPDefault
					end
                    if ssf[layers] = 0
					  ssf[layers] = SoilPDefault
					end
                    records = records + sprintf("%8.2f", ssf[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", rsd[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", bdd[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", psp[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", satc[layers])
                end
                @soil_info.push(records + "\n")                
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", hcl[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                for layers in initial_layer..layer_number - 1
                    records = records + sprintf("%8.2f", wpo[layers])
                end
                @soil_info.push(records + "\n")
                records = ""
                #this lines are not added at this time to reduced the size of the information to be transmited to the server. The server will include them in blanks for now. 5/30/2014.
                #INSERT LINES 25, 26, 27, 28
                soil_list.push("  " + "%3s" %["",last_soil1] + " APEX" + "%3s" %["",last_soil1] + ".sol")
                i += 1
				last_soil = last_soil1
				path = File.join(APEX, soil_file_name)
				content = @soil_info
				File.open(path, "w+") do |f|
					@soil_info.each do |row| f << row end
				end  #{ |f| f.write(@soil_info)}
			end  # end soils do
		end  # end method create_soils


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

	def create_subareas(fields)  # fields is used for subprojects as for now it is just 1 - todo
	    last_soil1 = 0
        last_owner1 = 0
        i = 0
		soils = Soil.where(:field_id => @scenario.field_id).where(:selected => true)

        soils.each do |soil|
            #create the operation file for this subarea.
            nirr = create_operations(soil)  #todo activate createOperations
            #create the subarea file
			bmp = Bmp.where(:scenario_id => params[:id]).find_by_bmpsublist_id(15)
			if !(bmp == nil)
            #if !(bmps.CBCWidth > 0 And _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBBWidth > 0 And _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bmpsInfo.CBCrop > 0) Then
                addSubareaFile(soil._scenariosInfo(currentScenarioNumber)._subareasInfo, operationNumber, last_soil1, last_owner1, i, nirr, False)
                i = i + 1
            end
        end
        if last_soil1 > 0 
            last_soil_sub = last_soil1 - 1
        else
            last_soil_sub = 0
        end
        last_subarea = 0

        #For Each buf In _fieldsInfo1(currentFieldNumber)._scenariosInfo(currentScenarioNumber)._bufferInfo
		Buffer.each do |buf|
            if !(buf.SbaType = "PPDE" || buf.SbaType = "PPTW" || buf.SbaType = "AITW" || buf.SbaType = "CBMain") 
                #create the operation file for this subarea.
                last_subarea += 1
                opcsFile.Add(buf.SubareaTitle)
                opcsFile.Add(".OPC " & buf.SubareaTitle + " file Operation:1  Date: " + Now.ToString)
                opcsFile.Add(buf._operationsInfo(0).LuNumber.ToString.PadLeft(4))
				operations = Operation.where(:scenario_id => params[:id])
                #For Each oper In buf._operationsInfo
				operations.each do |oper|
                   opcsFile.Add(oper.Year.ToString.PadLeft(3) + oper.Month.ToString.PadLeft(3) + oper.Day.ToString.PadLeft(3) + oper.ApexOp.ToString.PadLeft(5) + 0.to_s.PadLeft(5) + oper.ApexCrop.ToString.PadLeft(5) + oper.ApexOpType.ToString.PadLeft(5) + (oper.OpVal1.ToString + ".0").PadLeft(8) + (oper.OpVal2.ToString + ".0").PadLeft(8))
                end
                opcsFile.Add("End " & buf.SubareaTitle)
            end 
            addSubareaFile(buf, operationNumber, last_soil1, last_owner1, 0, 0, True)
        end

        last_soil_sub = last_soil1
        last_owner = last_owner1
        #todo check this one.
        #last_subarea += _fieldsInfo1(currentFieldNumber)._soilsInfo(i - 1)._scenariosInfo(currentScenarioNumber)._subareasInfo._line2(0).Iops

        return "OK"
	end 

	def create_operations(soil)
	end
end
