class FertilizersController < ApplicationController
  # GET /fertilizers
  # GET /fertilizers.json
  def index
    @fertilizers = Fertilizer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fertilizers }
    end
  end

  # GET /fertilizers/1
  # GET /fertilizers/1.json
  def show
    @fertilizer = Fertilizer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fertilizer }
    end
  end

  # GET /fertilizers/new
  # GET /fertilizers/new.json
  def new
    @fertilizer = Fertilizer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fertilizer }
    end
  end

  # GET /fertilizers/1/edit
  def edit
    @fertilizer = Fertilizer.find(params[:id])
  end

  # POST /fertilizers
  # POST /fertilizers.json
  def create
    @fertilizer = Fertilizer.new(fertilizer_params)

    respond_to do |format|
      if @fertilizer.save
        format.html { redirect_to @fertilizer, notice: 'Fertilizer was successfully created.' }
        format.json { render json: @fertilizer, status: :created, location: @fertilizer }
      else
        format.html { render action: "new" }
        format.json { render json: @fertilizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fertilizers/1
  # PATCH/PUT /fertilizers/1.json
  def update
    @fertilizer = Fertilizer.find(params[:id])

    respond_to do |format|
      if @fertilizer.update_attributes(fertilizer_params)
        format.html { redirect_to @fertilizer, notice: 'Fertilizer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fertilizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fertilizers/1
  # DELETE /fertilizers/1.json
  def destroy
    @fertilizer = Fertilizer.find(params[:id])
    @fertilizer.destroy

    respond_to do |format|
      format.html { redirect_to fertilizers_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def fertilizer_params
      params.require(:fertilizer).permit(:code, :name, :qn, :qp, :yn, :yp, :nh3, :type1, :lbs, :status, :spanish_name, :status, :fertilizer_type_id)
    end
end
