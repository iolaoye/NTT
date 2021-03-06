include ApplicationHelper

class ApexControlsController < ApplicationController
  # GET /apex_controls
  # GET /apex_controls.json
  
  def index
    #@field = Field.find(params[:field_id])
    #@project = Project.find(params[:project_id])
  	@apex_controls = ApexControl.includes(:control_description).where(:project_id => @project.id)	
	
    add_breadcrumb t('menu.utility_file')
    add_breadcrumb t('menu.control_file')
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
    #@field = Field.find(params[:field_id])
    #@project = Project.find(params[:project_id])
  	@apex_control = ApexControl.includes(:control_description).find(params[:id])
  	@control_code = @apex_control.control_description.code
  	@low_range = @apex_control.control_description.range_low
  	@high_range = @apex_control.control_description.range_high
		
    add_breadcrumb t('menu.utility_file')
    add_breadcrumb t('menu.control_file'), controller: "apex_controls", action: "index"
    add_breadcrumb t('general.editing') + " " +  t('menu.control_file')
  end

  # POST /apex_controls
  # POST /apex_controls.json
  def create
    @apex_control = ApexControl.new(apex_control_params)

    respond_to do |format|
      if @apex_control.save
        format.html { redirect_to @apex_control, notice: "Apex control was successfully created." }
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
        format.html { redirect_to project_field_apex_controls_url, notice: t("models.apex_control") + " " + t("general.updated") }
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

  def reset
    controls = Control.where(:state_id => @project.location.state_id)
    if controls.blank? || controls == nil then
		  controls = Control.where(:state_id => 99)
    end
    #ApexControl.where("project_id = " + params[:project_id].to_s + " AND control_description_id != 1 AND control_description_id != 2").delete_all()
    ApexControl.where(:project_id => @project.id).delete_all()

    controls.each do |control|
  		apex_control = ApexControl.new
  		apex_control.control_description_id = control.number
      apex_control.project_id = @project.id
      if control.number != 1 && control.number != 2
  		  apex_control.value = control.default_value
      else
        weather = Weather.find_by_field_id(@field.id)
        #weather = Weather.find(@field.weather_id)
        if control.number == 1 then
          apex_control.value = weather.simulation_final_year - weather.simulation_initial_year + 5 + 1
        end
        if control.number == 2
          apex_control.value = weather.simulation_initial_year - 5
        end
  		end
      apex_control.save
    end
    #@field = Field.find(params[:field_id])
    #@project = Project.find(params[:project_id])
  	@apex_controls = ApexControl.includes(:control_description).where(:project_id => @project.id)	
	
    add_breadcrumb 'Utility Files'
    add_breadcrumb 'Controls'
    # render "index"
    redirect_to project_field_apex_controls_path(@project, @field), notice: t("models.apex_control") + " " + t("general.reset")
  end

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def apex_control_params
      params.require(:apex_control).permit(:control_description_id, :value)
    end
end
