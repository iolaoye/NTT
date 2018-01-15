class AnnualResultsController < ApplicationController
  before_action :set_annual_result, only: [:show, :edit, :update, :destroy]

  # GET /annual_results
  def index
    @annual_results = AnnualResult.all
  end

  # GET /annual_results/1
  def show
  end

  # GET /annual_results/new
  def new
    @annual_result = AnnualResult.new
  end

  # GET /annual_results/1/edit
  def edit
  end

  # POST /annual_results
  def create
    @annual_result = AnnualResult.new(annual_result_params)

    if @annual_result.save
      redirect_to @annual_result, notice: 'Annual result was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /annual_results/1
  def update
    if @annual_result.update(annual_result_params)
      redirect_to @annual_result, notice: 'Annual result was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /annual_results/1
  def destroy
    @annual_result.destroy
    redirect_to annual_results_url, notice: 'Annual result was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annual_result
      @annual_result = AnnualResult.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def annual_result_params
      params.require(:annual_result).permit(:scenario_id, :sub1, :year, :flow, :qdr, :surface_flow, :sed, :ymnu, :orgp, :po4, :orgn, :no3, :qdrn, :qdrp, :qn, :dprk, :irri, :pcp, :n2o)
    end
end
