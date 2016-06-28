class ClimatesController < ApplicationController
  # GET /climates
  # GET /climates.json
  def index
    @climates = Climate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @climates }
    end
  end

  # GET /climates/1
  # GET /climates/1.json
  def show
    @climate = Climate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @climate }
    end
  end

  # GET /climates/new
  # GET /climates/new.json
  def new
    @climate = Climate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @climate }
    end
  end

  # GET /climates/1/edit
  def edit
    @climate = Climate.find(params[:id])
  end

  # POST /climates
  # POST /climates.json
  def create
    @climate = Climate.new(climate_params)

    respond_to do |format|
      if @climate.save
        format.html { redirect_to @climate, notice: 'Climate was successfully created.' }
        format.json { render json: @climate, status: :created, location: @climate }
      else
        format.html { render action: "new" }
        format.json { render json: @climate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /climates/1
  # PATCH/PUT /climates/1.json
  def update
    @climate = Climate.find(params[:id])

    respond_to do |format|
      if @climate.update_attributes(climate_params)
        format.html { redirect_to @climate, notice: 'Climate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @climate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /climates/1
  # DELETE /climates/1.json
  def destroy
    @climate = Climate.find(params[:id])
    @climate.destroy

    respond_to do |format|
      format.html { redirect_to climates_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def climate_params
      params.require(:climate).permit(:bmp_id, :max_temp, :min_temp, :month, :precipitation, :spanish_month)
    end
end
