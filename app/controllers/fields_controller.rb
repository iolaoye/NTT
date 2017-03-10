class FieldsController < ApplicationController
################################  scenarios list   #################################
# GET /locations
# GET /locations.json
  def create_soils
	  counties = Location.find(session[:location_id]).coordinates.split(",")
      client = Savon.client(wsdl: URL_SoilsInfo)
	  counties.each do |county|
		response = client.call(:get_soils, message: {"county" => County.find(county).county_state_code})
	  end
  end
################################  scenarios list   #################################
# GET /locations
# GET /locations.json
  def field_scenarios
    session[:field_id] = params[:id]
    redirect_to list_scenario_path
  end

################################  soils list   #################################
# GET /locations
# GET /locations.json
  def field_soils
    session[:field_id] = params[:id]
    redirect_to list_soil_path(params[:id])
  end
################################  get list of fields   #################################
  def get_field_list(location_id)
    session[:simulation] = "watershed"

    @fields = Field.where(:location_id => location_id)
    @project_name = Project.find(params[:project_id]).name

    #add_breadcrumb t('menu.projects'), user_projects_path(current_user)
    #add_breadcrumb @project_name
    #add_breadcrumb t('menu.fields')

    @fields.each do |field|
      field_average_slope = 0
      i = 0
      field.soils.each do |soil|
        if (soil.selected?) then
          field_average_slope = field_average_slope + soil.slope
          i=i+1
        end
      end
      if (field_average_slope > 0) then
        field.field_average_slope = (field_average_slope / i).round(2)
      else
        field.field_average_slope = 0
      end
      field.save
    end
  end
################################  soils list   #################################
# GET /fields/1
# GET /1/fields.json
  def index
    @project = Project.find(params[:project_id])
    @location = @project.location
	session[:location_id] = @location.id
	get_field_list(@location.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end

################################  soils   #################################
  def soils
    @soils = Soil.where(:field_id => params[:id])

    respond_to do |format|
      #format.html # index.html.erb
      redirect_to @soils
      format.json { render json: @soils }
    end
  end

################################  SHOW   #################################
# GET /fields/1
# GET /fields/1.json
  def show
    session[:simulation] = "scenario"
    session[:field_id] = params[:id]
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:id])

    respond_to do |format|
      if Rails.application.config.which_version == "modified"
        format.html { redirect_to project_field_soils_path(@field.location.project, @field) }
      else
        format.html { redirect_to edit_project_field_weather_path(@project, @field) }
      end
      format.json { render json: @field, status: :created, weather: @field.id }
    end
  end

################################  NEW   #################################
# GET /fields/new
# GET /fields/new.json
  def new
    @field = Field.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @field }
    end
  end

################################  EDIT   #################################
# GET /fields/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:id])
  end

################################  CREATE #################################
# POST /fields
# POST /fields.json
  def create
    @field = Field.new(field_params)
    @field.location_id = session[:location_id]
    weather = Weather.new
    weather.way_id = 2
    weather.station_way ="Own"
    weather.weather_file = "No set Yet"
    weather.weather_initial_year = 0
    weather.weather_final_year = 0
    weather.simulation_initial_year = 0
    weather.simulation_final_year = 0
    weather.save
    @field.weather_id = weather.id

    respond_to do |format|
      if @field.save
        weather.field_id = @field.id
        weather.save
        format.html { redirect_to list_field_path(session[:location_id]), notice: 'Field was successfully created.' }
        format.json { render json: @field, status: :created, location: @field }
      else
        format.html { render action: "new" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
# PATCH/PUT /fields/1
# PATCH/PUT /fields/1.json
  def update
    field_type = false
    if params[:field][:field_type].eql?("1") then
      field_type = true
    end
    @field = Field.find(params[:id])
    @project = Project.find(params[:project_id])
    msg = "OK"
    if @field.field_type != field_type then
      if field_type == true then
        #create the forestry additional fields
        msg = add_forestry_field(ROAD, 0.05)
        if msg.eql?("OK") then
          msg = add_forestry_field(SMZ, 0.10)
        end
      else
        #delete the forestry additional fields
        field = Field.find_by_field_name(@field.field_name + ROAD)
        if !(field == nil) then
          field.destroy
        end
        field = Field.find_by_field_name(@field.field_name + SMZ)
        if !(field == nil) then
          field.destroy
        end
      end
    end
    if !@field.update_attributes(field_params)
      msg = "Error saving field"
    end
    respond_to do |format|
      if msg.eql?("OK") then
        session[:field_id] = @field.id
        #format.html { redirect_to edit_weather_path(session[:field_id]), notice: 'Field was successfully updated.' }
		    get_field_list(@field.location_id)
		    format.html { redirect_to project_fields_path(@project), notice: 'Field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit", notice: msg }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

################################  DELETE  #################################
# DELETE /fields/1
# DELETE /fields/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:id])
    if @field.destroy
      flash[:notice] = t('models.field') + " " + @field.field_name + t('notices.deleted')
    end
    respond_to do |format|
      format.html { redirect_to project_fields_path(@project) }
      format.json { head :no_content }
    end
  end

  private

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def field_params
    params.require(:field).permit(:field_area, :field_average_slope, :field_name, :field_type, :location_id, :id, :created_at, :updated_at)
  end

  def add_forestry_field(typ, area)
    field = Field.new
    field.field_name = @field.field_name + typ
    field.field_area = @field.field_area * area
    field.location_id = @field.location_id
    field.field_average_slope = @field.field_average_slope
    field.field_type = true
    field.coordinates = @field.coordinates
    if !field.save #save the road additonal field
      return "Error saving field " + typ
    else
      #add soils for this new field
      soils = Soil.where(:field_id => @field.id)
      soils.each do |soil|
        soil_new = Soil.new(soil.attributes.merge({:field_id => field.id, :id => nil}))
        if !soil_new.save
          return "Error saving Soil"
        else
          #add layers of this soil
          layers = Layer.where(:soil_id => soil.id)
          layers.each do |layer|
            layer_new = Layer.new(layer.attributes.merge({:soil_id => soil_new.id, :id => nil}))
            if !layer_new.save
              return "Error saving layer"
            end
          end
        end
      end # end soils.eah
      #add weather for this new field
      weather = Weather.find_by_field_id(@field.id)
      weather_new = Weather.new(weather.attributes.merge({:field_id => field.id, :id => nil}))
      if !weather_new.save
        return "Error saving Weather information"
      end
    end # end if field.saved
    return "OK"
  end
end
