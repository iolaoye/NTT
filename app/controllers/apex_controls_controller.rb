  include ApplicationHelper

class ApexControlsController < ApplicationController
  # GET /apex_controls
  # GET /apex_controls.json

  
  
  
  def index
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
  	@apex_controls = ApexControl.includes(:control_description).where(:project_id => params[:project_id])
	
	
	add_breadcrumb 'Utility Files'
	add_breadcrumb 'Controls'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apex_controls }
    end
  end

  # GET /apex_controls/1
  # GET /apex_controls/1.json
  def show
    @apex_control = ApexControl.where(:project_id => params[:project_id]).find(params[:id])

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
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
  	@apex_control = ApexControl.includes(:control_description).where(:project_id => params[:project_id]).find(params[:id])
  	@control_code = @apex_control.control_description.code
  	@low_range = @apex_control.control_description.range_low
  	@high_range = @apex_control.control_description.range_high
	
	
	add_breadcrumb 'Utility Files'
	add_breadcrumb 'Controls', controller: "apex_controls", action: "index"
	add_breadcrumb 'Editing Control Files"
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
    @apex_control = ApexControl.where(:project_id => params[:project_id]).find(params[:id])

    respond_to do |format|
      if @apex_control.update_attributes(apex_control_params)
        format.html { redirect_to project_field_apex_controls_url, notice: t('models.apex_control') + " " + t('general.updated') }
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
    @apex_control = ApexControl.where(:project_id => params[:project_id]).find(params[:id])
    @apex_control.destroy

    respond_to do |format|
      format.html { redirect_to apex_controls_url }
      format.json { head :no_content }
    end
  end

  def reset
    controls = Control.where(:state_id => Location.find(session[:location_id]).state_id)
    if controls.blank? || controls == nil then
		  controls = Control.where(:state_id => 99)
	  end
    @apex_controls = ApexControl.where("project_id == " + params[:project_id].to_s + " AND control_description_id != 1 AND control_description_id != 2")
    @apex_controls.delete_all()

    controls.each do |control|
		if control.id != 1 && control.id != 2
		  apex_control = ApexControl.new
		  apex_control.control_description_id = control.id
		  apex_control.value = control.default_value
		  apex_control.project_id = params[:project_id]
		  apex_control.save
		end
    end
    redirect_to apex_controls_url, notice: t('models.apex_control') + " " + t('general.reset')
  end

  def download
	  download_apex_files()
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def apex_control_params
      params.require(:apex_control).permit(:control_description_id, :value)
    end
end
