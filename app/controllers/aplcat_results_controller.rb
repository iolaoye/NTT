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
      params.require(:aplcat_result).permit(:month_id, :option_id, :calf_aws, :calf_dmi, :calf_gei, :calf_wi, :calf_sme, :calf_ni, :calf_tne, :calf_tnr, :calf_fne,
      :calf_une, :calf_eme, :calf_mme, :rh_aws, :rh_dmi, :rh_gei, :rh_wi, :rh_sme, :rh_ni, :rh_tne, :rh_tnr, :rh_fne, :rh_une, :rh_eme, :rh_mme,
      :fch_aws, :fch_dmi, :fch_gei, :fch_wi, :fch_sme, :fch_ni, :fch_tne, :fch_tnr, :fch_fne, :fch_une, :fch_eme, :fch_mme,
      :cow_aws, :cow_dmi, :cow_gei, :cow_wi, :cow_sme, :cow_ni, :cow_tne, :cow_tnr, :cow_fne, :cow_une, :cow_eme, :cow_mme,
      :bull_aws, :bull_dmi, :bull_gei, :bull_wi, :bull_sme, :bull_ni, :bull_tne, :bull_tnr, :bull_fne, :bull_une, :bull_eme, :bull_mme)
    end

end
