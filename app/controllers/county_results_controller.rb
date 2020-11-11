class CountyResultsController < ApplicationController
  before_action :set_county_result, only: [:show, :edit, :update, :destroy]

  # GET /county_results
  def index
    @county_results = CountyResult.all
  end

  # GET /county_results/1
  def show
  end

  # GET /county_results/new
  def new
    @county_result = CountyResult.new
  end

  # GET /county_results/1/edit
  def edit
  end

  # POST /county_results
  def create
    @county_result = CountyResult.new(county_result_params)

    if @county_result.save
      redirect_to @county_result, notice: 'County result was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /county_results/1
  def update
    if @county_result.update(county_result_params)
      redirect_to @county_result, notice: 'County result was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /county_results/1
  def destroy
    @county_result.destroy
    redirect_to county_results_url, notice: 'County result was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_county_result
      @county_result = CountyResult.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def county_result_params
      params.fetch(:county_result, {})
    end
end
