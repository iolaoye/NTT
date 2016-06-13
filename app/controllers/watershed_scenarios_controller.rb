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

    @watershed_scenarios = WatershedScenario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @watershed_scenarios }
    end

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
        format.html { render action: "new" }
        format.json { render json: @watershed_scenarios.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watershed_scenarios/1
  # PATCH/PUT /watershed_scenarios/1.json
  def update
  afas
    @watershed_scenarios = WatershedScenario.find(params[:id])

    respond_to do |format|
      if @watershed_scenarios.update_attributes(watershed_scenario_params)
        format.html { redirect_to @watershed_scenarios, notice: 'Watershed scenario was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @watershed_scenarios.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watershed_scenarios/1
  # DELETE /watershed_scenarios/1.json
  def destroy
    @watershed_scenarios = WatershedScenario.find(params[:id])
    @watershed_scenarios.destroy


    
	redirect_to watershed_scenario_path(session[:watershed_id])
  end


  def new_scenario
    @scenarios = Scenario.where(:field_id => 0)
    @watershed_name = Watershed.find(params[:id]).name
    item = WatershedScenario.where(:field_id => params[:watershed][:field_id], :scenario_id => params[:watershed][:scenario_id]).first
    if item == nil
      @new_watershed_scenario = WatershedScenario.new
      @new_watershed_scenario.field_id = params[:watershed][:field_id]
      @new_watershed_scenario.scenario_id = params[:watershed][:scenario_id]
      @new_watershed_scenario.watershed_id = params[:id]
      @new_watershed_scenario.save
    end
    redirect_to watershed_scenario_path(params[:id])
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def watershed_scenario_params
      params.require(:watershed_scenario).permit(:field_id, :scenario_id, :watershed_id)
    end
end
