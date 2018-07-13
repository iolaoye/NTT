class AplcatResultsController < ApplicationController
  before_filter :set_params



  def set_params
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  end



  def index
    @aplcat_results = AplcatResult.where(:scenario_id => params[:scenario_id])

	add_breadcrumb 'Aplcat'
	add_breadcrumb 'Aplcat Result'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @aplcat_results }
    end
  end



  def show
    @aplcat_result = AplcatResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @aplcat_result }
    end
  end



  def new
    @aplcat_result = AplcatResult.new
  end



  def edit
    @aplcat_result = AplcatResult.find(params[:id])
  end



  def create
    @aplcat_result = AplcatResult.new(aplcat_result_params)
	@aplcat_result.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @aplcat_result.save
        format.html { redirect_to project_field_scenario_aplcat_results_path(@project, @field, @scenario), notice: 'Aplcat Result was successfully created.' }
        format.json { render json: @aplcat_result, status: :created, location: @aplcat_result }
      else
        format.html { render action: "new" }
        format.json { render json: @aplcat_result.errors, status: :unprocessable_entity }
      end
    end
  end



  def update
    @aplcat_result = AplcatResult.find(params[:id])

    respond_to do |format|
      if @aplcat_result.update_attributes(aplcat_result_params)
        format.html { redirect_to project_field_scenario_aplcat_results_path(@project, @field, @scenario), notice: 'Aplcat Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @aplcat_result.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @aplcat_result = AplcatResult.find(params[:id])
    @aplcat_result.destroy

    respond_to do |format|
      format.html { redirect_to aplcat_result_url }
      format.json { head :no_content }
    end
  end



  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def aplcat_result_params
      params.require(:aplcat_result).permit(:month_id, :option_id)
    end

end
