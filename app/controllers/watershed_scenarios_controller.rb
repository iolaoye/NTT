class WatershedScenariosController < ApplicationController

  # GET /watershed_scenarios
  # GET /watershed_scenarios.json
  def index
    @watershed_scenarios = WatershedScenario.all
    @scenarios = Scenario.where(:field_id => 0)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watershed_scenarios }
    end
  end

  # GET /watershed_scenarios/1
  # GET /watershed_scenarios/1.json
  def show
    session[:watershed_id] = params[:id]
    item = WatershedScenario.where(:field_id => params[:field_id], :scenario_id => params[:scenario_id]).first
    @watershed_name = Watershed.find(params[:id]).name
    @watershed_scenarios = WatershedScenario.where(:watershed_id => params[:id])
    @scenarios = Scenario.where(:field_id => 0)
    render "index"
  end

  # GET /watershed_scenarios/new
  # GET /watershed_scenarios/new.json
  def new
    @watershed_scenarios = WatershedScenario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watershed_scenarios }
    end
  end

  # GET /watershed_scenarios/1/edit
  def edit
    @watershed_scenarios = WatershedScenario.find(params[:id])
  end

  # POST /watershed_scenarios
  # POST /watershed_scenarios.json
  def create
    @watershed_scenarios = WatershedScenario.new(watershed_scenario_params)

    respond_to do |format|
      if @watershed_scenarios.save
        format.html { redirect_to @watershed_scenarios, notice: 'Watershed scenario was successfully created.' }
        format.json { render json: @watershed_scenarios, status: :created, location: @watershed_scenarios }
      else
        flash[:error] = @watershed_scenarios.errors
        format.html { render action: "new" }
        format.json { render json: @watershed_scenarios.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watershed_scenarios/1
  # PATCH/PUT /watershed_scenarios/1.json
  def update
    @watershed_scenarios = WatershedScenario.find(params[:id])

    respond_to do |format|
      if @watershed_scenarios.update_attributes(watershed_scenario_params)
        format.html { redirect_to @watershed_scenarios, notice: 'Watershed scenario was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:error] = @watershed_scenarios.errors
        format.html { render action: "edit" }
        format.json { render json: @watershed_scenarios.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watershed_scenarios/1
  # DELETE /watershed_scenarios/1.json
  def destroy
    @watershed_scenarios = WatershedScenario.find(params[:id])
    if @watershed_scenarios.destroy
      flash[:notice] = t('models.watershed_scenario') + t('notices.deleted')
    end
    redirect_to watershed_scenario_path(session[:watershed_id])
  end

  def new_scenario
    @scenarios = Scenario.where(:field_id => 0)
    @watershed_name = Watershed.find(params[:id]).name
    item = WatershedScenario.where(:field_id => params[:watershed][:field_id], :scenario_id => params[:watershed][:scenario_id], :watershed_id => params[:id]).first
    respond_to do |format|
      if item == nil
        @new_watershed_scenario = WatershedScenario.new
        @new_watershed_scenario.field_id = params[:watershed][:field_id]
        @new_watershed_scenario.scenario_id = params[:watershed][:scenario_id]
        @new_watershed_scenario.watershed_id = params[:id]
        if @new_watershed_scenario.save
          flash[:notice] = 'Watershed scenario was successfully created.'
        else
          flash[:error] = 'That field/scenario combination has already been selected for this watershed. Please choose again.'
        end
        format.html { redirect_to watershed_scenario_path(params[:id]) }
      else
        flash[:error] = 'That field/scenario combination has already been selected for this watershed. Please choose again.'
        format.html { redirect_to watershed_scenario_path(params[:id]) }
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
