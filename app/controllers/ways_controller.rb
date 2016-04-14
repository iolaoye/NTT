class WaysController < ApplicationController
  # GET /ways
  # GET /ways.json
  def index
    @ways = Way.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ways }
    end
  end

  # GET /ways/1
  # GET /ways/1.json
  def show
    @way = Way.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @way }
    end
  end

  # GET /ways/new
  # GET /ways/new.json
  def new
    @way = Way.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @way }
    end
  end

  # GET /ways/1/edit
  def edit
    @way = Way.find(params[:id])
  end

  # POST /ways
  # POST /ways.json
  def create
    @way = Way.new(way_params)

    respond_to do |format|
      if @way.save
        format.html { redirect_to @way, notice: 'Way was successfully created.' }
        format.json { render json: @way, status: :created, location: @way }
      else
        format.html { render action: "new" }
        format.json { render json: @way.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ways/1
  # PATCH/PUT /ways/1.json
  def update
    @way = Way.find(params[:id])

    respond_to do |format|
      if @way.update_attributes(way_params)
        format.html { redirect_to @way, notice: 'Way was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @way.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ways/1
  # DELETE /ways/1.json
  def destroy
    @way = Way.find(params[:id])
    @way.destroy

    respond_to do |format|
      format.html { redirect_to ways_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def way_params
      params.require(:way).permit(:way_name, :spanish_name, :way_value)
    end
end
