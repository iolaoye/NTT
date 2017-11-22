class WatershedScenariosController < ApplicationController
################################ INDEX #################################
  # GET /watershed_scenarios
  # GET /watershed_scenarios.json
  def index
    @watershed = Watershed.find(params[:watershed_id])
    @watershed_scenarios = WatershedScenario.where(:watershed_id => @watershed.id)
    @scenarios = Scenario.where(:field_id => 0)
	#@project = Project.find(params[:project_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watershed_scenarios }
    end
  end

################################ SHOW #################################
  # GET /watershed_scenarios/1
  # GET /watershed_scenarios/1.json
  def show
    item = WatershedScenario.where(:field_id => params[:field_id], :scenario_id => params[:scenario_id]).first
    @watershed_name = Watershed.find(params[:id]).name
    @watershed_scenarios = WatershedScenario.where(:watershed_id => params[:id])
    @scenarios = Scenario.where(:field_id => 0)
    render "index"
  end

  # GET /watershed_scenarios/new
  # GET /watershed_scenarios/new.json
  def new
	#@project = Project.find(params[:watershed][:project_id])
	new_scenario()
  end

  # GET /watershed_scenarios/1/edit
  def edit
    @watershed_scenarios = WatershedScenario.find(params[:id])
  end

  #********************** Create a new field/scenario to add to the watershed selected ***********************
  # POST /watershed_scenarios
  # POST /watershed_scenarios.json
  def create
    #@project = Project.find(params[:project_id])
    @scenarios = Scenario.where(:field_id => 0)
    watershed = Watershed.find(params[:watershed_id])
    @watershed_name = watershed.name
    item = WatershedScenario.where(:field_id => params[:field][:id], :scenario_id => params[:scenario][:id], :watershed_id => params[:watershed_id]).first
    respond_to do |format|
      if item == nil
        @new_watershed_scenario = WatershedScenario.new
        @new_watershed_scenario.field_id = params[:field][:id]
        @new_watershed_scenario.scenario_id = params[:scenario][:id]
        @new_watershed_scenario.watershed_id = params[:watershed_id]
        if @new_watershed_scenario.save
          format.html { redirect_to project_watershed_watershed_scenarios_path(@project, watershed ), notice: t('models.watershed_scenario') + t('notices.created') }
        else
          format.html { redirect_to project_watershed_watershed_scenarios_path(@project, watershed), notice: @new_watershed_scenario.errors }
        end
      else
        flash[:info] = t('watershed_scenario.already_selected')
		format.html { redirect_to project_watershed_watershed_scenarios_path(@project, watershed)}
      end
    end
  end

  #********************** Update ***********************
  # PATCH/PUT /watershed_scenarios/1
  # PATCH/PUT /watershed_scenarios/1.json
  def update
    @watershed_scenarios = WatershedScenario.find(params[:id])

    respond_to do |format|
      if @watershed_scenarios.update_attributes(watershed_scenario_params)
        format.html { redirect_to watershed_scenarios_path, notice: t('models.watershed_scenario') + "" + t('notices.updated') }
        format.json { head :no_content }
      else
        flash[:error] = @watershed_scenarios.errors
        format.html { render action: "edit" }
        format.json { render json: @watershed_scenarios.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################# DELETE ################################ 
  # DELETE /watershed_scenarios/1
  # DELETE /watershed_scenarios/1.json
  def destroy
    @watershed_scenario = WatershedScenario.find(params[:id])
    if @watershed_scenario.destroy
	  redirect_to project_watershed_watershed_scenarios_path(params[:project_id], params[:watershed_id]), notice: t('models.watershed_scenario') + t('notices.deleted')
    end
  end

################################ NEW SCENARIO - ADD NEW FIELD/SCENARIO TO THE LIST OF THE SELECTED WATERSHED #################################
  def new_scenario
    @scenarios = Scenario.where(:field_id => 0)
	watershed = Watershed.find(params[:watershed_id])
    @watershed_name = watershed.name
    item = WatershedScenario.where(:field_id => params[:watershed][:field_id], :scenario_id => params[:watershed][:scenario_id], :watershed_id => params[:id]).first
    respond_to do |format|
      if item == nil
        @new_watershed_scenario = WatershedScenario.new
        @new_watershed_scenario.field_id = params[:watershed][:field_id]
        @new_watershed_scenario.scenario_id = params[:watershed][:scenario_id]
        @new_watershed_scenario.watershed_id = params[:watershed_id]
        if @new_watershed_scenario.save
          format.html { redirect_to watershed_watershed_scenarios_path(watershed, :project_id => @project.id), notice: t('models.watershed_scenario') + t('notices.created') }
        else
          format.html { redirect_to watershed_watershed_scenarios_path(watershed, :project_id => @project.id), notice: @new_watershed_scenario.errors }
        end
      else
        format.html { redirect_to watershed_watershed_scenarios_path(watershed, :project_id => @project.id), notice: 'That field/scenario combination has already been selected for this watershed. Please choose again.' }
      end
    end
  end


  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def watershed_scenario_params
      params.require(:watershed_scenario).permit(:field_id, :scenario_id, :watershed_id)
    end
end
