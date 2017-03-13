class LayersController < ApplicationController
################################  LAYERS list   #################################
# GET /soils/1
# GET /1/soils.json
  def list
    layer_first = Layer.where(:soil_id => params[:id]).first
	#check if first layer depth is more than 10m. if so new layer is added
	#if layer_first != nil && layer_first.depth > 3.94 then
		#layer = Layer.new
		#layer.depth = 3.94
		#layer.soil_p = layer_first.soil_p
		#layer.bulk_density = layer_first.bulk_density
		#layer.sand = layer_first.sand
		#layer.silt = layer_first.silt
		#layer.clay = layer_first.clay
		#layer.organic_matter = layer_first.organic_matter
		#layer.ph = layer_first.ph
		#layer.soil_id = layer_first.soil_id
		#layer.uw = layer_first.uw
		#layer.fc = layer_first.fc
		#layer.wn = layer_first.wn
		#layer.smb = layer_first.smb
		#layer.cac = layer_first.cac
		#layer.cec = layer_first.cec
		#layer.rok = layer_first.rok
		#layer.cnds = layer_first.cnds
		#layer.rsd = layer_first.rsd
		#layer.bdd = layer_first.bdd
		#layer.psp = layer_first.psp
		#layer.satc = layer_first.satc
		#if layer.save 
		#end
	#end
    @layers = Layer.where(:soil_id => params[:id])
    @soil = Soil.find(session[:soil_id])
    @soil_name = Soil.find(session[:soil_id]).name[0..20]
    @soil_name += ". . ." unless @soil_name.length < 20
    @project_name = Project.find(params[:project_id]).name
    @field_name = Field.find(params[:field_id]).field_name

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end

################################  INDEX  #################################
# GET /layers
# GET /layers.json
  def index
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])
    @layers = Layer.where(:soil_id => params[:soil_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @layers }
    end
  end

# GET /layers/1
# GET /layers/1.json
  def show

    @layer = Layer.where(:soil_id => params[:id])
    @layer = Layer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @layer }
    end
  end

# GET /layers/new
# GET /layers/new.json
  def new
    @layer = Layer.new
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @layer }
    end
  end

# GET /layers/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])
    @layer = Layer.find(params[:id])
  end

# POST /layers
# POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @layer.soil_id = session[:soil_id]
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])
    respond_to do |format|
      if @layer.save
          format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil), notice: t('models.layer') + "" + t('notices.created') }
          format.json { render json: @layer, status: :created, location: @layer }
      else
        format.html { render action: "new" }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

################################  update  #################################
# PATCH/PUT /layers/1
# PATCH/PUT /layers/1.json
  def update
    @layer = Layer.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])

    respond_to do |format|
      if @layer.update_attributes(layer_params)
        if params[:add_more] == "Save" && params[:finish] == nil
          format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil), notice: t('models.layer') + "" + t('notices.created') }
          format.json { render json: @layer, status: :created, location: @layer }
        elsif params[:finish] == "Finish" && params[:add_more] == nil
          format.html { redirect_to list_scenario_path(session[:field_id]), notice: t('models.layer') + "" + t('notices.created') }
          format.json { render json: @layer, status: :created, location: @layer }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /layers/1
# DELETE /layers/1.json
  def destroy
    @layer = Layer.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @soil = Soil.find(params[:soil_id])
    if @layer.destroy
      flash[:info] = t('models.layer') + "" + t('notices.deleted')
    end
    respond_to do |format|
      format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil) }
      format.json { head :no_content }
    end
  end

  private

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def layer_params
    params.require(:layer).permit(:bulk_density, :clay, :depth, :organic_matter, :ph, :sand, :silt, :soil_id, :soil_p,
                                  :uw, :fc, :wn, :smb, :cac, :cec, :rok, :cnds, :rsd, :bdd, :psp, :satc, :id, :created_at, :updated_at)
  end
end
