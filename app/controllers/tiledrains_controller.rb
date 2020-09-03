class TiledrainsController < ApplicationController
  before_action :set_tiledrain, only: [:show, :edit, :update, :destroy]

  # GET /tiledrains
  def index
    @tiledrains = Tiledrain.all
  end

  # GET /tiledrains/1
  def show
  end

  # GET /tiledrains/new
  def new
    @tiledrain = Tiledrain.new
  end

  # GET /tiledrains/1/edit
  def edit
  end

  # POST /tiledrains
  def create
    @tiledrain = Tiledrain.new(tiledrain_params)

    if @tiledrain.save
      redirect_to @tiledrain, notice: 'Tiledrain was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tiledrains/1
  def update
    if @tiledrain.update(tiledrain_params)
      redirect_to @tiledrain, notice: 'Tiledrain was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tiledrains/1
  def destroy
    @tiledrain.destroy
    redirect_to tiledrains_url, notice: 'Tiledrain was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiledrain
      @tiledrain = Tiledrain.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tiledrain_params
      params.fetch(:tiledrain, {})
    end
end
