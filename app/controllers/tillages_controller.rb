class TillagesController < ApplicationController
  # GET /tillages/1
  # GET /1/tillages.json
  def list
    @tillages = Tillage.where(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tillages }
    end
  end

  # GET /tillages
  # GET /tillages.json
  def index
    @tillages = Tillage.where(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tillages }
    end
  end

  # GET /tillages/1
  # GET /tillages/1.json
  def show
    @tillage = Tillage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tillage }
    end
  end

  # GET /tillages/new
  # GET /tillages/new.json
  def new
    @tillage = Tillage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tillage }
    end
  end

  # GET /tillages/1/edit
  def edit
    @tillage = Tillage.find(params[:id])
  end

  # POST /tillages
  # POST /tillages.json
  def create
    @tillage = Tillage.new(tillage_params)

    respond_to do |format|
      if @tillage.save
        format.html { redirect_to @tillage, notice: 'Tillage was successfully created.' }
        format.json { render json: @tillage, status: :created, location: @tillage }
      else
        format.html { render action: "new" }
        format.json { render json: @tillage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tillages/1
  # PATCH/PUT /tillages/1.json
  def update
    @tillage = Tillage.find(params[:id])

    respond_to do |format|
      if @tillage.update_attributes(tillage_params)
        format.html { redirect_to @tillage, notice: 'Tillage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tillage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tillages/1
  # DELETE /tillages/1.json
  def destroy
    @tillage = Tillage.find(params[:id])
    @tillage.destroy

    respond_to do |format|
      format.html { redirect_to tillages_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def tillage_params
      params.require(:tillage).permit(:abbreviation, :code, :dndc, :eqp, :name, :operation, :spanish_name, :status)
    end
end
