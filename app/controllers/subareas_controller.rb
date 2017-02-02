class SubareasController < ApplicationController
  # GET /subareas
  # GET /subareas.json
  def index
    @field = Field.find(session[:field_id])
	  @soils = Soil.where(:field_id => session[:field_id], :selected => true)
	  if @soils != nil then
		  subarea = Subarea.where(:soil_id => @soils[0].id).first
		  if subarea != nil then
		    session[:scenario_id] = subarea.scenario_id
		  else
		    session[:scenario_id] = 0
		  end
	  else
		  session[:scenario_id] = 0
	  end
	  get_subareas()
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subareas }
    end
  end

  # GET /subareas/1
  # GET /subareas/1.json
  def show
    @subarea = Subarea.find(params[:id])
    @field = Field.find(session[:field_id])

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
    @field = Field.find(session[:field_id])
  end

  # POST /subareas
  # POST /subareas.json
  def create
    @soils = Soil.where(:field_id => session[:field_id], :selected => true)
    session[:scenario_id] = params[:subarea][:scenario_id]
	get_subareas()
    @field = Field.find(session[:field_id])
	  render "index"
  end

  # PATCH/PUT /subareas/1
  # PATCH/PUT /subareas/1.json
  def update
    @subarea = Subarea.find(params[:id])

    respond_to do |format|
      if @subarea.update_attributes(subarea_params)
        format.html { redirect_to subareas_path, notice: t('models.subarea') + " " + t('notices.updated')  }
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

  def get_subareas()
      @subareas = []
	  i=1
	  if session[:scenario_id] != 0 then
		  @soils.each do |soil|
			  #subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, session[:scenario_id])   #no needed because subarea depends on soil
			  @subareas.push(:subarea_type => soil.subareas.first.subarea_type, :subarea_number => i, :subarea_description => soil.subareas.first.description, :subarea_id => soil.subareas.first.id)
			  i+=1
		  end
	  end
	  subareas = Subarea.where("scenario_id = " + session[:scenario_id].to_s + " AND bmp_id > 0 AND soil_id = 0")
	  subareas.each do |subarea|
		  @subareas.push(:subarea_type => subarea.subarea_type, :subarea_number => i, :subarea_description => subarea.description, :subarea_id => subarea.id)
		  i+=1
	  end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def subarea_params
      params.require(:subarea).permit(:type, :description, :number, :inps, :iops, :iow, :ii, :iapl, :nvcn, :iwth, :ipts, :isao, :luns, :imw,
     :sno, :stdo, :yct, :xct, :azm, :fl, :fw, :angl, :wsa, :chl, :chd, :chs, :chn, :slp, :splg, :upn, :ffpq, :urbf, :soil_id, :bmp_id, :rchl,
	 :rchd, :rcbw, :rctw, :rchs, :rchn, :rchc, :rchk, :rfpw, :rfpl, :rsee, :rsae, :rsve, :rsep, :rsap, :rsvp, :rsv, :rsrr, :rsys, :rsyn,
	 :rshc, :rsdp, :rsbd, :pcof, :bcof, :bffl, :nirr, :iri, :ira, :lm, :ifd, :idr, :idf1, :idf2, :idf3, :idf4, :idf5, :bir, :efi, :vimx,
	 :armn, :armx, :bft, :fnp4, :fmx, :drt, :fdsf, :pec, :dalg, :vlgn, :coww, :ddlg, :solq, :sflg, :fnp2, :fnp5, :firg, :ny1, :ny2, :ny3,
	 :ny4, :ny5, :ny6, :ny7, :ny8, :ny9, :ny10, :xtp1, :xtp2, :xtp3, :xtp4, :xtp5, :xtp6, :xtp7, :xtp8, :xtp9, :xtp10 )
    end
end
