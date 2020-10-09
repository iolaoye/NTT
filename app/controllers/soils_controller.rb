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
    session[:field_id] = @field.id
    msg = "OK"
    flash[:info] = nil
    if @project.location.state_id > 0
      if @field.updated == true then
        msg = request_soils()
        if msg != "OK" then flash.now[:info] = msg end
      end
    end
    @soils = @field.soils
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
    #soil_id = @field.soils.where(:selected => true).last.id
    respond_to do |format|
      if @soil.update_attributes(soil_params)
        #if soil_id == @soil.id then
          #Subarea.where(:soil_id => @soil.id).update_all(:wsa => @soil.percentage * wsa_conversion, :chl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :rchl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :slp => @soil.slope / 100)
        #else
        Subarea.where(:soil_id => @soil.id).update_all(:wsa => @soil.percentage * wsa_conversion, :chl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :rchl => Math::sqrt(@soil.percentage * wsa_conversion * 0.01), :slp => @soil.slope / 100)
        #end
        #then look for scenario with land leveling bmp and adjust slope.
        @soil.subareas.each do |sub1|
           ll_bmp = sub1.scenario.bmps.find_by_bmpsublist_id(16)  #find if there is a land leveling bmp for this field
          if ll_bmp != nil then
            sub1.slp = sub1.slp * (100 - ll_bmp.slope_reduction) / 100
            sub1.save
          end
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
                                 :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp, :tile_depth)
  end
end
