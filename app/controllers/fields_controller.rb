class FieldsController < ApplicationController
  # GET /locations
  # GET /locations.json
  def field_scenarios
    session[:field_id] = params[:id]
    redirect_to list_scenario_path	
  end
################################  scenarios list   #################################
  # GET /locations
  # GET /locations.json
  def field_soils
    session[:field_id] = params[:id]
    redirect_to list_soil_path(params[:id])	
  end
################################  soils list   #################################
  # GET /fields/1
  # GET /1/fields.json
  def list
    @fields = Field.where(:location_id => params[:id])
	@project_name = Project.find(session[:project_id]).name
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

	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end
################################  SHOW   #################################
  def soils 
    @soils = Soil.where(:field_id => params[:id])

    respond_to do |format|
      #format.html # index.html.erb
	  redirect_to @soils
      format.json { render json: @soils}
    end
  end

################################  SHOW   #################################
  # GET /fields/1
  # GET /fields/1.json
  def show
    session[:field_id] = params[:id]

    respond_to do |format|
      format.html { redirect_to weather_path }
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

  # GET /fields/1/edit
  def edit
    @field = Field.find(params[:id])
  end

  # POST /fields
  # POST /fields.json
  def create
    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        format.html { redirect_to @field, notice: 'Field was successfully created.' }
        format.json { render json: @field, status: :created, location: @field }
      else
        format.html { render action: "new" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fields/1
  # PATCH/PUT /fields/1.json
  def update
    @field = Field.find(params[:id])

    respond_to do |format|
      if @field.update_attributes(field_params)
        format.html { redirect_to location_fields_location_path(session[:location_id]), notice: 'Field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fields/1
  # DELETE /fields/1.json
  def destroy
    @field = Field.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to fields_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def field_params
      params.require(:field).permit(:field_area, :field_average_slope, :field_name, :field_type, :location_id)
    end
end
