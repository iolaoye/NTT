class CountiesController < ApplicationController

  # GET /counties
  # GET /counties.json
  def index

    @counties = County.where(:state_id => params[:state_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @counties }
    end
  end

  # GET /counties/1
  # GET /counties/1.json
  def show
    @county = County.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @county }
    end
  end

  # GET /counties/new
  # GET /counties/new.json
  def new
    @county = County.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @county }
    end
  end

  # GET /counties/1/edit
  def edit
    @county = County.find(params[:id])
  end

  # POST /counties
  # POST /counties.json
  def create
    @county = County.new(county_params)

    respond_to do |format|
      if @county.save
        format.html { redirect_to @county, notice: 'County was successfully created.' }
        format.json { render json: @county, status: :created, location: @county }
      else
        format.html { render action: "new" }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /counties/1
  # PATCH/PUT /counties/1.json
  def update
    @county = County.find(params[:id])

    respond_to do |format|
      if @county.update_attributes(county_params)
        format.html { redirect_to @county, notice: 'County was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /counties/1
  # DELETE /counties/1.json
  def destroy
    @county = County.find(params[:id])
    @county.destroy

    respond_to do |format|
      format.html { redirect_to counties_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def county_params
      params.require(:county).permit(:county_code, :county_name, :latitude, :longitude, :state_id, :status, :county_state_code)
    end
end
