class SoilsController < ApplicationController
  include ScenariosHelper

  # GET /locations
  # GET /locations.json
  def soil_layers
    session[:soil_id] = params[:id]
    redirect_to list_layer_path(params[:id])
  end

################################  SOILS list   #################################
# GET /soils/1
# GET /1/soils.json
  def list
    @soils = Soil.where(:field_id => params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soils }
    end
  end

################################  INDEX   #################################
# GET /soils
# GET /soils.json
  def index
    msg = ""
    if @field.updated == true then
      msg = request_soils()
      flash[:info] = msg
    end
    @soils = Soil.where(:field_id => params[:field_id])
    add_breadcrumb t('menu.soils')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soils }
    end
  end
################################  SHOW  #################################
# GET /soils/1
# GET /soils/1.json
  def show
    @soil = Soil.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @soil }
    end
  end

################################  NEW  #################################
# GET /soils/new
# GET /soils/new.json
  def new
    @soil = Soil.new
    add_breadcrumb t('menu.soils')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @soil }
    end
  end

################################  EDIT   #################################
# GET /soils/1/edit
  def edit
    @soil = Soil.find(params[:id])
    add_breadcrumb t('menu.soils'), project_field_soils_path(@project, @field)
  	add_breadcrumb t('general.editing') + " " + t('menu.soils')
  end

################################  CREATE   #################################
# POST /soils
# POST /soils.json
  def create
    @soil = Soil.new(soil_params)
    @soil.field_id = @field.id

    respond_to do |format|
      if @soil.save
        session[:soil_id] = @soil.id
        format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil), notice: t('soil.soil') + " " + @soil.name + " " + t('general.success') }
        format.json { render json: @soil, status: :created, location: @soil }
      else
        format.html { render action: "new" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
# PATCH/PUT /soils/1
# PATCH/PUT /soils/1.json
  def update
    @soil = Soil.find(params[:id])
    #the wsa in subareas should be updated if % was updated as well as chl and rchl
    wsa_conversion = Field.find(@soil.field_id).field_area / 100 * AC_TO_HA
    soil_id = Soil.where(:selected => true).last.id
    respond_to do |format|
      if @soil.update_attributes(soil_params)
        if soil_id == @soil.id then
          Subarea.where(:soil_id => @soil.id).update_all(:wsa => @soil.percentage * wsa_conversion, :chl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :rchl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01) * 0.9, :slp => @soil.slope / 100)
        else
          Subarea.where(:soil_id => @soil.id).update_all(:wsa => @soil.percentage * wsa_conversion, :chl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :rchl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :slp => @soil.slope / 100)
        end
        session[:soil_id] = @soil.id
        format.html { redirect_to project_field_soils_path(@project, @field), notice: t('models.soil') + " " + @soil.name + " " + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

################################  DELETE  #################################
# DELETE /soils/1
# DELETE /soils/1.json
  def destroy
    @soil = Soil.find(params[:id])
    if @soil.destroy
		respond_to do |format|
		  format.html { redirect_to project_field_soils_path(@project, @field), notice: t('models.soil') + " " + @soil.name + t('notices.deleted') }
		  format.json { head :no_content }
		end
    end
  end

################################  DELETE  #################################
# DELETE /soils/1
# DELETE /soils/1.json
  def save_soils
  	add_breadcrumb 'Soils'
  	for i in 0..(@field.soils.count - 1)
  		layer = @field.soils[i].layers[0]
  		layer.organic_matter = params[:om][i]
  		layer.save
  	end		# end soils.each
  	@soils = Soil.where(:field_id => params[:field_id])
  	render "index"
  end		# end method

  private

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def soil_params
    params.require(:soil).permit(:albedo, :drainage_id, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol, :ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx,
                                 :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp)
  end

  def request_soils()
    debugger
    uri = URI(URL_NTT)
    res = Net::HTTP.post_form(uri, "data" => "Soils", "file" => "Soils", "folder" => session[:session_id], "rails" => "yes", "parm" => State.find(@project.location.state_id).state_name, "site" => County.find(@project.location.county_id).county_state_code, "wth" => @field.coordinates, "rg" => "yes")
    if !res.body.include?("error") then
      msg = "OK"
      msg = create_soils(YAML.load(res.body))
      return msg
    else
      return res.body
    end
  end

  ###################################### create_soil ######################################
  ## Create soils receiving from map for each field.
  def create_soils(data)
    msg = "OK"
    debugger
    #delete all of the soils for this field
    soils1 = Soil.where(:field_id => @field.id)
    soils1.destroy_all #will delete Subareas and SoilOperations linked to these soils
    total_percentage = 0

    data.each do |soil|
      debugger
      #todo check for erros to soils level as well as layers level.
    #for j in 1..params["field#{i}soils"].to_i
      if soil[0] == "soils" then
        next
      end #
      debugger
      @soil = @field.soils.new
      @soil.key =  soil[1]["mukey"]
      @soil.symbol = soil[1]["musym"]
      @soil.group = soil[1]["hydgrpdcd"]
      @soil.name = soil[1]["muname"]
      @soil.albedo = soil[1]["albedo"]
      @soil.slope = soil[1]["slope"]
      if @soil.slope == 0 then
        @soil.slope = 0.01
        msg = "Unable to calculate slope - Please modify them accordingly."
      end
      @soil.percentage = soil[1]["pct"]
      @soil.percentage = @soil.percentage.round(2)
      @soil.drainage_id = soil[1]["drain"]
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
        if !soil[0] != "error" then
          create_layers(soil[1])
        end
      else
        msg = "Soils was not saved " + @soil.name
      end
    end #end for create_soils
    soils = Soil.where(:field_id => @field.id).order(percentage: :desc)

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
    @field.field_average_slope = @field.soils.average(:slope)
    @field.updated = false
    @field.save
    return msg
  end

  ###################################### create_soil layers ######################################
  ## Create layers receiving from map for each soil.
  def create_layers(layers)
    #for l in 1..params["field#{i}soil#{j}layers"].to_i
    layers.each do |l|
      if !l[0].include?("layer") then
        next
      end
      layer = @soil.layers.new
      layer.sand = l[1]["sand"]
      layer.silt = l[1]["silt"]
      layer.clay = l[1]["clay"]
      layer.bulk_density = l[1]["bd"]
      layer.organic_matter = l[1]["om"]
      layer.ph = l[1]["ph"]
      layer.depth = l[1]["depth"]
      layer.depth /= IN_TO_CM
      layer.depth = layer.depth.round(2)
      layer.cec = l[1]["cec"]
      layer.soil_p = 0
      if layer.save then
        saved = 1
      else
        saved = 0
      end
    end #end for create_layers
  end

end
