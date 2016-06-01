class ChartsController < ApplicationController
  # GET /charts
  # GET /charts.json
  def index
    @charts = Chart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @charts }
    end
  end

  # GET /charts/1
  # GET /charts/1.json
  def show
    @chart = Chart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chart }
    end
  end

  # GET /charts/new
  # GET /charts/new.json
  def new
    @chart = Chart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chart }
    end
  end

  # GET /charts/1/edit
  def edit
    @chart = Chart.find(params[:id])
  end

  # POST /charts
  # POST /charts.json
  def create
    @chart = Chart.new(chart_params)

    respond_to do |format|
      if @chart.save
        format.html { redirect_to @chart, notice: 'Chart was successfully created.' }
        format.json { render json: @chart, status: :created, location: @chart }
      else
        format.html { render action: "new" }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charts/1
  # PATCH/PUT /charts/1.json
  def update
    @chart = Chart.find(params[:id])

    respond_to do |format|
      if @chart.update_attributes(chart_params)
        format.html { redirect_to @chart, notice: 'Chart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.json
  def destroy
    @chart = Chart.find(params[:id])
    @chart.destroy

    respond_to do |format|
      format.html { redirect_to charts_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def chart_params
      params.require(:chart).permit(:description_id, :field_id, :month_year, :scenario_id, :soil_id, :value)
    end
end
