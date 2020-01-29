class ClimesController < ApplicationController
  before_action :set_clime, only: [:show, :edit, :update, :destroy]

  # GET /climes
  def index
    @climes = Clime.all
  end

  # GET /climes/1
  def show
  end

  # GET /climes/new
  def new
    @clime = Clime.new
  end

  # GET /climes/1/edit
  def edit
  end

  # POST /climes
  def create
    @clime = Clime.new(clime_params)

    if @clime.save
      redirect_to @clime, notice: 'Clime was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /climes/1
  def update
    if @clime.update(clime_params)
      redirect_to @clime, notice: 'Clime was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /climes/1
  def destroy
    @clime.destroy
    redirect_to climes_url, notice: 'Clime was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clime
      @clime = Clime.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def clime_params
      params.require(:clime).permit(:field_id, :daily_weather)
    end
end
