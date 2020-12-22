class CountyCropResultsController < ApplicationController
  before_action :set_county_crop_result, only: [:show, :edit, :update, :destroy]

  # GET /county_crop_results
  def index
    @county_crop_results = CountyCropResult.all
  end

  # GET /county_crop_results/1
  def show
  end

  # GET /county_crop_results/new
  def new
    @county_crop_result = CountyCropResult.new
  end

  # GET /county_crop_results/1/edit
  def edit
  end

  # POST /county_crop_results
  def create
    @county_crop_result = CountyCropResult.new(county_crop_result_params)

    if @county_crop_result.save
      redirect_to @county_crop_result, notice: 'County crop result was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /county_crop_results/1
  def update
    if @county_crop_result.update(county_crop_result_params)
      redirect_to @county_crop_result, notice: 'County crop result was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /county_crop_results/1
  def destroy
    @county_crop_result.destroy
    redirect_to county_crop_results_url, notice: 'County crop result was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_county_crop_result
      @county_crop_result = CountyCropResult.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def county_crop_result_params
      params.require(:county_crop_result).permit(:state_id, :county_id, :scenario_id, :name, :yield, :ws, :ns, :ps, :ts, :yield_ci)
    end
end
