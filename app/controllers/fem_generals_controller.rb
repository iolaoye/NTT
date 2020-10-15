class FemGeneralsController < ApplicationController
  #before_action :set_fem_general, only: [:show, :edit, :update, :destroy]
  include FemHelper
  # GET /fem_generals
  def index
    session[:simulation] = "fem"
    @fem_generals = FemGeneral.where(:project_id => @project.id).order(:name)
    if @fem_generals == [] then
      load_generals
      @fem_generals = FemGeneral.where(:project_id => @project.id).order(:name)    
    end
    if params[:field_id] != nil then @field = Field.find(params[:field_id]) end
  end

  # GET /fem_generals/1
  def show
  end

  # GET /fem_generals/new
  def new
    @fem_general = FemGeneral.new
  end

  # GET /fem_generals/1/edit
  def edit
    @fem_general = FemGeneral.find(params[:id])
  end

  # POST /fem_generals
  def create
    @fem_general = FemGeneral.new(fem_general_params)

    if @fem_general.save
      redirect_to @fem_general, notice: 'Fem general was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fem_generals/1
  def update
    @fem_general = FemGeneral.find(params[:id])
    @fem_general.updated = true

    respond_to do |format|
      if @fem_general.update_attributes(fem_general_params)
        format.html { redirect_to project_fem_generals_path(@project, :field_id => params[:fem_general][:field_id], :caller_id => "FEM"), notice: 'General Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fem_general.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fem_generals/1
  def destroy
    @fem_general.destroy
    redirect_to fem_generals_url, notice: 'Fem general was successfully destroyed.'
  end

  def reset
    @field = Field.find(params[:id])
    FemGeneral.where(:project_id => @project.id).delete_all
    redirect_to project_fem_generals_path(@project, :field_id => @field.id, :button => t('fem.general')), notice: t("models.apex_control") + " " + t("general.reset")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fem_general
      @fem_general = FemGeneral.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fem_general_params
      params.require(:fem_general).permit(:name, :unit, :value, :updated)
    end
end
