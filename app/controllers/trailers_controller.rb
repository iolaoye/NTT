class TrailersController < ApplicationController
  before_action :set_trailer, only: [:show, :edit, :update, :destroy]

  # GET /trailers
  def index
    @trailers = Trailer.all
  end

  # GET /trailers/1
  def show
    trailer = Trailer.find(params[:id])
    respond_to do |format|
      format.json { render json: trailer }
    end
  end

  # GET /trailers/new
  def new
    @trailer = Trailer.new
  end

  # GET /trailers/1/edit
  def edit
  end

  # POST /trailers
  def create
    @trailer = Trailer.new(trailer_params)

    if @trailer.save
      redirect_to @trailer, notice: 'Trailer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /trailers/1
  def update
    if @trailer.update(trailer_params)
      redirect_to @trailer, notice: 'Trailer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /trailers/1
  def destroy
    @trailer.destroy
    redirect_to trailers_url, notice: 'Trailer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trailer
      @trailer = Trailer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trailer_params
      params.require(:trailer).permit(:code, :description, :length, :width, :payload, :suggestion, :height)
    end
end
