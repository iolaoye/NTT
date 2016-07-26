class WatershedsController < ApplicationController
  include SimulationsHelper 
  ################################  watershed list   #################################
  # GET /watersheds/1
  # GET /1/watersheds.json
  def list
	@scenarios = Scenario.where(:field_id => 0)  # make @scnearions empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => params[:id])
	@project_name = Project.find(session[:project_id]).name

	respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @watersheds }
    end
  end
  
  # GET /watersheds
  # GET /watersheds.json
  def index
    @watersheds = Watershed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watersheds }
    end
  end

  ################################  SHOW used for simulation   #################################
  # GET /watersheds/1
  # GET /watersheds/1.json
  def show
  	@dtNow1  = Time.now.to_s
	dir_name = APEX + "/APEX" + session[:session_id]

	watershed_scenarios = WatershedScenario.where(:watershed_id => params[:id])
	copy_folder()
	create_control_file()
	create_parameter_file()
	create_site_file(Field.find_by_location_id(session[:location_id]).id)
	create_wind_wp1_files(dir_name)
	@last_soil = 0
	@last_soil_sub = 0
	@last_subarea = 0
	@soil_list = Array.new
	@opcs_list_file = Array.new
	@opers = Array.new
	@depth_ant = Array.new
	@change_till_depth = Array.new
	@fem_list = Array.new
	@nutrients_structure = Struct.new(:code, :no3, :po4, :orgn, :orgp)
	@current_nutrients = Array.new
	@new_fert_line = Array.new
	@subarea_file = Array.new
	@soil_number = 0
	j=0
	watershed_scenarios.each do |p|
		@scenario = Scenario.find(p.scenario_id)
		create_weather_file(dir_name, p.field_id)
		@soils = Soil.where(:field_id => p.field_id).where(:selected => true)
		create_soils()
		create_subareas(j+1)
		j+=1
	end # end watershed_scenarios.each
	print_array_to_file(@soil_list, "soil.dat")
	print_array_to_file(@opcs_list_file, "OPCS.dat")
	run_scenario()


	@scenarios = Scenario.where(:field_id => 0)  # make @scnearions empty to start the list page in watershed
	@watersheds = Watershed.where(:location_id => session[:location_id])
	@project_name = Project.find(session[:project_id]).name

	render "list"
  end

  # GET /watersheds/new
  # GET /watersheds/new.json
  def new
    @watershed = Watershed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watershed }
    end
  end

  # GET /watersheds/1/edit
  def edit
    @watershed = Watershed.find(params[:id])
  end

  # POST /watersheds
  # POST /watersheds.json
  def create
    @watershed = Watershed.new(watershed_params)
    @watershed.location_id = session[:location_id]

    respond_to do |format|
      if @watershed.save
        format.html { redirect_to @watershed, notice: 'Watershed was successfully created.' }
        format.json { render json: @watershed, status: :created, location: @watershed }
      else
        format.html { render action: "new" }
        format.json { render json: @watershed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watersheds/1
  # PATCH/PUT /watersheds/1.json
  def update
    @watershed = Watershed.find(params[:id])

    respond_to do |format|
      if @watershed.update_attributes(watershed_params)
        format.html { redirect_to @watershed, notice: 'Watershed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @watershed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watersheds/1
  # DELETE /watersheds/1.json
  def destroy
    #oo
    @watershed = Watershed.find(params[:id])
    @watershed.destroy

    respond_to do |format|
      format.html { redirect_to list_watershed_path(session[:location_id]) }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def watershed_params
      params.require(:watershed).permit(:field_id, :name, :scenario_id, :location_id)
    end
		
end
