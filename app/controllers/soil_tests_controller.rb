class SoilTestsController < ApplicationController
  before_action :set_soil_test, only: [:show, :edit, :update, :destroy]

  # GET /soil_tests
  def index
    @soil_tests = SoilTest.all
  end

  # GET /soil_tests/1
  def show
  end

  # GET /soil_tests/new
  def new
    @soil_test = SoilTest.new
  end

  # GET /soil_tests/1/edit
  def edit
  end

  # POST /soil_tests
  def create
    @soil_test = SoilTest.new(soil_test_params)

    if @soil_test.save
      redirect_to @soil_test, notice: 'Soil test was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /soil_tests/1
  def update
    if @soil_test.update(soil_test_params)
      redirect_to @soil_test, notice: 'Soil test was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /soil_tests/1
  def destroy
    @soil_test.destroy
    redirect_to soil_tests_url, notice: 'Soil test was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_soil_test
      @soil_test = SoilTest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def soil_test_params
      params.require(:soil_test).permit(:name, :factor1, :factor2)
    end
end
