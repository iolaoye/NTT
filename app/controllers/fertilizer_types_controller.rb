class FertilizerTypesController < ApplicationController
  # GET /fertilizer_types
  # GET /fertilizer_types.json
  def index
    @fertilizer_types = FertilizerType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fertilizer_types }
    end
  end

  # GET /fertilizer_types/1
  # GET /fertilizer_types/1.json
  def show
    @fertilizer_type = FertilizerType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fertilizer_type }
    end
  end

  # GET /fertilizer_types/new
  # GET /fertilizer_types/new.json
  def new
    @fertilizer_type = FertilizerType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fertilizer_type }
    end
  end

  # GET /fertilizer_types/1/edit
  def edit
    @fertilizer_type = FertilizerType.find(params[:id])
  end

  # POST /fertilizer_types
  # POST /fertilizer_types.json
  def create
    @fertilizer_type = FertilizerType.new(fertilizer_type_params)

    respond_to do |format|
      if @fertilizer_type.save
        format.html { redirect_to @fertilizer_type, notice: 'Fertilizer type was successfully created.' }
        format.json { render json: @fertilizer_type, status: :created, location: @fertilizer_type }
      else
        format.html { render action: "new" }
        format.json { render json: @fertilizer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fertilizer_types/1
  # PATCH/PUT /fertilizer_types/1.json
  def update
    @fertilizer_type = FertilizerType.find(params[:id])

    respond_to do |format|
      if @fertilizer_type.update_attributes(fertilizer_type_params)
        format.html { redirect_to @fertilizer_type, notice: 'Fertilizer type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fertilizer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fertilizer_types/1
  # DELETE /fertilizer_types/1.json
  def destroy
    @fertilizer_type = FertilizerType.find(params[:id])
    @fertilizer_type.destroy

    respond_to do |format|
      format.html { redirect_to fertilizer_types_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def fertilizer_type_params
      params.require(:fertilizer_type).permit(:name, :spanish_name)
    end
end
