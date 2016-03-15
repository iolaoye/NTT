class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.json
  def index 
    @projects = Project.where(:user_id => params[:user_id])
    respond_to do |format|
      format.html   # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show   #selected when click on a project or a new project is created.
    if params[:id] == "upload" then 
		redirect_to "upload"
	end 
    session[:project_id] = params[:id]
    @location = Location.find_by_project_id(params[:id])
    redirect_to location_path(@location.id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def shows
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html { render action: "show" } # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
	session[:project_id] = @project.id
	@project.user_id = session[:user_id]
	@project.version = "NTTG3"
    respond_to do |format|
      if @project.save
		location = Location.new
		location.project_id = @project.id
		location.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to welcomes_url }
      format.json { head :no_content }
    end
  end

  def upload 
	#nothing to do here. Just render the upload view
  end

	########################################### UPLOAD PROJECT FILE IN XML FORMAT ##################
	def upload_project
		@data = Hash.from_xml(params[:project].read)
		#step 1. save project information
			save_project_info
		#step 2. Save location information
			save_location_info
		#step 3. Save field information
			for i in 0..@data["Project"]["FieldInfo"].size-1
				save_field_info(i)
			end
		#step 4. Save Weather Information
			@projects = Project.where(:user_id => session[:user_id])
			render :action => "index"
	end

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def project_params
      params.require(:project).permit(:description, :name)
    end

	def save_project_info
		project = Project.new
		project.user_id = session[:user_id]
		project.name = @data["Project"]["StartInfo"]["projectName"]
		project.description = @data["Project"]["StartInfo"]["Description"]
		project.version = "NTTG3"
		project.save
		session[:project_id] = project.id
	end 

	def save_location_info
		location = Location.new
		location.project_id = session[:project_id]
		location.state_id = State.find_by_state_abbreviation(@data["Project"]["StartInfo"]["StateAbrev"]).id
		location.county_id = County.find_by_county_state_code(@data["Project"]["StartInfo"]["CountyCode"]).id
		location.status = @data["Project"]["StartInfo"]["Status"]
		location.coordinates = @data["Project"]["FarmInfo"]["Coordinates"]
		location.save
		session[:location_id] = location.id
	end

	def save_field_info(i)
		field = Field.new
		field.location_id = session[:location_id]
		field.field_name = @data["Project"]["FieldInfo"][i]["Name"]
		field.field_area = @data["Project"]["FieldInfo"][i]["Area"]
		field.field_average_slope = @data["Project"]["FieldInfo"][i]["AvgSlope"]
		field.field_type = @data["Project"]["FieldInfo"][i]["Forestry"]
		field.coordinates = @data["Project"]["FieldInfo"][i]["Coordinates"]
		field.save
		# Step 5. save Weather Info
		save_weather_info(field.id)
	end

	def save_weather_info(field_id)
		weather = Weather.new
		weather.field_id = field_id
		weather.station_way =  @data["Project"]["StartInfo"]["StationWay"]
		weather.simulation_initial_year =  @data["Project"]["StartInfo"]["StationInitialYear"]
		weather.simulation_final_year =  @data["Project"]["StartInfo"]["StationFinalYear"]
		weather.simulation_final_year =  @data["Project"]["StartInfo"]["StationFinalYear"]
		weather.latitude =  @data["Project"]["StartInfo"]["WeatherLat"]
		weather.longitude =  @data["Project"]["StartInfo"]["WeatherLon"]
		weather.weather_file =  @data["Project"]["StartInfo"]["CurrentWeatherPath"]
		weather.way_id = Way.find_by_way_name(@data["Project"]["StartInfo"]["StationWay"]).id
		weather.save
	end
end
