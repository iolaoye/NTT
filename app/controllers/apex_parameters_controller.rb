class ApexParametersController < ApplicationController
  # GET /apex_parameters
  # GET /apex_parameters.json
  def index
    @apex_parameters = ApexParameter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apex_parameters }
    end
  end

  # GET /apex_parameters/1
  # GET /apex_parameters/1.json
  def show
    @apex_parameter = ApexParameter.find(params[:id])

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
    @apex_parameter = ApexParameter.find(params[:id])
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
    @apex_parameter = ApexParameter.find(params[:id])

    respond_to do |format|
      if @apex_parameter.update_attributes(apex_parameter_params)
        format.html { redirect_to @apex_parameter, notice: 'Apex parameter was successfully updated.' }
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
    @apex_parameter = ApexParameter.find(params[:id])
    @apex_parameter.destroy

    respond_to do |format|
      format.html { redirect_to apex_parameters_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def apex_parameter_params
      params.require(:apex_parameter).permit(:parameter_id, :project_id, :value)
    end
end
