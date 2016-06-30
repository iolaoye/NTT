include ScenariosHelper
class LocationsController < ApplicationController

  # GET /locations
  # GET /locations.json
  def location_fields
    redirect_to list_field_path(session[:location_id])	
  end

  ###################################### SHOW ######################################
  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
	  @project_name = Project.find(session[:project_id]).name
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
	@project_name = Project.find(params[:id]).name
	session[:project_id] = params[:id]
	session[:location_id] = @location.id

	respond_to do |format|
  	  if !(params[:error] == "") then
        format.html { redirect_to location_path(@location.id), notice: params[:error] }
      else
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
				field.destroy()
			end  # end if isFound
			end # end Location do

			# step 2: update or create remaining fields
			for i in 1..params[:fieldnum].to_i
				# find or create field
				@field = @location.fields.where(:field_name => params["field#{i}id"]).first || @location.fields.build(:field_name => params["field#{i}id"])
				@field.coordinates = params["field#{i}coords"]
				@field.field_area = params["field#{i}acres"]
		
				#verify if this field aready has its soils. If not the soils coming from the map are added
				if !(params["field#{i}error"] == 1) then
					if @field.id == nil then
						if Field.all.length == 0
							@field.id = 1
						else
							@field.id = Field.last.id += 1
						end 
					end
					create_soils(i, @field.id, @field.field_type)
				end
				#step 3 find or create site
				site = Site.find_by_field_id(@field.id)
				if (site == nil) then
					#create the site for this field
					site = Site.new
				end   #end weather validation
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
				if (@field.weather_id == nil) then
					#create the weather for this field
					@weather = Weather.new
				else
					#update the weather for this field
					@weather = Weather.find(@field.weather_id)
				end   #end weather validation
				@weather.weather_file = params["field#{i}parcelweather"]
				@weather.simulation_initial_year = params["field#{i}initialYear"]
				@weather.simulation_final_year = params["field#{i}finalYear"]
				@weather.weather_initial_year = params["field#{i}initialYear"]
				@weather.weather_final_year = params["field#{i}finalYear"]
				@weather.latitude = site.ylat
				@weather.longitude = site.xlog
				@weather.way_id = 1   #assign PRISM weather station to the weather way as default from map
				@weather.station_way = "map"
				if @weather.save then
					@field.weather_id = @weather.id
				end 
				@field.save
				@weather.field_id = @field.id
				session[:field_id] = @field.id
				@weather.save
			end # end for fields

			# step 5: update location	  
			state_abbreviation = params[:state]
			state = State.find_by_state_abbreviation(state_abbreviation) 
			@location.state_id = state.id
			county_name = params[:county]
			county_name.slice! " County"
			county = County.find_by_county_name(county_name)
			@location.county_id = county.id
			@location.coordinates = params[:parcelcoords]
			@location.save
			# step 6 load parameters and controls for the specific state or general if states controls and parms are not specified
			load_controls()
			load_parameters()
		end # end if of session_id check
		format.html # Runs receive_from_mapping_site.html.erb view
      end  # end if error
	end
  end  #end method receiving from map site
 
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
  uuuu
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
	soils1.delete_all
	#todo since all of the soils are deleted all of the subareas need to be created again. Also, the SoilOperation needs to be deleted and created again.
	total_percentage = 0
    for j in 1..params["field#{i}soils"].to_i
  	   @soil = @field.soils.new
	   @soil.key = params["field#{i}soil#{j}mukey"]
	   @soil.symbol = params["field#{i}soil#{j}musym"]
       @soil.group = params["field#{i}soil#{j}hydgrpdcd"]
	   @soil.name = params["field#{i}soil#{j}muname"]
	   @soil.albedo = params["field#{i}soil#{j}albedo"]
	   @soil.slope = params["field#{i}soil#{j}slope"]
	   @soil.percentage = params["field#{i}soil#{j}pct"]
	   @soil.drainage_type = params["field#{i}soil#{j}drain"]
	   @soil.tsla = 10
	   @soil.xids = 1
	   @soil.wtmn = 0
	   @soil.wtbl = 0
	   @soil.ztk = 1
	   @soil.zqt = 2
	   if @soil.drainage_type != nil then
		   case true
			  when @soil.drainage_type.downcase.include?("well") || @soil.drainage_type.downcase.include?("excessively")
				@soil.wtmx = 0
			  when @soil.drainage_type.downcase == ""
				@soil.wtmx = 0
			  when @soil.drainage_type.downcase == "very poorly drained" || @soil.drainage_type.downcase == "poorly drained"
				@soil.wtmx = 4
				@soil.wtmn = 1
				@soil.wtbl = 2
			  when @soil.drainage_type.downcase == "somewhat poorly drained"
				@soil.wtmx = 4
				@soil.wtmn = 1
				@soil.wtbl = 2
			  else
				soil.wtmx = 0
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
	Scenario.where(:field_id => @field.id).each do |scenario|
		#create_subarea("Soil", i, soil_area, soil.slope, forestry, total_selected, @field.field_name, scenario.id, soil.id, soil.percentage, total_percentage, @field.field_area)
		add_scenario_to_soils(scenario)
	end #end Scenario each do
  end  

 ###################################### create_soil ######################################
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
	   layer.cec = params["field#{i}soil#{j}layer#{l}cec"]
	   layer.soil_p = 0
 	   layer.save
	end #end for create_layers
  end  

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

	#todo Update years of simulation + initialyear in weather. Also, update for state. Now is just one without state
	def load_controls()
		Control.all.each do |c|
			apex_control = ApexControl.new
			apex_control.control_id = c.id
			apex_control.value = c.default_value
			apex_control.project_id = session[:project_id]
			if apex_control.control_id == 1 then
				apex_control.value =  @weather.simulation_final_year - @weather.simulation_initial_year + 1
			end
			if apex_control.control_id == 2 then
				apex_control.value = @weather.simulation_initial_year
			end
			apex_control.save
		end
	end

	def load_parameters()
		Parameter.all.each do |c|
			apex_parameter = ApexParameter.new
			apex_parameter.parameter_id = c.id
			apex_parameter.value = c.default_value
			apex_parameter.project_id = session[:project_id]
			apex_parameter.save
		end
	end
end
