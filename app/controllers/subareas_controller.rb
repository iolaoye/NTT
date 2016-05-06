class SubareasController < ApplicationController
  # GET /subareas
  # GET /subareas.json
  def index
    @subareas = Subarea.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subareas }
    end
  end

  # GET /subareas/1
  # GET /subareas/1.json
  def show
    @subarea = Subarea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subarea }
    end
  end

  # GET /subareas/new
  # GET /subareas/new.json
  def new
    @subarea = Subarea.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subarea }
    end
  end

  # GET /subareas/1/edit
  def edit
    @subarea = Subarea.find(params[:id])
  end

  # POST /subareas
  # POST /subareas.json
  def create
    @subarea = Subarea.new(subarea_params)

    respond_to do |format|
      if @subarea.save
        format.html { redirect_to @subarea, notice: 'Subarea was successfully created.' }
        format.json { render json: @subarea, status: :created, location: @subarea }
      else
        format.html { render action: "new" }
        format.json { render json: @subarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subareas/1
  # PATCH/PUT /subareas/1.json
  def update
    @subarea = Subarea.find(params[:id])

    respond_to do |format|
      if @subarea.update_attributes(subarea_params)
        format.html { redirect_to @subarea, notice: 'Subarea was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subarea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subareas/1
  # DELETE /subareas/1.json
  def destroy
    @subarea = Subarea.find(params[:id])
    @subarea.destroy

    respond_to do |format|
      format.html { redirect_to subareas_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def subarea_params
      params.require(:subarea).permit(:type, :description, :number, :inps, :iops, :iow, :ii, :iapl, :nvcn, :iwth, :ipts, :isao, :luns, :imw, 
    :sno, :stdo, :yct, :xct, :azm, :fl, :fw, :angl, :wsa, :chl, :chd, :chs, :chn, :slp, :splg, :upn, :ffpq, :urbf, :soil_id, :bmp_id)
    end
end
