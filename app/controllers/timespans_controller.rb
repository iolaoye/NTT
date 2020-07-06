class TimespansController < ApplicationController
  before_action :set_timespan, only: [:show, :edit, :update, :destroy]

  # GET /timespans
  def index
    @timespans = Timespan.all
  end

  # GET /timespans/1
  def show
    @timespan = Timespan.where(:bmp_id => params[:id], :crop_id => params[:crop_id])
    respond_to do |format|
      format.json { render json: @timespan}
    end
  end

  # GET /timespans/new
  def new
    @timespan = Timespan.new
  end

  # GET /timespans/1/edit
  def edit
  end

  # POST /timespans
  def create
    @timespan = Timespan.new(timespan_params)

    if @timespan.save
      redirect_to @timespan, notice: 'Timespan was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /timespans/1
  def update
    if @timespan.update(timespan_params)
      redirect_to @timespan, notice: 'Timespan was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /timespans/1
  def destroy
    @timespan.destroy
    redirect_to timespans_url, notice: 'Timespan was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timespan
      @timespan = Timespan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def timespan_params
      params.require(:timespan).permit(:bmp_id, :crop_id, :start_month, :start_day, :end_month, :end_day)
    end
end
