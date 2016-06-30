include ScenariosHelper
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
    @climate_array = create_hash()
    session[:climate_array] = @climate_array
    @bmp = Bmp.new
  	@animals = Fertilizer.where(:fertilizer_type_id => 2)
    session.delete(:subarea)

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
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    @climate_array = session[:climate_array]
  end

################################  CREATE  #################################
  # POST /bmps
  # POST /bmps.json
  def create
    @slope = 100
    @bmp = Bmp.new(bmp_params)
    @bmp.id = session[:bmp_id]
	  @bmp.scenario_id = session[:scenario_id]
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    @climate_array = session[:climate_array]

    respond_to do |format|
      if @bmp.save
        msg = input_fields("create")
        if msg == "OK"
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
	  @slope = 100
    @bmp = Bmp.find(params[:id])
    @bmp.id = session[:bmp_id]
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    @climates = Climate.where(:bmp_id => @bmp.id)
    @climate_array = session[:climate_array]

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
    @slope = 100
    @bmp = Bmp.find(params[:id])
	  msg = input_fields("delete")
    @bmp.destroy

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
        return ppnd(type)
      when 5
        return ppds(type)
      when 6
        return ppde(type)
      when 7
        return pptw(type)
      when 8
        return wetlands(type)
      when 9
        return pond(type)
      when 10
        return "OK"
      when 11
        return streambank_stabilization(type)
      when 12
        return riparian_forest(type)
      when 13
        return filter_strip(type)
      when 14
        return waterway(type)
      when 16
        return land_leveling(type)
      when 17
        return terrace_system(type)
      when 18
        # TODO
      when 19
        return create_climate(type)
      when 20
        return asphalt_concrete(type)
      when 21
        return grass_cover(type)
      when 22
        return slope_adjustment(type)
      when 23
        return shading(type)
      else
        return "OK"
    end
  end

  ########################### CLIMATE FUNCTIONS ########################### 

  def create_hash
    i = 0
    climate_array = Array.new
    while i < 12 do
      hash = Hash.new
      hash["max"] = 0.0
      hash["min"] = 0.0
      hash["pcp"] = 0.0
      climate_array.push(hash)
      i+=1
    end
    return climate_array
  end


  def update_hash(climate)
    hash = Hash.new
    hash["max"] = climate.max_temp
    hash["min"] = climate.min_temp
    hash["pcp"] = climate.precipitation / 100
    @climate_array.push(hash)
  end

  ####################### INDIVIDUAL SUBLIST ACTIONS #######################

  ### ID: 1
  def autoirrigation(type)
    return irrigation_fertigation(type)
  end # end method


  ### ID: 2
  def fertigation(type)
    return irrigation_fertigation(type)
  end # end method
  

  ### ID: 3
  def tile_drain(type)
    @soils = Soil.where(:field_id => session[:field_id]) 
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
      if subarea != nil then
      case type
          when "create", "update"
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
  def ppnd(type)
    return pads_pipes(type)
  end # end method


  ### ID: 5
  def ppds(type)
    return pads_pipes(type)
  end # end method


  ### ID: 6
  def ppde(type)
    msg = pads_pipes(type)    
    case type
      when "create"
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          create_subarea("PPDE", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(session[:field_id]).field_area, @bmp.bmp_id, @bmp.bmpsublist_id, false, "create")
        end
      when "update"
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          update_existing_subarea("PPDE")
        end
      when "delete"
        delete_existing_subarea("PPDE")
    end
    return msg
  end # end method


  ### ID: 7
  def pptw(type)
    return pads_pipes(type)
  end # end method


  ### ID: 8
  def wetlands(type)
    case type
      when "create"
        return create_new_subarea("WL", 8)
	    when "update"
        update_existing_subarea("WL", 8)
  	  when "delete"
        subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "WL").first
        update_wsa("-", subarea.wsa)
        #Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "PPDE").first.delete
  	end
  end # end method


  ### ID: 9
  def pond(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
		      case type
            when "create", "update"
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
		        when "create", "update"
              subarea.pec = 0.85
	      		when "delete"
	      		  # TODO check values for deletion to see if other questions to set values may need to be asked
	      	end
          #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  ### ID: 12
  def riparian_forest(type)
    case type
      when "create"
        return create_new_subarea("RFFS", 12)
      when "update"
        update_existing_subarea("RFFS", 12)
	    when "delete"
        subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "RF").first
        update_wsa("-", subarea.wsa)
        #Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "RF").first.delete
    end
  end


  ### ID: 13
  def filter_strip(type)
    case type
      when "create"
        return create_new_subarea("FS", 13)
      when "update"
        update_existing_subarea("FS", 13)
	    when "delete"
        subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "FS").first
        update_wsa("-", subarea.wsa)
        #Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "FS").first.delete
    end
  end # end method


  ### ID: 14
  def waterway(type)
    case type
      when "create"
        return create_new_subarea("WW", 14)
      when "update"
        update_existing_subarea("WW", 14)
      when "delete"
        subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "WW").first
        update_wsa("-", subarea.wsa)
        #Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "WW").first.delete
    end
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


  ### ID: 19
  def create_climate(type)
    case type
      when "create"
        i = 0
        @climate_array.clear
        while i < 12 do
          climate = Climate.new
          climate.bmp_id = session[:bmp_id]
          climate.month = i + 1
          climate.max_temp = 0.0
          climate.min_temp = 0.0
          climate.precipitation = 0.0
          edit_climate(climate, i + 1)
          update_hash(climate)
          i += 1
        end
      when "update"
        i = 0
        @climates = Climate.where(:bmp_id => session[:bmp_id])
        @climates.each do |climate|
          edit_climate(climate, i + 1)
          update_hash(climate)
          i += 1
        end
      end
    return "OK"
  end


  ### ID: 20
  def asphalt_concrete(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
          case type
            when "create", "update"
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
            when "create", "update"
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


  ### ID: 23
  def shading(type)
    case type
      when "create"
        return create_new_subarea("Sdg", 23)
      when "update"
        update_existing_subarea("Sdg", 23)
      when "delete"
        subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "Sdg").first
        update_wsa("-", subarea.wsa)
        #Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => "Sdg").first.delete
    end
  end # end method

  ################### METHODS FOR INDIVIDUAL SUBLIST ACTIONS ###################


  def edit_climate(climate, i)
    case i
      when 1
        climate.max_temp = params[:climate][:max_1] unless params[:climate][:max_1] == ""
        climate.min_temp = params[:climate][:min_1] unless params[:climate][:min_1] == ""
        climate.precipitation = params[:climate][:pcp_1] unless params[:climate][:pcp_1] == ""
        climate.save
      when 2
        climate.max_temp = params[:climate][:max_2] unless params[:climate][:max_2] == ""
        climate.min_temp = params[:climate][:min_2] unless params[:climate][:min_2] == ""
        climate.precipitation = params[:climate][:pcp_2] unless params[:climate][:pcp_2] == ""
        climate.save
      when 3
        climate.max_temp = params[:climate][:max_3] unless params[:climate][:max_3] == ""
        climate.min_temp = params[:climate][:min_3] unless params[:climate][:min_3] == ""
        climate.precipitation = params[:climate][:pcp_3] unless params[:climate][:pcp_3] == ""
        climate.save
      when 4
        climate.max_temp = params[:climate][:max_4] unless params[:climate][:max_4] == ""
        climate.min_temp = params[:climate][:min_4] unless params[:climate][:min_4] == ""
        climate.precipitation = params[:climate][:pcp_4] unless params[:climate][:pcp_4] == ""
        climate.save
      when 5
        climate.max_temp = params[:climate][:max_5] unless params[:climate][:max_5] == ""
        climate.min_temp = params[:climate][:min_5] unless params[:climate][:min_5] == ""
        climate.precipitation = params[:climate][:pcp_5] unless params[:climate][:pcp_5] == ""
        climate.save
      when 6
        climate.max_temp = params[:climate][:max_6] unless params[:climate][:max_6] == ""
        climate.min_temp = params[:climate][:min_6] unless params[:climate][:min_6] == ""
        climate.precipitation = params[:climate][:pcp_6] unless params[:climate][:pcp_6] == ""
        climate.save
      when 7
        climate.max_temp = params[:climate][:max_7] unless params[:climate][:max_7] == ""
        climate.min_temp = params[:climate][:min_7] unless params[:climate][:min_7] == ""
        climate.precipitation = params[:climate][:pcp_7] unless params[:climate][:pcp_7] == ""
        climate.save
      when 8
        climate.max_temp = params[:climate][:max_8] unless params[:climate][:max_8] == ""
        climate.min_temp = params[:climate][:min_8] unless params[:climate][:min_8] == ""
        climate.precipitation = params[:climate][:pcp_8] unless params[:climate][:pcp_8] == ""
        climate.save
      when 9
        climate.max_temp = params[:climate][:max_9] unless params[:climate][:max_9] == ""
        climate.min_temp = params[:climate][:min_9] unless params[:climate][:min_9] == ""
        climate.precipitation = params[:climate][:pcp_9] unless params[:climate][:pcp_9] == ""
        climate.save
      when 10
        climate.max_temp = params[:climate][:max_10] unless params[:climate][:max_10] == ""
        climate.min_temp = params[:climate][:min_10] unless params[:climate][:min_10] == ""
        climate.precipitation = params[:climate][:pcp_10] unless params[:climate][:pcp_10] == ""
        climate.save
      when 11
        climate.max_temp = params[:climate][:max_11] unless params[:climate][:max_11] == ""
        climate.min_temp = params[:climate][:min_11] unless params[:climate][:min_11] == ""
        climate.precipitation = params[:climate][:pcp_11] unless params[:climate][:pcp_11] == ""
        climate.save
      when 12
        climate.max_temp = params[:climate][:max_12] unless params[:climate][:max_12] == ""
        climate.min_temp = params[:climate][:min_12] unless params[:climate][:min_12] == ""
        climate.precipitation = params[:climate][:pcp_12] unless params[:climate][:pcp_12] == ""
        climate.save
    end
  end


  ## USED FOR TERRACE SYSTEM(ID: 17) AND FOR SLOP ADJUSTEMNT(ID: 22)
  def terrace_and_slope(type)
      @soils = Soil.where(:field_id => session[:field_id]) 
      @soils.each do |soil|
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => session[:scenario_id]).first
        if subarea != nil then
          case type
            when "create", "update"
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
            when "create", "update"
              if @bmp.bmpsublist_id == 4
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
            when "create"
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
            when "create", "update"
              case @bmp.irrigation_id
                when 1
                  subarea.nirr = 1.0
                when 2, 7, 8
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
              #DO NOTHING  
          end
            #if !subarea.save then return "Enable to save value in the subarea file" end
        end  #end if subarea !nil
      end # end soils.each
    return "OK"
  end # end method


  def create_new_subarea(name, id)
    is_filled = false
    case id
      when 8
        if @bmp.area != nil
          is_filled = true;
        end
      when 12
        if @bmp.area != nil && @bmp.width != nil && @bmp.grass_field_portion != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
      when 13
        if @bmp.area != nil && @bmp.width != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
      when 14
        if @bmp.width != nil
          is_filled = true;
        end
      when 23
        if @bmp.area != nil && @bmp.width != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
    end

    if is_filled
      @soils = Soil.where(:field_id => session[:field_id])
      i = 0
      #@inps = i
      @soils.each do |soil|
        if soil.selected
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
        end
      end
	  create_subarea(name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(session[:field_id]).field_area, @bmp.id, @bmp.bmpsublist_id, false, "create")
	  return "OK"
    else
      return "OK"
    end
  end

  def update_existing_subarea(name, id)
    is_filled = false
    case id
      when 8
        if @bmp.area != nil
          is_filled = true;
        end
      when 12
        if @bmp.area != nil && @bmp.width != nil && @bmp.grass_field_portion != nil && bmp.buffer_slope_upland != nil
          is_filled = true;
        end
      when 13
        if @bmp.area != nil && @bmp.width != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
      when 14
        if @bmp.width != nil
          is_filled = true;
        end
      when 23
        if @bmp.area != nil && @bmp.width != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
    end

    if is_filled
      @soils = Soil.where(:field_id => session[:field_id])
      i = 0
      @soils.each do |soil|
        if soil.selected
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
        end
      end
      subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => name).first
      update_wsa("-", subarea.wsa)
      update_subarea(subarea, name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(session[:field_id]).field_area, @bmp.bmp_id, @bmp.bmpsublist_id, false, "update")
      return "OK"
    else
      return "OK"
    end
  end

  def delete_existing_subarea(name)
    subarea = Subarea.where(:scenario_id => session[:scenario_id], :subarea_type => name).first
    update_wsa("-", subarea.wsa)
    #subarea.delete
  end

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
