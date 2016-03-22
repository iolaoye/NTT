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
    @scenarios = Scenario.all
	ddd
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scenarios }
    end
  end

################################  simulate the selected scenario  #################################
  # GET /scenarios/1
  # GET /scenarios/1.json
  def show  
    @doc = "Nothing"
    @scenario = Scenario.find(params[:id])
	dir_name = "#{Rails.root}/data/#{session[:session_id]}"
	Dir.mkdir(dir_name) unless File.exists?(dir_name)

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
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { render json: @scenario, status: :created, location: @scenario }
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
end
