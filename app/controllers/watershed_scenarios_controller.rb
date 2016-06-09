class WatershedScenariosController < ApplicationController
  # GET /watershed_scenarios
  # GET /watershed_scenarios.json
  def index
    @scenarios = Scenario.where(:field_id => 0)
    @watershed_scenarios = WatershedScenario.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watershed_scenarios }
    end
  end

  # GET /watershed_scenarios/1
  # GET /watershed_scenarios/1.json
  def show
    @watershed_scenario = WatershedScenario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @watershed_scenario }
    end
  end

  # GET /watershed_scenarios/new
  # GET /watershed_scenarios/new.json
  def new
    @watershed_scenario = WatershedScenario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watershed_scenario }
    end
  end

  # GET /watershed_scenarios/1/edit
  def edit
    @watershed_scenario = WatershedScenario.find(params[:id])
  end

  # POST /watershed_scenarios
  # POST /watershed_scenarios.json
  def create
    @watershed_scenario = WatershedScenario.new(watershed_scenario_params)

    respond_to do |format|
      if @watershed_scenario.save
        format.html { redirect_to @watershed_scenario, notice: 'Watershed scenario was successfully created.' }
        format.json { render json: @watershed_scenario, status: :created, location: @watershed_scenario }
      else
        format.html { render action: "new" }
        format.json { render json: @watershed_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watershed_scenarios/1
  # PATCH/PUT /watershed_scenarios/1.json
  def update
  afas
    @watershed_scenario = WatershedScenario.find(params[:id])

    respond_to do |format|
      if @watershed_scenario.update_attributes(watershed_scenario_params)
        format.html { redirect_to @watershed_scenario, notice: 'Watershed scenario was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @watershed_scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watershed_scenarios/1
  # DELETE /watershed_scenarios/1.json
  def destroy
    @watershed_scenario = WatershedScenario.find(params[:id])
    @watershed_scenario.destroy

    respond_to do |format|
      format.html { redirect_to watershed_scenarios_url }
      format.json { head :no_content }
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
