class ManureControlsController < ApplicationController
  # GET /manure_controls
  # GET /manure_controls.json
  def index
    @manure_controls = ManureControl.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manure_controls }
    end
  end

  # GET /manure_controls/1
  # GET /manure_controls/1.json
  def show
    @manure_control = ManureControl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manure_control }
    end
  end

  # GET /manure_controls/new
  # GET /manure_controls/new.json
  def new
    @manure_control = ManureControl.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manure_control }
    end
  end

  # GET /manure_controls/1/edit
  def edit
    @manure_control = ManureControl.find(params[:id])
  end

  # POST /manure_controls
  # POST /manure_controls.json
  def create
    @manure_control = ManureControl.new(manure_control_params)

    respond_to do |format|
      if @manure_control.save
        format.html { redirect_to @manure_control, notice: 'Manure control was successfully created.' }
        format.json { render json: @manure_control, status: :created, location: @manure_control }
      else
        format.html { render action: "new" }
        format.json { render json: @manure_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manure_controls/1
  # PATCH/PUT /manure_controls/1.json
  def update
    @manure_control = ManureControl.find(params[:id])

    respond_to do |format|
      if @manure_control.update_attributes(manure_control_params)
        format.html { redirect_to @manure_control, notice: 'Manure control was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manure_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manure_controls/1
  # DELETE /manure_controls/1.json
  def destroy
    @manure_control = ManureControl.find(params[:id])
    @manure_control.destroy

    respond_to do |format|
      format.html { redirect_to manure_controls_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def manure_control_params
      params.require(:manure_control).permit(:id, :name, :no3n, :om, :orgn, :orgp, :po4p, :spanish_name)
    end
end
