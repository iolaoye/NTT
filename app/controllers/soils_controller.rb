class SoilsController < ApplicationController
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
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(session[:field_id]).field_name

	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soils }
    end
  end
################################  INDEX   #################################
  # GET /soils
  # GET /soils.json
  def index
    @soils = Soil.where(:field_id => session[:field_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soils }
    end
  end

  # GET /soils/1
  # GET /soils/1.json
  def show
    @soil = Soil.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @soil }
    end
  end

  # GET /soils/new
  # GET /soils/new.json
  def new
    @soil = Soil.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @soil }
    end
  end

  # GET /soils/1/edit
  def edit
    @soil = Soil.find(params[:id])
  end

  # POST /soils
  # POST /soils.json
  def create
    @soil = Soil.new(soil_params)
	@soil.field_id = session[:field_id]

    respond_to do |format|
      if @soil.save
        flash[:notice] = t('soil.soil') + " " + @soil.name + " " + t('general.success')
        format.html { redirect_to list_soil_path(session[:field_id]), notice: 'Soil was successfully created.' }
        format.json { render json: @soil, status: :created, location: @soil }
      else
        format.html { render action: "new" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

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
        format.html { redirect_to list_soil_path(session[:field_id]), notice: 'Soil was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soils/1
  # DELETE /soils/1.json
  def destroy
    @soil = Soil.find(params[:id])
    @soil.destroy

    respond_to do |format|
      format.html { redirect_to list_soil_path(@soil.field_id) }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def soil_params
      params.require(:soil).permit(:albedo, :drainage_type, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol ,:ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx, 
	  :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp )
    end
end
