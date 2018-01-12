class CropResultsController < ApplicationController
  before_action :set_crop_result, only: [:show, :edit, :update, :destroy]

  # GET /crop_results
  def index
    @crop_results = CropResult.all
  end

  # GET /crop_results/1
  def show
  end

  # GET /crop_results/new
  def new
    @crop_result = CropResult.new
  end

  # GET /crop_results/1/edit
  def edit
  end

  # POST /crop_results
  def create
    @crop_result = CropResult.new(crop_result_params)

    if @crop_result.save
      redirect_to @crop_result, notice: 'Crop result was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /crop_results/1
  def update
    if @crop_result.update(crop_result_params)
      redirect_to @crop_result, notice: 'Crop result was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /crop_results/1
  def destroy
    @crop_result.destroy
    redirect_to crop_results_url, notice: 'Crop result was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crop_result
      @crop_result = CropResult.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def crop_result_params
      params.require(:crop_result).permit(:scenario_id, :sub1, :year, :yldg, :yldf, :ws, :ns, :ps, :ts)
    end
end
