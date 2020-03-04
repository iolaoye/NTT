class FuelsController < ApplicationController
  before_action :set_fuel, only: [:show, :edit, :update, :destroy]

  # GET /fuels
  def index
    @fuels = Fuel.all
  end

  # GET /fuels/1
  def show
  end

  # GET /fuels/new
  def new
    @fuel = Fuel.new
  end

  # GET /fuels/1/edit
  def edit
  end

  # POST /fuels
  def create
    @fuel = Fuel.new(fuel_params)

    if @fuel.save
      redirect_to @fuel, notice: 'Fuel was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fuels/1
  def update
    if @fuel.update(fuel_params)
      redirect_to @fuel, notice: 'Fuel was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /fuels/1
  def destroy
    @fuel.destroy
    redirect_to fuels_url, notice: 'Fuel was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel
      @fuel = Fuel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fuel_params
      params.require(:fuel).permit(:code, :description)
    end
end
