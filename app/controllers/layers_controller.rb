class LayersController < ApplicationController

################################  LAYERS list   #################################
# GET /soils/1
# GET /1/soils.json
  def list
    layer_first = Layer.where(:soil_id => params[:id]).first
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
    @soil = Soil.find(params[:soil_id])
    @layers = Layer.where(:soil_id => params[:soil_id])
	  add_breadcrumb t('menu.soils'), project_field_soils_path(@project, @field)
	  add_breadcrumb t('menu.layers') 
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
    @soil = Soil.find(params[:soil_id])
	  add_breadcrumb t('menu.soils'), project_field_soils_path(@project, @field)
	  add_breadcrumb t('menu.layers'), project_field_soil_layers_path(@project.id, @field.id, @soil.id)
	  add_breadcrumb t('layer.new_layer')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @layer }
    end
  end

# GET /layers/1/edit
  def edit
    @soil = Soil.find(params[:soil_id])
    @layer = Layer.find(params[:id])
    add_breadcrumb t('menu.soils'), project_field_soils_path(@project, @field)
    add_breadcrumb t('menu.layers'), project_field_soil_layers_path(@project, @field, @soil)
    add_breadcrumb t('general.editing') + " " +  t('menu.layers')
  end

# POST /layers
# POST /layers.json
  def create
    @layer = Layer.new(layer_params)
    @layer.soil_id = params[:soil_id]
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
    @soil = Soil.find(params[:soil_id])
    respond_to do |format|
      if layer_params
        soil_test = SoilTest.find(params[:layer][:soil_test_id])
        if params[:layer][:soil_p_initial].blank? 
          params[:layer][:soil_p] = 0 
        elsif !params[:layer][:soil_p_initial].blank?
          if soil_test.id == 7 then
            params[:layer][:soil_p] = soil_test.factor2 * params[:layer][:soil_p_initial].to_f - soil_test.factor1 * params[:layer][:ph].to_f - 32.757 * (params[:layer][:soil_p_initial].to_f / params[:layer][:soil_aluminum].to_f) + 90.73
          else
            params[:layer][:soil_p] = soil_test.factor1 + soil_test.factor2 * params[:layer][:soil_p_initial].to_f
          end
          if params[:layer][:soil_p] < 0 then params[:layer][:soil_p] = 0 end
        end
      end
      if @layer.update_attributes(layer_params)
          format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil), notice: t('models.layer') + "" + t('notices.updated') }
          format.json { render json: @layer, status: :created, location: @layer }
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
    @soil = Soil.find(params[:soil_id])
    if @layer.destroy
      respond_to do |format|
        format.html { redirect_to project_field_soil_layers_path(@project, @field, @soil), notice: t('models.layer') + "" + t('notices.deleted') }
        format.json { head :no_content }
      end
    end
  end

  private

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def layer_params
    params.require(:layer).permit(:bulk_density, :clay, :depth, :organic_matter, :ph, :sand, :silt, :soil_id, :soil_p,
                                  :uw, :fc, :wn, :smb, :cac, :cec, :rok, :cnds, :rsd, :bdd, :psp, :satc, :id, :soil_test_id,
                                  :soil_p_initial, :soil_aluminum, :created_at, :updated_at)
  end
end
