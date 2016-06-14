class BmpsController < ApplicationController
before_filter :take_names

  def take_names
	@project_name = Project.find(session[:project_id]).name
	@field_name = Field.find(session[:field_id]).field_name
	@scenario_name = Scenario.find(session[:scenario_id]).name      
  end

################################  BMPs list   #################################
  # GET /operations/1
  # GET /1/operations.json
  def list
    @bmps = Bmp.where(:scenario_id => params[:id])
		respond_to do |format|
		  format.html # list.html.erb
		  format.json { render json: @fields }
		end
  end
################################  INDEX  #################################
  # GET /bmps
  # GET /bmps.json
  def index
    @bmps = Bmp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmps }
    end
  end

################################  SHOW  #################################
  # GET /bmps/1
  # GET /bmps/1.json
  def show
    @bmp = Bmp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bmp }
    end
  end

################################  NEW  #################################
  # GET /bmps/new
  # GET /bmps/new.json
  def new
    @bmp = Bmp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bmp }
    end
  end

################################  EDIT  #################################
  # GET /bmps/1/edit
  def edit
    @bmp = Bmp.find(params[:id])
	@bmp_id = @bmp.bmp_id
  end

################################  CREATE  #################################
  # POST /bmps
  # POST /bmps.json
  def create
    @bmp = Bmp.new
	@bmp.scenario_id = session[:scenario_id]
	@bmp.bmpsublist_id = params[:bmp][:bmpsublist_id]
	@bmp.bmp_id = params[:bmp][:bmp_id]
	msg = tile_drain()
	respond_to do |format|
		if msg == "OK" 
			  if @bmp.save
				format.html { redirect_to @bmp, notice: 'Bmp was successfully created.' }
				format.json { render json: @bmp, status: :created, location: @bmp }
			  else
				format.html { render action: "new" }
				format.json { render json: @bmp.errors, status: :unprocessable_entity }
			  end
		else
			format.html { render action: "new" }
			format.json { render json: @bmp.errors, status: :unprocessable_entity }		
		end
	end
  end

################################  UPDATE  #################################
  # PATCH/PUT /bmps/1
  # PATCH/PUT /bmps/1.json
  def update
    @bmp = Bmp.find(params[:id])
    respond_to do |format|
      if @bmp.update_attributes(bmp_params)
        format.html { redirect_to @bmp, notice: 'Bmp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bmp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmps/1
  # DELETE /bmps/1.json
  def destroy
    @bmp = Bmp.find(params[:id])
    @bmp.destroy

    respond_to do |format|
      format.html { redirect_to list_bmp_path(session[:scenario_id]) }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bmp_params
      params.require(:bmp).permit(:scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth, 
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id)
    end

	def tile_drain
		item = Bmp.where(:bmpsublist_id => params[:bmp][:bmpsublist_id]).first
		
		input = params[:bmp][:depth]
            @bmp.depth = params[:depth].to_f

			@soils = Soil.where(:field_id => session[:field_id]) 
			@soils.each do |soil|
				subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
				if subarea != nil then
					subarea.idr = @bmp.depth * FT_TO_MM
					#if !subarea.save then return "Enable to save value in the subarea file" end
				end  #end if subarea !nil
			end # end soils.each
		return "OK"
    end # end method
end  # end class
