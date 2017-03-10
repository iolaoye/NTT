class WatershedsController < ApplicationController
  include SimulationsHelper
  ################################  watershed list   #################################
  # GET /watersheds/1
  # GET /1/watersheds.json
  def list
    @scenarios = Scenario.where(:field_id => 0) # make @scnearions empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
    @project = Project.find(params[:project_id])
    @field = Field.find(session[:field_id])
    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @watersheds }
    end
  end

  # GET /watersheds
  # GET /watersheds.json
  def index
    @scenarios = Scenario.where(:field_id => 0) # make @scnearions empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
    @project = Project.find(params[:project_id])
    @field = Field.find(session[:field_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watersheds }
    end
  end

  ################################  SHOW used for simulation   #################################
  # GET /watersheds/1
  # GET /watersheds/1.json
  def show
    @watershed_id = params[:id]
    @dtNow1 = Time.now.to_s
    dir_name = APEX + "/APEX" + session[:session_id]

    watershed_scenarios = WatershedScenario.where(:watershed_id => params[:id])
    msg = send_file_to_APEX("APEX", session[:session_id]) #this operation will create APEX folder from APEX1 folder
    if msg.eql?("OK") then
      msg = create_control_file()
    end
    if msg.eql?("OK") then
      msg = create_parameter_file()
    end
    if msg.eql?("OK") then
      msg = create_site_file(Field.find_by_location_id(session[:location_id]).id)
    end
    if msg.eql?("OK") then
      msg = create_wind_wp1_files(dir_name)
    end
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
      session[:scenario_id] = p.scenario_id
      session[:field_id] = p.field_id
      if msg.eql?("OK") then
        msg = create_weather_file(dir_name, p.field_id)
      end
      @soils = Soil.where(:field_id => p.field_id).where(:selected => true)
      if msg.eql?("OK") then
        msg = create_soils()
      end
      if msg.eql?("OK") then
        msg = send_file_to_APEX(@soil_list, "soil.dat")
      end
      if msg.eql?("OK") then
        msg = create_subareas(j+1)
      end
      if msg.eql?("OK") then
        msg = send_file_to_APEX(@opcs_list_file, "opcs.dat")
      end
      j+=1
    end # end watershed_scenarios.each
    print_array_to_file(@soil_list, "soil.dat")
    print_array_to_file(@opcs_list_file, "OPCS.dat")
    if msg.eql?("OK") then
      msg = send_file_to_APEX("RUN", session[:session])
    end #this operation will run a simulation
    read_apex_results(msg)
    if @scenario != nil
      @scenario.last_simulation = Time.now
      @scenario.save
    else

    end

    @scenarios = Scenario.where(:field_id => 0) # make @scenarios empty to start the list page in watershed
    @watersheds = Watershed.where(:location_id => session[:location_id])
    @project_name = Project.find(session[:project_id]).name

    render "list"
  end

  ################################ NEW #################################
  # GET /watersheds/new
  # GET /watersheds/new.json
  def new
    @watershed = Watershed.new
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watershed }
    end
  end

  ################################ NEW #################################
  # GET /watersheds/1/edit
  def edit
    @watershed = Watershed.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  ################################ CREATE #################################
  # POST /watersheds
  # POST /watersheds.json
  def create
    @watershed = Watershed.new(watershed_params)
    @watershed.location_id = session[:location_id]
    @project = Project.find(params[:project_id])
    respond_to do |format|
      if @watershed.save
        session[:watershed_id] = @watershed.id
        format.html { redirect_to watershed_scenario_path(session[:watershed_id]), notice: t('watershed.watershed') + " " + t('general.created') }
        format.json { render json: @watershed, status: :created, location: @watershed }
      else
        format.html { render action: "new" }
        format.json { render json: @watershed.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################ UPDATE #################################
  # PATCH/PUT /watersheds/1
  # PATCH/PUT /watersheds/1.json
  def update
    @watershed = Watershed.find(params[:id])
	@project = Project.find(params[:project_id])

    respond_to do |format|
      if @watershed.update_attributes(watershed_params)
        format.html { redirect_to watersheds_path(:project_id => @project.id), notice: t('watershed.watershed') + " " + t('general.updated') }
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
    @watershed = Watershed.find(params[:id])
	project_id = Location.find(Watershed.find(params[:id]).location_id).project_id

    if @watershed.destroy
      flash[:notice] = t('models.watershed') + " " + @watershed.name + t('notices.deleted')
    end
	
    respond_to do |format|
      format.html { redirect_to watersheds_path(:project_id => project_id) }
      format.json { head :no_content }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def watershed_params
    params.require(:watershed).permit(:field_id, :name, :scenario_id, :location_id, :id, :created_at, :updated_at)
  end

end
