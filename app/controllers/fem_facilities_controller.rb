class FemFacilitiesController < ApplicationController
  before_action :set_fem_facility, only: [:show, :edit, :update, :destroy]
  include FemHelper
  # GET /fem_facilities
  def index
    session[:simulation] = "fem"
    @fem_facilities = FemFacility.where(:project_id => @project.id).order(:name)    
    if @fem_facilities == [] then
      load_facilities
      @fem_facilities = FemFacility.where(:project_id => @project.id).order(:name)    
    end
  end

  # GET /fem_facilities/1
  def show
  end

  # GET /fem_facilities/new
  def new
    @fem_facility = FemFacility.new
  end

  # GET /fem_facilities/1/edit
  def edit
    @fem_facilitiy = FemFacility.find(params[:id])
  end

  # POST /fem_facilities
  def create
    @fem_facility = FemFacility.new(fem_facility_params)

    if @fem_facility.save
      redirect_to @fem_facility, notice: 'Fem facility was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fem_facilities/1
  def update
    @fem_facility = FemFacility.find(params[:id])
    @fem_facility.updated = true
    respond_to do |format|
      if @fem_facility.update_attributes(fem_facility_params)
        format.html { redirect_to project_fem_facilities_path(@project), notice: 'General Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fem_facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fem_facilities/1
  def destroy
    @fem_facility.destroy
    redirect_to fem_facilities_url, notice: 'Fem facility was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fem_facility
      @fem_facility = FemFacility.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fem_facility_params
      params.require(:fem_facility).permit(:name, :lease_rate, :new_price, :new_life, :current_price, 
        :life_remaining, :maintenance_coeff, :loan_interest_rate, :length_loan,:interest_rate_equity,
        :proportion_debt, :year, :updated)
    end
end