class AplcatParametersController < ApplicationController
  # GET /aplcat_parameters
  # GET /aplcat_parameters.json
  def index
    @aplcat_parameters = AplcatParameter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @aplcat_parameters }
    end
  end

  # GET /aplcat_parameters/1
  # GET /aplcat_parameters/1.json
  def show
    @aplcat_parameter = AplcatParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @aplcat_parameter }
    end
  end

  # GET /aplcat_parameters/new
  # GET /aplcat_parameters/new.json
  def new
    @aplcat_parameter = AplcatParameter.new
	@aplcat_parameter.scenario_id = params[:scenario_id]
	@aplcat_parameter.save
    #respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @aplcat_parameter }
    #end
  end

  # GET /aplcat_parameters/1/edit
  def edit
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  	if params[:id] == nil then
		@type = 1
	else
		@type = params[:id].to_i
	end
    @aplcat_parameter = AplcatParameter.find_by_scenario_id(params[:scenario_id])
	if @aplcat_parameter == nil then
		new()
	end
  end

  # POST /aplcat_parameters
  # POST /aplcat_parameters.json
  def create
    @aplcat_parameter = AplcatParameter.new(aplcat_parameter_params)
	@aplcat_parameter.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @aplcat_parameter.save
        format.html { redirect_to edit_aplcat_parameter_path(params[:scenario_id]), notice: 'Aplcat parameter was successfully created.' }
        format.json { render json: @aplcat_parameter, status: :created, location: @aplcat_parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @aplcat_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aplcat_parameters/1
  # PATCH/PUT /aplcat_parameters/1.json
  def update
    @type = params[:type]
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
    @aplcat_parameter = AplcatParameter.find(params[:id])
    respond_to do |format|
      if @aplcat_parameter.update_attributes(aplcat_parameter_params)
        format.html { redirect_to edit_project_field_scenario_aplcat_parameter_path(@project, @field, @scenario, @type), notice: 'Aplcat parameter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @aplcat_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aplcat_parameters/1
  # DELETE /aplcat_parameters/1.json
  def destroy
    @aplcat_parameter = AplcatParameter.find(params[:id])
    @aplcat_parameter.destroy

    respond_to do |format|
      format.html { redirect_to aplcat_parameters_url }
      format.json { head :no_content }
    end
  end

  def download
	  download_aplcat_files()
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def aplcat_parameter_params
      params.require(:aplcat_parameter).permit(:abwc, :abwh, :abwmb, :adwgbc, :noc, :nomb, :norh, :prh, :adwgbh, :mrga, :jdcc, :gpc,
				 :tpwg, :csefa , :srop, :bwoc, :jdbs, :dmd, :dmi, :napanr, :napaip, :mpsm, :splm, :pmme, :rhaeba, :toaboba,
				 :vsim, :foue, :ash, :mmppfm, :cfmms, :fnemimms, :effn2ofmms, :dwawfga, :dwawflc, :dwawfmb, :pgu, :ada, :ape,
				 :platc, :pctbb, :ptdife, :tnggbc, :prb)
    end
end
