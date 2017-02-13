class LayersController < ApplicationController
################################  LAYERS list   #################################
# GET /soils/1
# GET /1/soils.json
  def list
    @layers = Layer.where(:soil_id => params[:id])
	#check if first layer depth is more than 10m. if so new layer is added
	if @layers[0].depth > 3.94 then
		layer = Layer.new
		layer.depth = 3.94
		layer.soil_p = @layers[0].soil_p
		layer.bulk_density = @layers[0].bulk_density
		layer.sand = @layers[0].sand
		layer.silt = @layers[0].silt
		layer.clay = @layers[0].clay
		layer.organic_matter = @layers[0].organic_matter
		layer.ph = @layers[0].ph
		layer.soil_id = @layers[0].soil_id
		layer.uw = @layers[0].uw
		layer.fc = @layers[0].fc
		layer.wn = @layers[0].wn
		layer.smb = @layers[0].smb
		layer.cac = @layers[0].cac
		layer.cec = @layers[0].cec
		layer.rok = @layers[0].rok
		layer.cnds = @layers[0].cnds
		layer.rsd = @layers[0].rsd
		layer.bdd = @layers[0].bdd
		layer.psp = @layers[0].psp
		layer.satc = @layers[0].satc
		layer.save
	end
    @layers = Layer.where(:soil_id => params[:id])
    @soil_name = Soil.find(session[:soil_id]).name[0..20]
    @soil_name += ". . ." unless @soil_name.length < 20
    @project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(session[:field_id]).field_name

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end

################################  INDEX  #################################
# GET /layers
# GET /layers.json
  def index
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @layer }
    end
  end

# GET /layers/1/edit
  def edit
    @layer = Layer.find(params[:id])
  end

# POST /layers
# POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @layer.soil_id = session[:soil_id]
    respond_to do |format|
      if @layer.save
        if params[:add_more] == "Add more" && params[:finish] == nil
          format.html { redirect_to list_layer_path(@layer.soil_id), notice: t('models.layer') + "" + t('notices.created') }
          format.json { render json: @layer, status: :created, location: @layer }
        elsif params[:finish] == "Finish" && params[:add_more] == nil
          format.html { redirect_to list_scenario_path(session[:field_id]), notice: t('models.layer') + "" + t('notices.created') }
          format.json { render json: @layer, status: :created, location: @layer }
        end
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

    respond_to do |format|
      if @layer.update_attributes(layer_params)
        if params[:add_more] == "Save" && params[:finish] == nil
          format.html { redirect_to list_layer_path(@layer.soil_id), notice: t('models.layer') + "" + t('notices.created') }
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
    if @layer.destroy
      flash[:info] = t('models.layer') + "" + t('notices.deleted')
    end
    respond_to do |format|
      format.html { redirect_to list_layer_path(@layer.soil_id) }
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
