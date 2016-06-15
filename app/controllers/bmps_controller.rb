
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
		  format.json { render json: @bmps }
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
    @bmp = Bmp.new(bmp_params)
	@bmp.scenario_id = session[:scenario_id]
	msg = input_fields("create")
	session[:depth] = msg
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

	msg = input_fields("update")

    respond_to do |format|
	  if msg == "OK"
        if @bmp.update_attributes(bmp_params)
          format.html { redirect_to @bmp, notice: 'Bmp was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @bmp.errors, status: :unprocessable_entity }
        end
	  end
    end
  end

  ################################  DESTROY  #################################

  # DELETE /bmps/1
  # DELETE /bmps/1.json
  def destroy
    @bmp = Bmp.find(params[:id])
    @bmp.destroy

	msg = input_fields("delete")

    respond_to do |format|
      format.html { redirect_to list_bmp_path(session[:scenario_id]) }
      format.json { head :no_content }
    end
  end

  ##############################  INPUT FIELDS  ###############################

  def input_fields(type)

	case @bmp.bmpsublist_id 
      when 3
        return tile_drain(type)
      when 9
        return pond(type)
      when 16
        return land_leveling(type)
      when 17
	    return terrace_system(type)
      when 20
        return asphalt_concrete(type)
      when 21
        return grass_cover(type)
      when 22
	    return slope_adjustment(type)
      else
        return "OK"
    end
  end


  ####################### INDIVIDUAL SUBLIST ACTIONS #######################

  ### ID: 3
  def tile_drain(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create"
              subarea.idr = @bmp.depth * FT_TO_MM
            when "update"
		      subarea.idr = @bmp.depth * FT_TO_MM
            when "delete"
		      subarea.idr = 0
            else
		      # DO NOTHING
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 9
  def pond(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create"
              subarea.pcof = @bmp.irrigation_efficiency
            when "update"
              subarea.pcof = @bmp.irrigation_efficiency
            when "delete"
              subarea.pcof = 0
            else
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 16
  def land_leveling(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create"
              subarea.slp = subarea.slp - (subarea.slp * (@bmp.slope_reduction / 100))
              session[:old_percentage] = @bmp.slope_reduction / 100
            when "update"
              subarea.slp = (subarea.slp / (1 - @old_percentage)) - (subarea.slp * (@bmp.slope_reduction / 100))
              session[:old_percentage] = @bmp.slope_reduction / 100
            when "delete"
              subarea.slp = subarea.slp / (1 - session[:old_percentage])
            else
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 17
  def terrace_system(type)
	terrace_and_slope(type)
  end


  ### ID: 20
  def asphalt_concrete(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
		if subarea != nil then
		  case type
		    when "create" || "update"
              if subarea.rchk > 0.01
                subarea.rchk = 0.01
				subarea.rchn = 0.05
				subarea.upn = 0.1
				subarea.pec = 0.05
              end
			when "delete"
			  # TODO check values for deletion to see if other questions to set values may need to be asked
			  subarea.rchk = 0.2
			  subarea.rchc = 0.2
			  subarea.upn = 0.2
			  subarea.pec = 1.0
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 21
  def grass_cover(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
		if subarea != nil then
		  case type
		    when "create" || "update"
              if subarea.rchc > 0.01
                subarea.rchc = 0.01
				subarea.upn = 0.4
				subarea.pec = 0.1
              end
			when "delete"
			  # TODO check values for deletion to see if other questions to set values may need to be asked
			  subarea.rchc = 0.2
			  subarea.upn = 0.2
			  subarea.pec = 1.0
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 22
  def slope_adjustment(type)
	terrace_and_slope(type)
  end

  ################### METHODS FOR INDIVIDUAL SUBLIST ACTIONS ###################

  ## USED FOR TERRACE SYSTEM(ID: 17) AND FOR SLOP ADJUSTEMNT(ID: 22)
  def terrace_and_slope(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
		if subarea != nil then
		  case type
		    when "create" || "update"
              case subarea.slp
                when 0..0.02
                  subarea.pec = 0.6
                when 0.021..0.08
                  subarea.pec = 0.5
                when 0.081..0.12
                  subarea.pec = 0.6
                when 0.121..0.16
                  subarea.pec = 0.7
                when 0.161..0.20
                  subarea.pec = 0.8
                when 0.201..0.25
                  subarea.pec = 0.9 
                else
                  subarea.pec = 1.0
              end
			when "delete"
			  # TODO check values for deletion to see if other questions to set values may need to be asked
			  subarea.pec = 1.0
		  end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ##############################  PRIVATE  ###############################

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bmp_params
      params.require(:bmp).permit(:scenario_id, :bmp_id, :crop_id, :irrigation_id, :water_stress_factor, :irrigation_efficiency, :maximum_single_application, :safety_factor, :depth, 
	         :area, :number_of_animals, :days, :hours, :animal_id, :dry_manure, :no3_n, :po4_p, :org_n, :org_p, :width, :grass_field_portion, :buffer_slope_upland, :crop_width,
			 :slope_reduction, :sides, :bmpsublist_id)
    end
end  # end class
