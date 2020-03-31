class TrucksController < ApplicationController
  before_action :set_truck, only: [:show, :edit, :update, :destroy]

  # GET /trucks
  def index
    @trucks = Truck.all
  end

  # GET /trucks/1
  def show
    truck = Truck.find(params[:id])
    respond_to do |format|
      format.json { render json: truck }
    end
  end

  # GET /trucks/new
  def new
    @truck = Truck.new
  end

  # GET /trucks/1/edit
  def edit
  end

  # POST /trucks
  def create
    @truck = Truck.new(truck_params)

    if @truck.save
      redirect_to @truck, notice: 'Truck was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /trucks/1
  def update
    if @truck.update(truck_params)
      redirect_to @truck, notice: 'Truck was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /trucks/1
  def destroy
    @truck.destroy
    redirect_to trucks_url, notice: 'Truck was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck
      @truck = Truck.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def truck_params
      params.require(:truck).permit(:class, :description)
    end
end
