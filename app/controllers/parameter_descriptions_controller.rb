class ParameterDescriptionsController < ApplicationController
  # GET /parameter_descriptions
  # GET /parameter_descriptions.json
  def index
    @parameter_descriptions = ParameterDescription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parameter_descriptions }
    end
  end

  # GET /parameter_descriptions/1
  # GET /parameter_descriptions/1.json
  def show
    @parameter_description = ParameterDescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parameter_description }
    end
  end

  # GET /parameter_descriptions/new
  # GET /parameter_descriptions/new.json
  def new
    @parameter_description = ParameterDescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parameter_description }
    end
  end

  # GET /parameter_descriptions/1/edit
  def edit
    @parameter_description = ParameterDescription.find(params[:id])
  end

  # POST /parameter_descriptions
  # POST /parameter_descriptions.json
  def create
    @parameter_description = ParameterDescription.new(parameter_description_params)

    respond_to do |format|
      if @parameter_description.save
        format.html { redirect_to @parameter_description, notice: 'Parameter description was successfully created.' }
        format.json { render json: @parameter_description, status: :created, location: @parameter_description }
      else
        format.html { render action: "new" }
        format.json { render json: @parameter_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parameter_descriptions/1
  # PATCH/PUT /parameter_descriptions/1.json
  def update
    @parameter_description = ParameterDescription.find(params[:id])

    respond_to do |format|
      if @parameter_description.update_attributes(parameter_description_params)
        format.html { redirect_to @parameter_description, notice: 'Parameter description was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parameter_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameter_descriptions/1
  # DELETE /parameter_descriptions/1.json
  def destroy
    @parameter_description = ParameterDescription.find(params[:id])
    @parameter_description.destroy

    respond_to do |format|
      format.html { redirect_to parameter_descriptions_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def parameter_description_params
      params.require(:parameter_description).permit(:id, :line, :name, :number, :range_high, :range_low)
    end
end
