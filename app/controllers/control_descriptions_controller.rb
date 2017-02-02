class ControlDescriptionsController < ApplicationController
  # GET /control_descriptions
  # GET /control_descriptions.json
  def index
    @control_descriptions = ControlDescription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @control_descriptions }
    end
  end

  # GET /control_descriptions/1
  # GET /control_descriptions/1.json
  def show
    @control_description = ControlDescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @control_description }
    end
  end

  # GET /control_descriptions/new
  # GET /control_descriptions/new.json
  def new
    @control_description = ControlDescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @control_description }
    end
  end

  # GET /control_descriptions/1/edit
  def edit
    @control_description = ControlDescription.find(params[:id])
  end

  # POST /control_descriptions
  # POST /control_descriptions.json
  def create
    @control_description = ControlDescription.new(control_description_params)

    respond_to do |format|
      if @control_description.save
        format.html { redirect_to @control_description, notice: 'Control description was successfully created.' }
        format.json { render json: @control_description, status: :created, location: @control_description }
      else
        format.html { render action: "new" }
        format.json { render json: @control_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /control_descriptions/1
  # PATCH/PUT /control_descriptions/1.json
  def update
    @control_description = ControlDescription.find(params[:id])

    respond_to do |format|
      if @control_description.update_attributes(control_description_params)
        format.html { redirect_to @control_description, notice: 'Control description was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @control_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /control_descriptions/1
  # DELETE /control_descriptions/1.json
  def destroy
    @control_description = ControlDescription.find(params[:id])
    @control_description.destroy

    respond_to do |format|
      format.html { redirect_to control_descriptions_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def control_description_params
      params.require(:control_description).permit(:code, :column, :id, :line, :name, :range_high, :range_low)
    end
end
