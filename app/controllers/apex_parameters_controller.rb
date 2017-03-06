class ApexParametersController < ApplicationController
  # GET /apex_parameters
  # GET /apex_parameters.json
  def index
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @apex_parameters = ApexParameter.includes(:parameter_description).where(:project_id => session[:project_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apex_parameters }
    end
  end

  # GET /apex_parameters/1
  # GET /apex_parameters/1.json
  def show
    @apex_parameter = ApexParameter.where(:project_id => session[:project_id]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apex_parameter }
    end
  end

  # GET /apex_parameters/new
  # GET /apex_parameters/new.json
  def new
    @apex_parameter = ApexParameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apex_parameter }
    end
  end

  # GET /apex_parameters/1/edit
  def edit
    @apex_parameter = ApexParameter.includes(:parameter_description).where(:project_id => session[:project_id]).find(params[:id])
    @parameter_name = @apex_parameter.parameter.name
    @low_range = @apex_parameter.parameter.range_low
    @high_range = @apex_parameter.parameter.range_high
    #@apex_parameter = ApexParameter.where(:project_id => session[:project_id]).find(params[:id])
  end

  # POST /apex_parameters
  # POST /apex_parameters.json
  def create
    @apex_parameter = ApexParameter.new(apex_parameter_params)

    respond_to do |format|
      if @apex_parameter.save
        format.html { redirect_to @apex_parameter, notice: 'Apex parameter was successfully created.' }
        format.json { render json: @apex_parameter, status: :created, location: @apex_parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @apex_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apex_parameters/1
  # PATCH/PUT /apex_parameters/1.json
  def update
    @apex_parameter = ApexParameter.where(:project_id => session[:project_id]).find(params[:id])

    respond_to do |format|
      if @apex_parameter.update_attributes(apex_parameter_params)
        format.html { redirect_to apex_parameters_url, notice: t('models.apex_parameter') + " " + t('general.updated')}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apex_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apex_parameters/1
  # DELETE /apex_parameters/1.json
  def destroy
    @apex_parameter = ApexParameter.where(:project_id => session[:project_id]).find(params[:id])
    @apex_parameter.destroy

    respond_to do |format|
      format.html { redirect_to apex_parameters_url }
      format.json { head :no_content }
    end
  end

  def reset
    parameters = Parameter.where(:state_id => Location.find(session[:location_id]).state_id)
	if parameters == nil or parameters.blank? then
		parameters = Parameter.where(:state_id => 99)
	end

    @apex_parameters = ApexParameter.where(:project_id => session[:project_id])
    @apex_parameters.delete_all()

    parameters.each do |parameter|
		  apex_parameter = ApexParameter.new
		  apex_parameter.parameter_description_id = parameter.number
		  apex_parameter.value = parameter.default_value
		  apex_parameter.project_id = session[:project_id]
		  apex_parameter.save
    end
    redirect_to apex_parameters_url, notice: t('models.apex_parameter') + " " + t('general.reset')
  end

  def download
	download_apex_files()
  end
  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def apex_parameter_params
    params.require(:apex_parameter).permit(:parameter_description_id, :project_id, :value)
  end
end
