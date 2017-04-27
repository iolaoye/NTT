class ApexLayersController < ApplicationController
################################  INDEX  #################################
  # GET /layers
  # GET /layers.json

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Projects', :root_path

  def index
    @project = Project.find(params[:project_id])
    @apex_layers = Layer.where(:soil_id => params[:id])
    @field = Field.find(params[:field_id])
	add_breadcrumb @project.name, project_path(@project)
	add_breadcrumb @field.field_name, project_fields_path(@project)
	add_breadcrumb 'Utility Files'
	add_breadcrumb 'Soils', controller: "apex_soils", action: "index"
	add_breadcrumb 'Layers'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apex_layers }
    end
  end

  # GET /layers/1
  # GET /layers/1.json
  def show
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @apex_layer_id = params[:id]
    @apex_layer = Layer.find(params[:id])
    @location = Location.where(:project_id => params[:project_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apex_layer }
    end
  end

  # GET /layers/new
  # GET /layers/new.json
  def new
    @apex_layer = Layer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apex_layer }
    end
  end

  # GET /layers/1/edit
  def edit
    @apex_layer_id = params[:id]
    @apex_layer = Layer.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @location = Location.where(:project_id => params[:project_id])
	add_breadcrumb @project.name, project_path(@project)
	add_breadcrumb @field.field_name, project_fields_path(@project)
	add_breadcrumb 'Utility Files'
	add_breadcrumb 'Soils', controller: "apex_soils", action: "index"
	add_breadcrumb 'Layers', controller: "apex_layers", action: "index"
  end

  # POST /layers
  # POST /layers.json
  def create
    @apex_layer = Layer.new(layer_params)

    respond_to do |format|
      if @apex_layer.save
        format.html { redirect_to @apex_layer, notice: t('models.layer') + "" + t('notices.created') }
        format.json { render json: @apex_layer, status: :created, location: @apex_layer }
      else
        format.html { render action: "new" }
        format.json { render json: @apex_layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /layers/1
  # PATCH/PUT /layers/1.json
  def update
    @apex_layer = Layer.find(params[:id])
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])

    respond_to do |format|
      if @apex_layer.update_attributes(layer_params)
        format.html { redirect_to project_field_apex_layers_path(:id => @apex_layer.soil_id), notice: t('models.layer') + "" + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apex_layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.json
  def destroy
    @apex_layer = Layer.find(params[:id])
    @apex_layer.destroy

    respond_to do |format|
      format.html { redirect_to apex_layers_path(@apex_layer.soil_id), notice: 'Layer was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def layer_params
      params.require(:layer).permit(:bulk_density, :clay, :depth, :organic_matter, :ph, :sand, :silt, :soil_id, :soil_p,
	  :uw, :fc, :wn, :smb, :cac, :cec, :rok, :cnds, :rsd, :bdd, :psp, :satc )
    end
end
