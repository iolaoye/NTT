class SubareasController < ApplicationController
  # GET /subareas
  # GET /subareas.json
  def index
	soils = Soil.where(:field_id => session[:field_id], :selected => true)
	if soils != nil then
		subarea = Subarea.where(:soil_id => soils[0].id).first
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
    session[:scenario_id] = params[:subarea][:scenario_id]
	get_subareas()
	render "index"
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

  def get_subareas()
    @subareas = []
	soils = Soil.where(:field_id => session[:field_id], :selected => true)
	i=1
	if session[:scenario_id] != 0 then
		soils.each do |soil|
			subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, session[:scenario_id])
			@subareas.push(:subarea_type => subarea.subarea_type, :subarea_number => i, :subarea_description => subarea.description, :subarea_id => subarea.id)
			#@subareas.push(Subarea.find_by_soil_id_and_scenario_id(soil.id, session[:scenario_id]).description)
			i+=1
		end
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
