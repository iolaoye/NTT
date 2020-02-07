class WeathersController < ApplicationController
include SimulationsHelper
include ScenariosHelper

################################  Save_coordinates   #################################
# GET /weathers/1
# GET /weathers/1.json
  def save_coordinates
    @weather.latitude = params[:weather][:latitude]
    @weather.longitude = params[:weather][:longitude]
    weather_data = get_weather_file_name(@weather.latitude, @weather.longitude)
    if weather_data.include? "Error" then return "Error Saving coordinates" end
    data = weather_data.split(",")
    @weather.weather_file = data[0]
    data[2].slice! "\r\n"
    @weather.simulation_final_year = data[2]
    @weather.weather_final_year = @weather.simulation_final_year
    @weather.weather_initial_year = data[1]
    @weather.simulation_initial_year = @weather.weather_initial_year + 5
    @weather.way_id = 3
    if @weather.save
      return "OK"
    else
      return "Error Saving coordinates"
    end
  end

################################  Save Simulation   #################################
# GET /weathers/1
# GET /weathers/1.json
  def save_simulation
    @weather = Weather.find(params[:id])
    @weather.simulation_initial_year = params[:weather][:simulation_initial_year]
    @weather.simulation_final_year = params[:weather][:simulation_final_year]
    apex_control1 = @project.apex_controls.find_by_control_description_id(1)
    apex_control2 = @project.apex_controls.find_by_control_description_id(2)
    respond_to do |format|
      if @weather.save
    		if @weather.simulation_initial_year - 5 >= @weather.weather_initial_year then
    			apex_control2.value = @weather.simulation_initial_year - 5
    		else
    			apex_control2.value = @weather.weather_initial_year
    		end
    		apex_control2.save
    		apex_control1.value = @weather.simulation_final_year - apex_control2.value + 1
    		apex_control1.save
        format.html { redirect_to edit_project_field_weather_path(@project.id, @field.id, @weather.id), notice: t('models.weather') + " " + t('general.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
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
    @weather = Weather.find_by_field_id(params[:field_id])
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

################################  NEW   #################################
# GET /weathers/new
# GET /weathers/new.json
  def new
    @weather = Weather.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @weather }
    end
  end

################################  EDIT   #################################
# GET /weathers/1/edit
  def edit
    @weather = Weather.find(params[:id])
	  add_breadcrumb t('menu.weather')
    if !(@weather == nil) # no empty array
      if (@weather.way_id == nil)
        @way = ""
      else
        @way = Way.find(@weather.way_id)
      end
    else
      @weather = Weather.new
      @weather.field_id = params[:field_id]
      @weather.way_id = 0
      @weather.simulation_initial_year = 0
      @weather.simulation_final_year = 0
      @weather.weather_initial_year = 0
      @weather.weather_final_year = 0
      @weather.weather_file = ""
      @weather.save
    end
  end

################################  CREATE   #################################
# POST /weathers
# POST /weathers.json
  def create
    @weather = Weather.new(weather_params)
    respond_to do |format|
      if @weather.save
        format.html { redirect_to @weather, notice: t('models.weather') + " " + t('general.success') }
        format.json { render json: @weather, status: :created, location: @weather }
      else
        format.html { render action: "new" }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE   #################################
# PATCH/PUT /weathers/1
# PATCH/PUT /weathers/1.json
  def update
    @weather = Weather.find(params[:id])
    if (params[:weather][:way_id] == "2")
      if params[:weather][:weather_file] == nil
    		if @weather.weather_file == nil || @weather.weather_file == ""
    			redirect_to edit_project_field_weather_path(@project, @field)
    			flash[:info] = t('general.please') + " " + t('general.select') + " " + t('models.file')
    		end
      else
        @weather.way_id = 2
		    msg = upload_weather
      end
    end

    if (params[:weather][:way_id] == "3")
      msg = save_coordinates
    end

    if (params[:weather][:way_id] == "1")
      save_prism
    end

    respond_to do |format|
      if msg != "OK" then
        @weather.errors.add(:upload, t('notices.no_weather'))
        format.html { render action: "edit" }
        format.json { render json: msg, status: :unprocessable_entity }
      else
        if @weather.save
          format.html { redirect_to edit_project_field_weather_path(@project, @field, @weather), notice: t('models.weather') + " " + t('general.updated') }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @weather.errors, status: :unprocessable_entity }
        end
      end
    end

    apex_control = ApexControl.find_by_project_id_and_control_description_id(params[:project_id], 1)
    apex_control.value = @weather.simulation_final_year - @weather.simulation_initial_year + 1 + 5
    apex_control.save
    apex_control = ApexControl.find_by_project_id_and_control_description_id(params[:project_id], 2)
    apex_control.value = @weather.simulation_initial_year - 5
    apex_control.save
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
    name = "(Weather uploaded - uploading a new one will replace the current one)"
    # create the file path
    original_data = params[:weather][:weather_file].read
    input_file = original_data.split(/\r\n/)
    if input_file.count == 1 then 
      input_file = original_data.split(/\n/)
    end
    if input_file.count == 1 then 
      input_file = original_data.split(/\r/)
    end
    i=0
    data = ""
    Clime.where(:field_id => @field.id).delete_all
    input_file.each do |line|
      #data = line.split(/\r\n/)
      data = line.split(" ")
      break if data[0].blank?
      year = data[0].to_i
      if year < 1 or year > 3000 then
        return t('notices.no_weather')
      end
      @weather.simulation_final_year = year
      @weather.weather_final_year = year
      if i == 0
        @weather.simulation_initial_year = year + 5
        @weather.weather_initial_year = year
        i = i + 1
      end
  	  # print the new wehater file in the correct format
      year = sprintf("%4d",data[0].to_i)
      month = sprintf("%4d",data[1].to_i)
      day = sprintf("%4d",data[2].to_i)
  	  sr = ""
  	  tmax = ""
  	  tmin = ""
  	  pcp = ""
  	  rh = ""
  	  ws = ""
  	  if data.length < 7 then 
  		  return "There are missing empty values in this file in " + sprintf("%4d",data[0]) + sprintf("%4d",data[1]) + sprintf("%4d",data[2]) + ". Please fix the problem and try again."
      end 
  	  if data[3].to_f < -90 then sr = sprintf("%7.1f",data[3]) else sr = sprintf("%7.2f",data[3]) end
  	  if data[4].to_f < -90 then tmax = sprintf("%7.1f",data[4]) else tmax = sprintf("%7.2f",data[4]) end
  	  if data[5].to_f < -90 then tmin = sprintf("%7.1f",data[5]) else tmin = sprintf("%7.2f",data[5]) end 
  	  if data[6].to_f < -90 then pcp = sprintf("%7.1f",data[6]) else pcp = sprintf("%7.2f",data[6]) end
      rh = sprintf("%7.2f",0)
      ws = sprintf("%7.2f",0)
  	  case data.length
  		when 8
  			if data[7].to_f < -90 then rh = sprintf("%7.1f",data[7]) else rh = sprintf("%7.2f",data[7]) end
  		when 9
  			if data[8].to_f < -90 then ws = sprintf("%7.1f",data[8]) else ws = sprintf("%7.2f",data[8]) end
  	  end   # end case data.len
      daily_clime = Clime.new
      daily_clime.field_id = @field.id
      daily_clime.daily_weather = "  " + year + month + day + sr + tmax + tmin + pcp + rh + ws + "*"
      daily_clime.save
    end  # end do file.open
    if @weather.simulation_initial_year >= @weather.weather_final_year then
      @weather.simulation_initial_year = @weather.weather_initial_year
      @weather.weather_initial_year -= 5 
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
