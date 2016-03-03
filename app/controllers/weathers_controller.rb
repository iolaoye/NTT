class WeathersController < ApplicationController
################################  INDEX   #################################
  # GET /weathers
  # GET /weathers.json
  def index
	index
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
	@weather = Weather.find_by_field_id(params[:id])
	if !(@weather == :nil) # no empty array
	  @way = Way.find(@weather.way_id)
	  respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @weather }
      end
    end
  end

  # GET /weathers/new
  # GET /weathers/new.json
  def new
    @weather = Weather.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @weather }
    end
  end

  # GET /weathers/1/edit
  def edit
  edit
    @weather = Weather.find(params[:id])
  end

  # POST /weathers
  # POST /weathers.json
  def create
  create
    @weather = Weather.new(weather_params)

    respond_to do |format|
      if @weather.save
        format.html { redirect_to @weather, notice: 'Weather was successfully created.' }
        format.json { render json: @weather, status: :created, location: @weather }
      else
        format.html { render action: "new" }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weathers/1
  # PATCH/PUT /weathers/1.json
  def update
    @weather = Weather.find(params[:id])
    respond_to do |format|
      if @weather.update_attributes(weather_params)
        format.html { redirect_to @weather, notice: 'Weather was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
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

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def weather_params
      params.require(:weather).permit(:field_id, :latitude, :longitude, :simulation_final_year, :simulation_initial_year, :station_id, :station_way, :way_id)
    end
end
