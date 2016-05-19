class ApexControlsController < ApplicationController
  # GET /apex_controls
  # GET /apex_controls.json
  def index
    @apex_controls = ApexControl.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apex_controls }
    end
  end

  # GET /apex_controls/1
  # GET /apex_controls/1.json
  def show
    @apex_control = ApexControl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apex_control }
    end
  end

  # GET /apex_controls/new
  # GET /apex_controls/new.json
  def new
    @apex_control = ApexControl.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apex_control }
    end
  end

  # GET /apex_controls/1/edit
  def edit
    @apex_control = ApexControl.find(params[:id])
  end

  # POST /apex_controls
  # POST /apex_controls.json
  def create
    @apex_control = ApexControl.new(apex_control_params)

    respond_to do |format|
      if @apex_control.save
        format.html { redirect_to @apex_control, notice: 'Apex control was successfully created.' }
        format.json { render json: @apex_control, status: :created, location: @apex_control }
      else
        format.html { render action: "new" }
        format.json { render json: @apex_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apex_controls/1
  # PATCH/PUT /apex_controls/1.json
  def update
    @apex_control = ApexControl.find(params[:id])

    respond_to do |format|
      if @apex_control.update_attributes(apex_control_params)
        format.html { redirect_to @apex_control, notice: 'Apex control was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apex_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apex_controls/1
  # DELETE /apex_controls/1.json
  def destroy
    @apex_control = ApexControl.find(params[:id])
    @apex_control.destroy

    respond_to do |format|
      format.html { redirect_to apex_controls_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def apex_control_params
      params.require(:apex_control).permit(:control_id, :value)
    end
end
