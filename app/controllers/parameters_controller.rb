class ParametersController < ApplicationController
  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parameters }
    end
  end

  # GET /parameters/1
  # GET /parameters/1.json
  def show
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parameter }
    end
  end

  # GET /parameters/new
  # GET /parameters/new.json
  def new
    @parameter = Parameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parameter }
    end
  end

  # GET /parameters/1/edit
  def edit
    @parameter = Parameter.find(params[:id])
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(parameter_params)

    respond_to do |format|
      if @parameter.save
        format.html { redirect_to @parameter, notice: 'Parameter was successfully created.' }
        format.json { render json: @parameter, status: :created, location: @parameter }
      else
        format.html { render action: "new" }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parameters/1
  # PATCH/PUT /parameters/1.json
  def update
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      if @parameter.update_attributes(parameter_params)
        format.html { redirect_to @parameter, notice: 'Parameter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    @parameter = Parameter.find(params[:id])
    @parameter.destroy

    respond_to do |format|
      format.html { redirect_to parameters_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def parameter_params
      params.require(:parameter).permit(:line, :number, :name, :description, :range_low, :range_high, :default_value, :id)
    end
end
