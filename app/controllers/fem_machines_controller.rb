class FemMachinesController < ApplicationController
  before_action :set_fem_machine, only: [:show, :edit, :update, :destroy]
  include FemHelper

  # GET /fem_machines
  def index
    session[:simulation] = "fem"
    @fem_machines = FemMachine.where(:project_id => @project.id).order(:name)
    if @fem_machines == [] then
      load_machines
      @fem_machines = FemMachine.where(:project_id => @project.id).order(:name)    
    end
  end

  # GET /fem_machines/1
  def show
  end

  # GET /fem_machines/new
  def new
    @fem_machine = FemMachine.new
  end

  # GET /fem_machines/1/edit
  def edit
    @fem_machine = FemMachine.find(params[:id])
  end

  # POST /fem_machines
  def create
    @fem_machine = FemMachine.new(fem_machine_params)

    if @fem_machine.save
      redirect_to @fem_machine, notice: 'Fem machine was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fem_machines/1
  def update
    @fem_machine = FemMachine.find(params[:id])
    @fem_machine.updated = true
    respond_to do |format|
      if @fem_machine.update_attributes(fem_machine_params)
        format.html { redirect_to project_fem_machines_path(@project), notice: 'General Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fem_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fem_machines/1
  def destroy
    @fem_machine.destroy
    redirect_to fem_machines_url, notice: 'Fem machine was successfully destroyed.'
  end

  def reset
    FemMachine.where(:project_id => @project.id).delete_all
    redirect_to project_fem_machines_path(@project, :button => t('fem.machine')), notice: t("models.apex_control") + " " + t("general.reset")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fem_machine
      @fem_machine = FemMachine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fem_machine_params
      params.require(:fem_machine).permit(
              :name,
              :lease_rate,
              :new_price,
              :new_hours,
              :current_price,
              :hours_remaining,
              :width,
              :speed,
              :field_efficiency,
              :horse_power,
              :rf1,
              :rf2,
              :ir_loan,
              :l_loan,
              :ir_equity,
              :p_debt,
              :year,
              :rv1,
              :rv2,
              :updated)
    end
end
