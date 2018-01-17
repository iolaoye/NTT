class CropResultsController < ApplicationController
  before_action :set_crop_result, only: [:show, :edit, :update, :destroy]

  # GET /crop_results
  def index
    #debugger
    scenario_id = params[:session].downcase + "_id"
    if params[:id1] != nil && params[:id2] != nil && params[:id3] != nil
      @crop_results = CropResult.select("name, sub1").where(scenario_id + " = ? || " + scenario_id + " = ? || " + scenario_id + " = ?", params[:id1], params[:id2], params[:id3]).distinct
    elsif params[:id1] != nil && params[:id2] 
      @crop_results = CropResult.select("name, sub1").where(scenario_id + " = ? || " + scenario_id + " = ?", params[:id1], params[:id2]).distinct
    elsif params[:id1] != nil 
      @crop_results = CropResult.select("name, sub1").where(scenario_id + " = ?", params[:id1]).distinct
    else
      @crop_results = CropResult.all
    end
    cr_ant = ""
    crops = Array.new
    @crop_results.each do |cr|
      crop = Crop.find_by_code(cr.name)
      found = false
      crops.each do |cp|
        if crop.name == cp["name"] then 
          found = true
          break
        end 
      end
      if !found then 
        crop_hash = Hash.new
        crop_hash["name"] = crop.name
        crop_hash["crop_id"] = crop.id
        crops.push(crop_hash)
        cr_ant = cr.name
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: crops}
    end
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
