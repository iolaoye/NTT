include LocationsHelper
include ScenariosHelper
class LocationsController < ApplicationController

################################  Load Shapefile  #################################
# 
  def upload_shapefile
    @shp_path = "/Users/gallego/Downloads/NTT_Example/NTT_Example.shp"
    filepath = Rails.root.join("lib", "external_scripts", "get_coords.r /Users/gallego/Downloads/NTT_Example/NTT_Example.shp")
    output = `Rscript --vanilla #{filepath}`
    @found_fields = output.split("Field:")    
  end
################################  INDEX  #################################
# GET /locations
# GET /locations.json
  def index
    @location = @project.location
    first=0
    @states = State.all
    @counties = County.where(:state_id => 1)
    @preAddress = params[:textAddress]
    @prelatLng = params[:textlatlng]
    @preDrawnAOI = 'farm: farm, '
    case params[:submit]
    when "Submit"
      receive_from_mapping_site1
      redirect_to project_fields_path(@project.id)
    when "Upload Shapefile" 
      upload_shapefile
      @found_fields.each do |field|
        if first == 0 then
          first += 1
         next 
       end
        field_parts = field.split("|")
        if first == 1 then 
          @preDrawnAOI = @preDrawnAOI + field_parts[1]
          first += 1
        end
        @preDrawnAOI = @preDrawnAOI + " field: " + field_parts[0] + ", " + "0.00" + ", " + field_parts[1]
      end
    else
      @project.location.fields.each do |field|
        if first==0 then
          @preDrawnAOI = @preDrawnAOI + field.coordinates.strip + " " + field.coordinates.strip.split(/ / )[0]
          first = 1
        end
        @preDrawnAOI = @preDrawnAOI + " field: " + field.field_name + ", " + field.field_area.to_s + ", " + field.coordinates.strip + " " + field.coordinates.strip.split(/ / )[0]
      end
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @locations }
      end
    end
    #@preDrawnAOI = 'farm: farm, -93.453614,43.694913 -93.453485,43.687559 -93.446705,43.687559 -93.446061,43.686938 -93.445546,43.686472 -93.444859,43.686162 -93.444173,43.686131 -93.443572,43.686286 -93.443572,43.694882  -93.453614,43.694913
    #  field: Field1, 0, -93.453614,43.694913 -93.453485,43.687559 -93.446705,43.687559 -93.446061,43.686938 -93.445546,43.686472 -93.444859,43.686162 -93.444173,43.686131 -93.443572,43.686286 -93.443572,43.694882  -93.453614,43.694913'
    add_breadcrumb t('menu.soils'), project_locations_path(@project)
    add_breadcrumb t('menu.layers') 

  end
  # GET /locations
  # GET /locations.json
  def location_fields
    flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('models.project')
    redirect_to list_field_path(session[:location_id])
  end

  ###################################### SHOW ######################################
  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    add_breadcrumb t('menu.location')
    @project_name = @project.name
    session[:location_id] = params[:id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  ###################################### SHOWS ######################################
  # GET /locations/1
  # GET /locations/1.json
  def shows
    @location = Location.find_by_project_id(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  ###################################### send_to_mapping_site ######################################
  def send_to_mapping_site
    @location = Location.find_by_project_id(params[:id])
    if !(@location.county_id == nil) and !(@location.county_id == 0)
      @county = County.find(@location.county_id)
    end
    render :send_to_mapping_site, :layout => false
  end

  ###################################### receive_from_mapping_site ######################################
  def receive_from_mapping_site
    @location = Location.find_by_project_id(params[:id])
    if (params[:error] == "") then
      if (session[:session_id] == params[:source_id]) then
        # step 1: delete fields not found
        @location.fields.each do |field|
          isFound = false
          for i in 1..params[:fieldnum].to_i
            if (field.field_name == params["field#{i}id"]) then
              isFound = true
            end
          end
          if (!isFound) then
            field.destroy
          end # end if isFound
        end # end Location do
        # step 2: update or create remaining fields
        for i in 1..params[:fieldnum].to_i
          # find or create field
          @field = @location.fields.where(:field_name => params["field#{i}id"]).first || @location.fields.build(:field_name => params["field#{i}id"])
          @field.coordinates = params["field#{i}coords"]
          @field.field_area = params["field#{i}acres"]
          @field.updated = true
          #verify if this field aready has its soils. If not the soils coming from the map are added
          if !(params["field#{i}error"] == 1) then
            #if @field.id == nil then
            #	if Field.all.length == 0
            #		@field.id = 1
            #	else
            #		@field.id = Field.last.id += 1
            #	end
            #end
            if @field.save
			         #create_soils(i, @field.id, @field.field_type).  #commented because the solils will be gotten in fields page
		        else
			         msg = "Error saving soils"
		        end 
          end
          #step 3 find or create site
          site = Site.find_by_field_id(@field.id)
          if (site == nil) then
            #create the site for this field
            site = Site.new
          end #end weather validation
          centroid = calculate_centroid()
          site.ylat = centroid.cy
          site.xlog = centroid.cx
          site.elev = 0
          site.apm = 1
          site.co2x = 0
          site.cqnx = 0
          site.rfnx = 0
          site.upr = 0
          site.unr = 0
          site.fir0 = 0
          site.field_id = @field.id
          site.save
          #step 4 find or create weather
          if (@field.weather_id == nil or @field.weather == nil) then
            #create the weather for this field
            @weather = Weather.new
          else
            #update the weather for this field
            @weather = Weather.find(@field.weather_id)
          end #end weather validation
          @weather.weather_file = params["field#{i}parcelweather"]
          if (params["field#{i}initialYear"] == nil) then
    				@weather.simulation_initial_year = 0
    			else
            @weather.simulation_initial_year = params["field#{i}initialYear"]
    			end
    			@weather.simulation_initial_year += 5
           if params["field#{i}finalYear"] == nil then
    				@weather.simulation_final_year = @weather.simulation_initial_year + 5
    			else
    				@weather.simulation_final_year = params["field#{i}finalYear"]
    			end
           if params["field#{i}initialYear"] == nil then
    				@weather.weather_initial_year = @weather.simulation_initial_year - 5
    			else
    				@weather.weather_initial_year = params["field#{i}initialYear"]
    			end
          if params["field#{i}finalYear"] == nil then
    				@weather.weather_final_year = @weather.simulation_final_year
    			else
    				@weather.weather_final_year = params["field#{i}finalYear"]
    			end
          @weather.latitude = site.ylat
          @weather.longitude = site.xlog
          @weather.way_id = 1 #assign PRISM weather station to the weather way as default from map
          @weather.station_way = "map"
          if @weather.save then
            @field.weather_id = @weather.id
          end
          if @field.save then
            flash[:notice] = t('models.field') + "(s)" + t('notices.multiple_created')
    	      @weather.field_id = @field.id
    	      session[:field_id] = @field.id
          end
          @weather.save
        end # end for fields
        # step 5: update location
        state_abbreviation = params[:state]
  		  if state_abbreviation.length > 2 then  #if state_abbreviation.length > 2 means it is state name
  			 state = State.find_by_state_name(state_abbreviation.strip)		  
  		  else
  			 state = State.find_by_state_abbreviation(state_abbreviation)
  		  end
  		  if state == nil then
  			 @location.state_id = 0
  		  else
  			 @location.state_id = state.id
  		  end
  		  county_name = params[:county]
        if @location.state_id > 0 
          if county_name == nil then
    			  @location.county_id = 0
    		  else
    			  county_name.slice! " County"
            county_name.slice! " Parish"   #Lousiana Counties
            county_name.slice! "  Borough" #Alaska Counties.
            county_name.slice! "'s"
            county = state.counties.where("county_name like '%" + county_name + "%'").first
    			  #county = County.find_by_county_name(county_name)
    			  if county == nil then 
    				  @location.county_id = 0
    			  else
    				  @location.county_id = county.id
    			  end 
    		  end
        else
          @location.county_id = 0
        end
        @location.coordinates = params[:parcelcoords]
        @location.save
        # step 6 load parameters and controls for the specific state or general if states controls and parms are not specified
        load_controls()
        load_parameters(0)
      end # end if of session_id check
    end # end if error
  	respond_to do |format|
      format.html # Runs receive_from_mapping_site.html.erb view in location folder
	  end
  end
  #end method receiving from map site

 ###################################### receive_from_mapping_site ######################################
  def receive_from_mapping_site1
    if (params[:error] == "" or params[:error] == nil) then
        #get the number of fields submitted
        fields = params[:FieldsName].split(",")
        # step 1: delete fields not found
        @location.fields.each do |field|
          isFound = false
          for i in 0..fields.count - 1
            if (field.field_name == fields[i]) then
              isFound = true
            end
          end
          if (!isFound) then
            field.destroy
          end # end if isFound
        end # end Location do
        # step 2: update or create remaining fields
        for i in 0..fields.count - 1
          # find or create field
          @field = @location.fields.where(:field_name => fields[i]).first || @location.fields.build(:field_name => fields[i])
          @field.coordinates = params[:FieldsXY].split(" ,")[i]
          @field.field_area = params[:FieldArea].split(",")[i].to_f / AC_TO_M2
          @field.updated = true
          if @field.save
             #create_soils(i, @field.id, @field.field_type).  #commented because the solils will be gotten in fields page
          else
             msg = "Error saving soils"
          end 
          #step 3 find or create site
          site = Site.find_by_field_id(@field.id)
          if (site == nil) then
            #create the site for this field
            site = Site.new
          end #end weather validation
          centroid = calculate_centroid()
          site.ylat = centroid.cy
          site.xlog = centroid.cx
          site.elev = 0
          site.apm = 1
          site.co2x = 0
          site.cqnx = 0
          site.rfnx = 0
          site.upr = 0
          site.unr = 0
          site.fir0 = 0
          site.field_id = @field.id
          site.save
          #step 4 find or create weather
          if (@field.weather_id == nil or @field.weather == nil) then
            #create the weather for this field
            @weather = Weather.new
          else
            #update the weather for this field
            @weather = Weather.find(@field.weather_id)
          end #end weather validation
          save_prism()
          @field.weather_id = @weather.id
          # end
          if @field.save then
            flash[:notice] = t('models.field') + "(s)" + t('notices.multiple_created')
            @weather.field_id = @field.id
            @weather.save
            session[:field_id] = @field.id
          end
          #@weather.save
        end # end for fields
        # step 5: update location
        state_abbreviation = params[:StateAbbr]
        if state_abbreviation.length > 2 then  #if state_abbreviation.length > 2 means it is state name
         state = State.find_by_state_name(state_abbreviation.strip)     
        else
         state = State.find_by_state_abbreviation(state_abbreviation)
        end
        if state == nil then
         @location.state_id = 0
        else
         @location.state_id = state.id
        end
        county_name = params[:CountyName]
        if @location.state_id > 0 
          if county_name == nil then
            @location.county_id = 0
          else
            county_name.slice! " County"
            county_name.slice! " Parish"   #Lousiana Counties
            county_name.slice! "  Borough" #Alaska Counties.
            county_name.slice! "'s"
            county = state.counties.where("county_name like '%" + county_name + "%'").first
            #county = County.find_by_county_name(county_name)
            if county == nil then 
              @location.county_id = 0
            else
              @location.county_id = county.id
            end 
          end
        else
          @location.county_id = 0
        end
        @location.coordinates = params[:FarmXY]
        @location.save
        # step 6 load parameters and controls for the specific state or general if states controls and parms are not specified
        load_controls()
        load_parameters(0)
      #end # end if of session_id check
    end # end if error
  end
  #end method receiving from map site
 ###################################### new######################################  
  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  ###################################### EDIT ######################################
  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  ###################################### CREATE ######################################
  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def location_params
    params.require(:location).permit(:county_id, :project_id, :state_id, :status)
  end

  ###################################### create_soil ######################################
  ## Create soils receiving from map for each field.
  def create_soils(i, field_id, forestry)
    #delete all of the soils for this field
    soils1 = Soil.where(:field_id => field_id)
    soils1.destroy_all #will delete Subareas and SoilOperations linked to these soils
    total_percentage = 0
    for j in 1..params["field#{i}soils"].to_i
	  if params["field#{i}soil#{j}error"] then
		  next
	  end # end if soil.error
      @soil = @field.soils.new
      @soil.key = params["field#{i}soil#{j}mukey"]
      @soil.symbol = params["field#{i}soil#{j}musym"]
      @soil.group = params["field#{i}soil#{j}hydgrpdcd"]
      @soil.name = params["field#{i}soil#{j}muname"]
      @soil.albedo = params["field#{i}soil#{j}albedo"]
      @soil.slope = params["field#{i}soil#{j}slope"]
      @soil.percentage = params["field#{i}soil#{j}pct"]
      @soil.percentage = @soil.percentage.round(2)
      @soil.drainage_id = params["field#{i}soil#{j}drain"]
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
        if !(params["field#{i}soil#{j}error"] == 2) then
          create_layers(i, j)
        end
      end
    end #end for create_soils
    soils = Soil.where(:field_id => field_id).order(percentage: :desc)

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
      add_scenario_to_soils(scenario)
	    operations = Operation.where(:scenario_id => scenario.id)
	    operations.each do |operation|
		  soils.each do |soil|
			   update_soil_operation(SoilOperation.new, soil.id, operation)
		  end # end soils each
	  end # end operations.each
    end #end Scenario each do
  end

  ###################################### create_soil layers ######################################
  ## Create layers receiving from map for each soil.
  def create_layers(i, j)
    for l in 1..params["field#{i}soil#{j}layers"].to_i
      layer = @soil.layers.new

      layer.sand = params["field#{i}soil#{j}layer#{l}sand"]
      layer.silt = params["field#{i}soil#{j}layer#{l}silt"]
      layer.clay = params["field#{i}soil#{j}layer#{l}clay"]
      layer.bulk_density = params["field#{i}soil#{j}layer#{l}bd"]
      layer.organic_matter = params["field#{i}soil#{j}layer#{l}om"]
      layer.ph = params["field#{i}soil#{j}layer#{l}ph"]
      layer.depth = params["field#{i}soil#{j}layer#{l}depth"]
      layer.depth /= IN_TO_CM
      layer.depth = layer.depth.round(2)
      layer.cec = params["field#{i}soil#{j}layer#{l}cec"]
      layer.soil_p = 0
      if layer.save then
      else
      end
    end #end for create_layers
  end

  #todo Update years of simulation + initialyear in weather.
  def load_controls()
    apex_controls = ApexControl.where(:project_id => @project.id)
    if apex_controls == [] then
      controls = Control.where(:state_id => @project.location.state_id)
      if controls.blank? || controls == nil then
        controls = Control.where(:state_id => 99)		
      end
      controls.each do |c|
        apex_control = ApexControl.new
        apex_control.control_description_id = c.number
        apex_control.value = c.default_value
        apex_control.project_id = @project.id
        if apex_control.control_description_id == 1 then
          apex_control.value = @weather.simulation_final_year - @weather.simulation_initial_year + 1 + 5
        end
        if apex_control.control_description_id == 2 then
          apex_control.value = @weather.simulation_initial_year - 5
        end
        apex_control.save
      end # end control all
    end # end if
  end  #end method
end
