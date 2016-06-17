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
    @slope = 100
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
      when 1
        return autoirrigation(type)
      when 2
        return fertigation(type)
      when 3
        return tile_drain(type)
      when 4
        return ppds(type)
      when 5
        return ppde(type)
      when 6
        return pptw(type)
      when 7
	    return ppnd(type)
      when 9
        return pond(type)
      when 11
        return streambank_stabilization(type)
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

  ### ID: 1
  def autoirrigation(type)
    irrigation_fertigation(type)
  end # end method


  ### ID: 2
  def fertigation(type)
    irrigation_fertigation(type)
  end # end method
  

  ### ID: 3
  def tile_drain(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create" || "update"
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


  ### ID: 4
  def ppds(type)
    pads_pipes(type)
  end # end method


  ### ID: 5
  def ppde(type)
    pads_pipes(type)	
	create_subarea("PPDE", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(session[:field_id].field_area, @bmp.id))
  end # end method


  ### ID: 6
  def pptw(type)
    pads_pipes(type)
  end # end method


  ### ID: 7
  def ppnd (type)
    pads_pipes(type)
  end # end method


  ### ID: 9
  def pond(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create" || "update"
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

  ### ID: 11
  def streambank_stabilization(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
		if subarea != nil then
		  case type
		    when "create" || "update"
              subarea.pec = 0.85
			when "delete"
			  # TODO check values for deletion to see if other questions to set values may need to be asked
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


  ## USED FOR PADS AND PIPES FIELDS (ID: 4 - ID: 7)
  def pads_pipes(type)
      @soils = Soil.where(:field_id => session[:field_id])
	  i = 0
      @soils.each do |soil|
		if soil.selected
		session[:depth] = @slope
			if @slope > soil.slope then
				@slope = soil.slope
			end
		end
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  if i = 0 then 
			@inps = subarea.inps   #select the first soil, which is with bigest area
			i += 1
		  end
		  if soil.selected
			@iops = subarea.iops   #selected the last iops to inform the subarea the folowing iops to create.
		  end
		  
		  case type
            when "create" || "update"
              if @bmp.bmpsublist_id == 7
				subarea.pcof = 0.0
			  else
			    subarea.pcof = 0.5
		      end
            when "delete"
              subarea.pcof = 0.0
		  end # switch statement
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
		soil_ops = SoilOperation.where(:soil_id => soil.id, :scenario_id => session[:scenario_id], :activity_id => 1)
		soil_ops.each do |soil_op|
		  case type
            when "create" || 
              soil_op.opv2 = soil_op.opv2 * 0.9
            when "update"
              # TODO
            when "delete"
              soil_op.opv2 = soil_op.opv2 / 0.9 #return back to 100%
            else
		  end # switch statement
		end # end soil_ops.each
      end # end soils.each   
    return "OK"
  end # end method


  def irrigation_fertigation(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		  case type
            when "create" || "update"
              case @bmp.irrigation_id
			    when 1
				  subarea.nirr = 1.0
				when 2 || 7 || 8
				  subarea.nirr = 2.0
				when 3
				  subarea.nirr = 5.0
			  end
			  subarea.vimx = 5000
			  subarea.bir = 0.8
			  subarea.iri = @bmp.days
			  subarea.bir = @bmp.water_stress_factor
			  subarea.efi = 1 - @bmp.irrigation_efficiency
			  subarea.armx = @bmp.maximum_single_application * IN_TO_MM
			  subarea.fdsf = @bmp.safety_factor
			  if @bmp.bmpsublist_id == 2
			    subarea.idf4 = 1.0
				subarea.bft = 0.8
			  end
            when "delete"
		      subarea.nirr = 0.0
			  subarea.vimx = 0.0
			  subarea.bir = 0.0
			  subarea.armx = 0.0
			  subarea.iri = 0.0
			  subarea.bir = 0.0
			  subarea.efi = 0.0
			  subarea.armx = 0.0
			  subarea.fdsf = 0.0
			  if @bmp.bmpsublist_id == 2
			    subarea.idf4 = 0.0
				subarea.bft = 0.0
			  end
            else
		      # DO NOTHING
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
