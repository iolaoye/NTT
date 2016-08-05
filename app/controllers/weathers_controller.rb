class WeathersController < ApplicationController
################################  Save_coordinates   #################################
  # GET /weathers/1
  # GET /weathers/1.json
  def Save_coordinates
	
  end

################################  INDEX   #################################
  # GET /weathers
  # GET /weathers.json
  def index
	@weather = Weather.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weathers }
    end
  end

################################  SHOW   #################################
  # GET /weathers/1
  # GET /weathers/1.json
  def show
	@weather = Weather.find_by_field_id(session[:field_id])
	@project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(session[:field_id]).field_name
	if !(@weather == :nil) # no empty array	
	  if (@weather.way_id == nil)
	     @way = ""
	  else
	     @way = Way.find(@weather.way_id)
	  end
	end		 
	respond_to do |format|
		format.html # show.html.erb
		format.json { render json: @weather }
    end
  end

  # GET /weathers/new
  # GET /weathers/new.json
  def new
    @weather = Weather.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @weather }
    end
  end

  # GET /weathers/1/edit
  def edit
	@weather = Weather.find_by_field_id(params[:id])
	@project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(params[:id]).field_name
	if !(@weather == nil) # no empty array
	  if (@weather.way_id == nil)
	     @way = ""
	  else
	     @way = Way.find(@weather.way_id)
	  end 
	else
		@weather = Weather.new
		@weather.field_id = session[:field_id]
		@weather.way_id = 0
		@weather.simulation_initial_year = 0
		@weather.simulation_final_year = 0
		@weather.weather_initial_year = 0
		@weather.weather_final_year = 0
		#@weather.longitude = 0
		#@weather.latitude = 0 
		@weather.weather_file = ""
		@weather.save
    end
  end

  # POST /weathers
  # POST /weathers.json
  def create
  create
    @weather = Weather.new(weather_params)

    respond_to do |format|
      if @weather.save
        format.html { redirect_to @weather, notice: 'Weather was successfully created.' }
        format.json { render json: @weather, status: :created, location: @weather }
      else
        format.html { render action: "new" }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weathers/1
  # PATCH/PUT /weathers/1.json
  def update
    @weather = Weather.find(params[:id])
	if (params[:weather][:way_id] == "1")
	  respond_to do |format|
		  if @weather.update_attributes(weather_params)
			format.html { redirect_to edit_weather_path(session[:field_id]), notice: 'Weather was successfully updated.' }
			format.json { head :no_content }
		  else
			format.html { render action: "edit" }
			format.json { render json: @weather.errors, status: :unprocessable_entity }
		  end
	  end
	end
	if (params[:weather][:way_id] == "2")
		if (params[:weather][:weather_file] == nil)
				redirect_to edit_weather_path(session[:field_id])
				flash[:info] = t('general.please') + " " + t('general.select') + " " + t('models.file') 
		else
			msg = upload_weather
		    redirect_to edit_weather_path(session[:field_id]),  notice: 'File was successfully uploaded.' 
		end
    end
    if (params[:weather][:way_id] == "3")
		case
		when (params[:weather][:latitude] == "") 
				redirect_to edit_weather_path(session[:field_id])
				flash[:info] = t('weather.latitude') + " " + t('errors.messages.blank')
		when (params[:weather][:longitude] == "")
				redirect_to edit_weather_path(session[:field_id])
				flash[:info] = t('weather.longitude') + " " + t('errors.messages.blank')
        else
		  respond_to do |format|
		    if @weather.update_attributes(weather_params)
			  format.html { redirect_to edit_weather_path(session[:field_id]), notice: 'Weather was successfully updated.' }
			  format.json { head :no_content }
		    end
		  end
        end
	end
  end

  # DELETE /weathers/1
  # DELETE /weathers/1.json
  def destroy
    @weather = Weather.find(params[:id])
    @weather.destroy

    respond_to do |format|
      format.html { redirect_to weathers_url }
      format.json { head :no_content }
    end
  end

	########################################### UPLOAD weather FILE IN TEXT FORMAT ##################
	def upload_weather
		msg = "Error loading file"
	    #@weather = Weather.find_by_field_id(session[:field_id])
		name = params[:weather][:weather_file].original_filename
		# create the file path
		path = File.join(OWN,name)
		# write the file
		File.open(path, "w") { |f| f.write(params[:weather][:weather_file].read)}
		i=0
		data = ""
		File.open(path, "r").each_line do |line|
			data = line.split(/\r\n/)
			break if data[0][2,5].blank?
			line1 = data[0][2,5].to_i
			@weather.simulation_final_year = line1
			@weather.weather_final_year = line1
			if i == 0
				@weather.simulation_initial_year = line1 + 5
				@weather.weather_initial_year = line1
				i = i + 1
			end
		end
		@weather.weather_file = name
		@weather.way_id = 2
		@weather.save
		  if @weather.save then
 			return "OK"
 		  else
 			return msg
 		  end 
	    return 
	end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def weather_params
      params.require(:weather).permit(:field_id, :latitude, :longitude, :simulation_final_year, :simulation_initial_year, :station_way, :way_id, :weather_file)
    end
end
