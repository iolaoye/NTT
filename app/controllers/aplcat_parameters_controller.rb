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
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @aplcat_parameter }
    end
  end

  # GET /aplcat_parameters/1/edit
  def edit
  	if params[:type] == nil then
		@type = 1
	else
		@type = params[:type].to_i
	end
    @aplcat_parameter = AplcatParameter.find_by_scenario_id(params[:id])
	if @aplcat_parameter == nil then
		new()
	end
  end

  # POST /aplcat_parameters
  # POST /aplcat_parameters.json
  def create
    @aplcat_parameter = AplcatParameter.new(aplcat_parameter_params)
	@aplcat_parameter.scenario_id = session[:scenario_id]
    respond_to do |format|
      if @aplcat_parameter.save
        format.html { redirect_to edit_aplcat_parameter_path(session[:scenario_id]), notice: 'Aplcat parameter was successfully created.' }
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
    @aplcat_parameter = AplcatParameter.find(params[:id])
    respond_to do |format|
      if @aplcat_parameter.update_attributes(aplcat_parameter_params)
        format.html { redirect_to edit_aplcat_parameter_path(session[:scenario_id]), notice: 'Aplcat parameter was successfully updated.' }
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

  def create_aplcat_file
	aplcat_file = Array.new
	apex_string = ""
	apex_string += sprintf("%8.2f", AplcatParameter.noc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.nomb) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.norh) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.abwc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.abwmb) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.abwh) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.prh) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.prb) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.adwgbc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.adwgbh) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.mrga) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.jdcc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.gpc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.tpwg) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.csefa) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.srop) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.bwoc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.jdbs) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.dmd) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.dmi) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.napanr) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.napaip) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.mpsm) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.splm) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.pmme) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.rhaeba) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.toaboba) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.vsim) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.foue) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.ash) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.mmppfm) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.cfmms) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.fnemimms) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.effn2ofmms) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.dwawfga) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.dwawflc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.dwawfmb) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.pgu) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.ada) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.ape) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.platc) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.pctbb) + "\n"
	apex_string += sprintf("%8.2f", AplcatParameter.ptdife) + "\n"
	aplcat_file.push(apex_string + "\n")
	msg = send_file_to_APEX(aplcat_file, "COW_CALF")
	msg = send_file_to_APEX(aplcat_file, "DRINKIGWATER")
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
