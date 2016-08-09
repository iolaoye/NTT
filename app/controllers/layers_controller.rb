class LayersController < ApplicationController
################################  LAYERS list   #################################
  # GET /soils/1
  # GET /1/soils.json
  def list
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
        format.html { redirect_to list_layer_path(@layer.soil_id), notice: 'Layer was successfully created.' }
        format.json { render json: @layer, status: :created, location: @layer }
      else
        format.html { render action: "new" }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /layers/1
  # PATCH/PUT /layers/1.json
  def update
    @layer = Layer.find(params[:id])

    respond_to do |format|
      if @layer.update_attributes(layer_params)
        format.html { redirect_to list_layer_path(@layer.soil_id), notice: 'Layer was successfully updated.' }
        format.json { head :no_content }
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
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to list_layer_path(@layer.soil_id), notice: 'Layer was successfully deleted.' }
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
