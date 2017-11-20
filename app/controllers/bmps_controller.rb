include ScenariosHelper
class BmpsController < ApplicationController
  before_filter :take_names

  def take_names
    @project_name = Project.find(params[:project_id]).name
	  @field = Field.find(params[:field_id])
    @field_name = @field.field_name
    @scenario_name = Scenario.find(params[:scenario_id]).name
	  @field_type = @field.field_type
  end

################################  BMPs list   #################################
# GET /operations/1
# GET /1/operations.json
  def list
    get_bmps()
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmps }
    end
  end

################################  INDEX  #################################
# GET /bmps
# GET /bmps.json
  def index
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  	if @project.location.state_id == 25 || @project.location.state_id == 26 then
  		@irrigations = Irrigation.all
  	else
  		@irrigations = Irrigation.where("id < 8")
  	end
    add_breadcrumb t('menu.bmps')

    get_bmps()
	  #take_names()
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmps }
    end
  end

################################  Get CURRENT BMPS #########################
  def get_bmps
    bmpsublists = Bmpsublist.where(:status => true)
    @bmps = Bmp.where(:bmpsublist_id => 0)
    @bmps[0] = Bmp.new
	  @climates = Climate.where(:id => 0)

  	bmpsublists.each do |bmpsublist|
  		bmp = Bmp.find_by_scenario_id_and_bmpsublist_id(params[:scenario_id], bmpsublist.id)
  		if bmp.blank? || bmp == nil then
  			bmp = Bmp.new
  			bmp.bmpsublist_id = bmpsublist.id
  			case bmp.bmpsublist_id
  			  when 1  #autoirrigation/autofertigation - defaults
    				bmp.water_stress_factor = 0.80
    				bmp.days = 14
    				bmp.irrigation_efficiency = 0
            bmp.maximum_single_application = 3
  			end
  		end
  		@bmps[bmp.bmpsublist_id-1] = bmp
  		if bmp.bmpsublist_id == 21 then #climate change - create 12 rows to store pcp, min tepm, and max temp for changes during all years.
  			climates = Climate.where(:bmp_id => bmp.id)
  			i=0
  			for i in 0..11
  				if climates.blank? || climates == nil then
  					@climates[i] = Climate.new
  					@climates[i].month = i + 1
  					@climates[i].max_temp = 0
  					@climates[i].min_temp = 0
  					@climates[i].precipitation = 0
  				else
  					@climates[i] = climates[i]
  				end
  			end
  		end
  		bmp_list = 18
      if bmp.bmpsublist_id == 19 then   # cover crop. This BMP is not active any more. In case we need bmp.bmpsublist_id greater than 19 changes to bmpsublist table need to be done or to the @bmps active record.
        if bmp.id == nil then
          operation = @scenario.operations.where(:activity_id => 5).last
          if operation != nil then
            @year = operation.year
            @month = operation.month_id
            @day = operation.day
            cc_plt_date = Date.parse(sprintf("%2d", @year) + "/" + sprintf("%2d", @month) + "/" + sprintf("%2d", @day))
            cc_plt_date += 2.days
            @year = cc_plt_date.year - 2000
            @month = cc_plt_date.month
            @day = cc_plt_date.day
          end
        else
          @year = bmp.number_of_animals
          @month = bmp.hours
          @day = bmp.days
        end
      end
  		#if @field_type != false then
  			#bmp_list = 20
  		#end
  		if bmp.bmpsublist_id == bmp_list then
  			break
  		end
  	end
  end

################################  save BMPS  #################################
# POST /bmps/scenario
  def save_bmps
    #@project = Project.find(params[:project_id])
    #@field = Field.find(params[:field_id])
    #@scenario = Scenario.find(params[:scenario_id])
	  if params[:button] == t('submit.savecontinue')
  		@slope = 100
  		#take the Bmps that already exist for that scenario and then delete them and any other information related one by one.
  		bmps = Bmp.where(:scenario_id => params[:scenario_id])
  		bmps.each do |bmp|
  			@bmp = bmp
  			msg = input_fields("delete")
  			if msg == "OK" then
  				bmp.destroy
  			end
  		end  # bmps.each
  		#Bmp.where(:scenario_id => params[:scenario_id]).delete_all  #delete all of the bmps for this scenario and then create the new ones that have information.
  		if !(params[:bmp_ai][:irrigation_id] == "") then
  			if !(params[:bmp_cb1] == nil)
  				if params[:bmp_cb1] == "1" then
  					create(1)   #autoirrigation
  				end
  				if params[:bmp_cb1] == "2" then
  					create(1)   #autofertigation
  				end
  			end
  		end
  		if !(params[:bmp_td][:depth] == "") then
  			create(3)
  		end
  	 	if !(params[:bmp_ppnd] == nil)  # when this is hidden because it is not MO, MS states
    			if !(params[:bmp_ppnd][:width] == "") then
    				if params[:bmp_cb2] == "4" then
    					create(4)
    				end
    				if params[:bmp_cb2] == "5" then
    					create(4)
    				end
    				if params[:bmp_cb2] == "6" then
    					create(4)
    				end
    				if params[:bmp_cb2] == "7" then
    					create(4)
    				end
    			end
  		end
    		#if !(params[:bmp_ppds][:width] == "") then
  			#create(5)
  		#end
  		#if !(params[:bmp_ppde][:width] == "") then
  		#	create(6)
  		#end
  		#if !(params[:bmp_pptw][:width] == "") then
  		#	create(7)
  		#end
  		if !(params[:bmp_wl][:area] == "") then
  			create(8)
  		end
		  # =>  pond
  		if params.has_key?(:select) && !params[:select][:"9"].nil? then
  			create(9)
  		end
		  #stream fencing
		  if params.has_key?(:select) && !params[:select][:"10"].nil? then
  		#if !(params[:bmp_sf][:number_of_animals] == "") then
  			create(10)
  		end
  		if !(params[:bmp_sbs] == nil)
  			if params[:bmp_sbs][:id] == "1" then
  				create(11)
  			end
  		end
		  #filter strip and riparian forest
  		if !(params[:bmp_fs][:width] == "") then
  			if !(params[:bmp_cb3] == nil)
  				if params[:bmp_cb3] == "12" then
  					create(13)   #riparian forest
  				end
  				if params[:bmp_cb3] == "13" then
  					create(13)   #filter strip
  				end
  			end
  		end
  		if !(params[:bmp_ww][:width] == "") then
  			create(14)
  		end
  		if !(params[:bmp_cb][:width] == "") then
  			create(15)
  		end
  		if !(params[:bmp_ll][:slope_reduction] == "") then
  			create(16)
  		end
  		if params.has_key?(:select) && !params[:select][:"17"].nil? then
  			create(17)
  		end
		  if !(params[:bmp_mc] == nil) # when this is hidden because there is not manure application
  			if !(params[:bmp_mc][:animal_id] == "") && !(params[:bmp_mc][:animal_id] == nil) then
  				create(18)
  			end
		  end
      if params.has_key?(:select) && !params[:select][:"19"].nil? then
      #cover crop (bmp_ccr)
        create(19)
      end
      if params.has_key?(:select) && !params[:select][:"20"].nil? then
      #rotational grazing (bmp_rg)
        create(20)
      end
  		if !(params[:select] == nil) and params[:select][:"21"] == "1" then
  			create(21)
  		end
      #flash[:error] = @bmp.errors.to_a
  		redirect_to project_field_scenarios_path(@project, @field)
	  else
		    redirect_to scenarios_path
	  end # end if params[:button]
  end  # end method
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
    @bmp = Bmp.new
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    #@irrigation = Irrigation.arel_table
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    #@type = "create"
    if Field.find(params[:field_id]).field_type
      @bmp_list = Bmplist.where(:id => 8)
    else
      @bmp_list = Bmplist.all
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bmp }
    end
  end  # end method

################################  EDIT  #################################
# GET /bmps/1/edit
  def edit
	@type = "Edit"
    if Field.find(params[:field_id]).field_type
      @bmp_list = Bmplist.all
    else
      @bmp_list = Bmplist.where('id != 8')
    end
    @bmp = Bmp.find(params[:id])
    @bmp_id = @bmp.bmp_id
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    #@irrigation = Irrigation.arel_table
    @climates = Climate.where(:bmp_id => @bmp.id)
    @climate_array = create_hash()
    if @bmp.bmpsublist_id == 21
      @climate_array = populate_array(@climates, @climate_array)
    end
    @bmp_group = Bmplist.where(:id => @bmp.bmp_id).first.name.to_s
    @bmp_selection = Bmpsublist.where(:id => @bmp.bmpsublist_id).first.name.to_s
  end  # end method

################################  CREATE  #################################
# POST /bmps
# POST /bmps.json
  def create(bmpsublist)
    @bmplist_name = "create"
    @bmpsublist_name = "create"
    msg = "OK"
    @bmp = Bmp.new()
    @bmp.scenario_id = params[:scenario_id]
    @bmp.bmpsublist_id = bmpsublist
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    #@irrigation = Irrigation.arel_table
    @climate_array = create_hash()
    @state = Location.find(Location.find_by_project_id(@project.id)).state_id
    msg = input_fields("create")
    if msg == "OK" then
      if @bmp.save then
    	 #sss
      else
    	 #nsnsns
      end
    end
    if !(params[:select] == nil) && params[:select][:"21"] == "1" && bmpsublist == 21 then
    	create_climate("create")
    end
    if msg == "OK" then
       if !@bmp.save then return "Error saving BMP" end
    end #if msg == OK
  end  # end method

################################  UPDATE  #################################
# PATCH/PUT /bmps/1
# PATCH/PUT /bmps/1.json
  def update
    @slope = 100
    @bmp = Bmp.find(params[:id])
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    @climates = Climate.where(:bmp_id => @bmp.id)
    #@irrigation = Irrigation.arel_table
    @climate_array = create_hash()
    if @bmp.bmpsublist_id == 21
      @climate_array = populate_array(@climates, @climate_array)
    end

    msg = input_fields("update")

    respond_to do |format|
      if msg == "OK"
        if @bmp.update_attributes(bmp_params)
          format.html { redirect_to list_bmp_path(params[:scenario_id]), notice: t('operation.bmp') + " " + t('general.updated') }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @bmp.errors, status: :unprocessable_entity }
        end
      else
        @climate_array = populate_array(@climates, @climate_array)
        @bmp.errors.add(msg[0], msg[1])
        format.html { render action: "edit" }
        format.json { render json: @bmp.errors, status: :unprocessable_entity }
      end
    end
  end  # end method

################################  DESTROY  #################################

# DELETE /bmps/1
# DELETE /bmps/1.json
  def destroy()
    @slope = 100
    Bmp.where(:scenario_id => params[:scenario_id]).delete_all

    msg = input_fields("delete")
    if @bmp.destroy
      flash[:notice] = t('models.bmp') + " " + Bmpsublist.find(@bmp.bmpsublist_id).name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to list_bmp_path(params[:scenario_id]) }
      format.json { head :no_content }
    end
  end  # end method

##############################  INPUT FIELDS  ###############################

  def input_fields(type)
    case @bmp.bmpsublist_id
      when 1
        return autoirrigation(type)
      #when 2
      #  return fertigation(type)
      when 3
        return tile_drain(type)
      when 4
        return ppnd(type)
      #when 5
      #  return ppds(type)
      #when 6
      #  return ppde(type)
      #when 7
      #  return pptw(type)
      when 8
        return wetlands(type)
      when 9
        return pond(type)
      when 10
        return stream_fencing(type)
      when 11
        return streambank_stabilization(type)
      #when 12
      #  return riparian_forest(type)
      when 13
        return filter_strip(type)
      when 14
        return waterway(type)
      when 16
        return land_leveling(type)
      when 17
        return terrace_system(type)
      when 18
        return manure_control(type)
      when 19
        return cover_crop(type)
      when 20
        return rotational_grazing(type)
      when 21
        return climate_change(type)
      when 22
        return asphalt_concrete(type)
      when 23
        return grass_cover(type)
      when 24
        return slope_adjustment(type)
      when 25
        return shading(type)
      else
        return "OK"
    end
  end  # end method

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
  end  # end method


  def update_hash(climate, climate_array)
    hash = Hash.new
    hash["max"] = climate.max_temp
    hash["min"] = climate.min_temp
    hash["pcp"] = climate.precipitation
    climate_array.push(hash)
    return climate_array
  end


  def populate_array(climates, climate_array)
    climate_array.clear
    climates.each do |climate|
      climate_array = update_hash(climate, climate_array)
    end
    return climate_array
  end  # end method

  def add_climate_id(id)
    climates = Climate.where(:bmp_id => nil)
    climates.each do |climate|
      climate.bmp_id = id
      climate.save
    end
  end  # end method

####################### INDIVIDUAL SUBLIST ACTIONS #######################
### ID: 1
  def autoirrigation(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = soil.subareas.find_by_scenario_id(params[:scenario_id])
      if subarea != nil then
        case type
          when "create", "update"
  		      @bmp.irrigation_id = params[:bmp_ai][:irrigation_id]
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
            subarea.iri = params[:bmp_ai][:days]
			      @bmp.days = subarea.iri
            subarea.bir = params[:bmp_ai][:water_stress_factor]
			      subarea.bir /= 100
			      @bmp.water_stress_factor = subarea.bir
            subarea.efi = 1.0 - (params[:bmp_ai][:irrigation_efficiency].to_f / 100)
			      @bmp.irrigation_efficiency = subarea.efi
            subarea.armx = params[:bmp_ai][:maximum_single_application].to_f * IN_TO_MM
  		      @bmp.maximum_single_application = params[:bmp_ai][:maximum_single_application].to_f
      		  subarea.fdsf = 0
      		  @bmp.depth = params[:bmp_cb1]
        		if params[:bmp_ai][:safety_factor] == nil then
        			subarea.fdsf = 0
        		else
        			subarea.fdsf = params[:bmp_ai][:safety_factor]
        		end
        		@bmp.safety_factor = subarea.fdsf
        		if @bmp.depth == 1 then
        			subarea.idf4 = 0.0
        			subarea.bft = 0.0
        		else
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
			  end   # end case type
        if !subarea.save then
  			   return "Unable to save value in the subarea file"
  		  end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end  # end method

### ID: 2
  def fertigation(type)
    fff
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, params[:scenario_id])
      if subarea != nil then
        case type
          when "create", "update"
			@bmp.irrigation_id = params[:bmp_ai][:irrigation_id]
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
            subarea.iri = params[:bmp_ai][:days]
			@bmp.days = subarea.iri
            subarea.bir = params[:bmp_ai][:water_stress_factor]
			@bmp.water_stress_factor = subarea.bir
            subarea.efi = 1.0 - params[:bmp_ai][:irrigation_efficiency].to_f
			@bmp.irrigation_efficiency = params[:bmp_ai][:irrigation_efficiency].to_f
            subarea.armx = params[:bmp_ai][:maximum_single_application].to_f * IN_TO_MM
			@bmp.maximum_single_application = params[:bmp_ai][:maximum_single_application].to_f
			subarea.fdsf = 0
			@bmp.depth = params[:bmp_cb1]
			if params[:bmp_ai][:safety_factor] == nil then
				subarea.fdsf = 0
			else
				subarea.fdsf = params[:bmp_ai][:safety_factor]
			end
			@bmp.safety_factor = subarea.fdsf
            subarea.idf4 = 1.0
            subarea.bft = 0.8
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
        end
        if !subarea.save then return "Unable to save value in the subarea file" end
	  end #end if subarea !nil
    end # end soils.each
    return "OK"
  end # end method

### ID: 3
  def tile_drain(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
            subarea.idr = params[:bmp_td][:depth].to_f * FT_TO_MM
			@bmp.depth = params[:bmp_td][:depth]
			subarea.drt = 2
          when "delete"
            subarea.idr = 0
			subarea.drt = 0
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end # end method

### ID: 4
  def ppnd(type)
	if type == "create" then
		pad_and_pipe = params[:bmp_cb2].to_i
	else
		pad_and_pipe = @bmp.depth
	end
    case pad_and_pipe
      when 4, 5
        @bmp.width = params[:bmp_ppnd][:width]
        @bmp.sides = params[:bmp_ppnd][:sides]
        @bmp.area = 0
		@bmp.depth = params[:bmp_cb2]
      when 6
        ppde(type)
      when 7
        pptw(type)
    end
    return pads_pipes(type)
  end    # end method


### ID: 5
  def ppds(type)
    @bmp.width = params[:bmp_ppnd][:width]
    @bmp.sides = params[:bmp_ppnd][:sides]
    @bmp.area = 0
    @bmp.depth = params[:bmp_cb2]
    return pads_pipes(type)
  end   # end method


### ID: 6
  def ppde(type)
    case type
      when "create"
		@bmp.width = params[:bmp_ppnd][:width]
		@bmp.sides = params[:bmp_ppnd][:sides]
		@bmp.area = params[:bmp_ppnd][:area]
		@bmp.depth = params[:bmp_cb2]
		@bmp.save
		msg = pads_pipes(type)
		@iops = @field.soils.count
		@inps = @field.soils.count
        #@iops = subarea.iops + 1 #selected the last iops to inform the subarea the folowing iops to create.
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          create_subarea("PPDE", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(params[:field_id]).field_area, @bmp.id, @bmp.depth, false, "create")
        end
      when "update"
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          update_existing_subarea("PPDE")
        end
      when "delete"
        delete_existing_subarea("PPDE")
    end
    #return msg
  end   # end method


### ID: 7
  def pptw(type)
    case type
      when "create"
		  @bmp.width = params[:bmp_ppnd][:width]
		  @bmp.sides = params[:bmp_ppnd][:sides]
		  @bmp.area = params[:bmp_ppnd][:area]
		  @bmp.depth = params[:bmp_cb2]
		  @iops = @field.soils.count
		  @inps = @field.soils.count
		  if @bmp.save then
			  msg = pads_pipes(type)
			  if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
				create_subarea("PPTW", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(params[:field_id]).field_area, @bmp.id, @bmp.depth, false, "create")
			  end
		  else
			return "Error saving BMP"
		  end
      when "update"
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          update_existing_subarea("PPTW")
        end
      when "delete"
        delete_existing_subarea("PPTW")
    end
    #return pads_pipes(type)
  end   # end method


### ID: 8
  def wetlands(type)
    case type
      when "create"
		@bmp.area = params[:bmp_wl][:area]
		if params[:bmp_wl][:buffer_land] == nil then
			@bmp.sides = 0
		else
			@bmp.sides = 1
		end
		if @bmp.save then
			return create_new_subarea("WL", 8)
		end
      when "update"
        update_existing_subarea("WL", 8)
      when "delete"
	    return delete_existing_subarea("WL")
    end
  end   # end method

### ID: 9
  def pond(type)
  	@bmp.irrigation_efficiency = params[:bmp_pnd][:irrigation_efficiency].to_f / 100
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
            subarea.pcof = @bmp.irrigation_efficiency
          when "delete"
            subarea.pcof = 0
          else
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end     # end method

  ### ID: 10
  def stream_fencing(type)
  	@bmp.number_of_animals = params[:bmp_sf][:number_of_animals]
  	@bmp.days = params[:bmp_sf][:days]
  	@bmp.hours = params[:bmp_sf][:hours]
  	@bmp.animal_id = params[:bmp_sf][:animal_id]
  	@bmp.dry_manure = params[:bmp_sf][:dry_manure]
  	@bmp.no3_n = params[:bmp_sf][:no3_n]
  	@bmp.po4_p = params[:bmp_sf][:po4_p]
  	@bmp.org_n = params[:bmp_sf][:org_n]
  	@bmp.org_p = params[:bmp_sf][:org_p]
  	return "OK"
  end

### ID: 11
  def streambank_stabilization(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
            subarea.pec = 0.85
          when "delete"
            subarea.pec = 1
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end    # end method

### ID: 12
  def riparian_forest(type)
    case type
      when "create"
    		@bmp.area = params[:bmp_fs][:area]
    		@bmp.width = params[:bmp_fs][:width]
    		@bmp.grass_field_portion = params[:bmp_fs][:grass_field_portion]
    		@bmp.buffer_slope_upland = params[:bmp_fs][:buffer_slope_upland]
    		@bmp.crop_id = 1 #record not found error
			if params[:bmp_fs][:buffer_land] == nil then
				@bmp.sides = 0
			else
				@bmp.sides = 1
			end
    		@bmp.depth = params[:bmp_cb3]
    		if @bmp.save then
  			  return create_new_subarea("RF", 12)
		    end
      when "update"
        update_existing_subarea("RFFS", 12)
      when "delete"
	      delete_existing_subarea("RF")
        return delete_existing_subarea("RFFS")
      end
  end  # end riparian forest


### ID: 13
  def filter_strip(type)
    case type
      when "create"
    		@bmp.area = params[:bmp_fs][:area]
    		@bmp.width = params[:bmp_fs][:width]
    		@bmp.buffer_slope_upland = params[:bmp_fs][:buffer_slope_upland]
    		@bmp.grass_field_portion = params[:bmp_fs][:grass_field_portion]
        @bmp.slope_reduction = params[:bmp_fs][:floodplain_flow]
    		@bmp.crop_id = params[:bmp_fs][:crop_id]
    		if params[:bmp_fs][:buffer_land] == nil then
    			@bmp.sides = 0
    		else
    			@bmp.sides = 1
    		end
    		@bmp.depth = params[:bmp_cb3]
        if @bmp.depth == 12 then
          @bmp.crop_id = 1
        else
          @bmp.grass_field_portion = 0.00
        end
    		if @bmp.area == 0 || @bmp.area == nil then
    			length = Math.sqrt(@field.field_area)			# find the length of the field
    			width = (@bmp.width + @bmp.grass_field_portion) * FT_TO_KM			# convert width from ft to km
    			@bmp.area = (length * width / AC_TO_KM2).round(2)	# calculate area in km and convert to ac
    		end
      	if @bmp.save then
    			if @bmp.depth == 13 then
    				return create_new_subarea("FS", 13)
    			else
    				return create_new_subarea("RF", 12)
    			end
    		end
      when "update"
    		if params[:bmp_cb1] == "13" then
    		    update_existing_subarea("FS", 13)
    		else
    			update_existing_subarea("RFFS", 12)
    		end
      when "delete"
    		if @bmp.depth == 13 then
    			return delete_existing_subarea("FS")
    		else
    			delete_existing_subarea("RF")
    			return delete_existing_subarea("RFFS")
    		end
    end   # end case
  end   # end method


### ID: 14
  def waterway(type)
    case type
      when "create"
		    @bmp.width = params[:bmp_ww][:width]
		    @bmp.crop_id = params[:bmp_ww][:crop_id]
        @bmp.slope_reduction = params[:bmp_ww][:floodplain_flow]
        @bmp.area = 0
  		  if @bmp.save then
	        return create_new_subarea("WW", 14)
		    end
      when "update"
        update_existing_subarea("WW", 14)
      when "delete"
	      return delete_existing_subarea("WW")
    end
  end    # end method waterway


### ID: 16
  def land_leveling(type)
	@bmp.slope_reduction = params[:bmp_ll][:slope_reduction]
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
      if subarea != nil then
        case type
          when "create"
            subarea.slp = subarea.slp - (subarea.slp * (@bmp.slope_reduction / 100))
            session[:old_percentage] = params[:bmp_ll][:slope_reduction].to_f / 100
          when "update"
            subarea.slp = (subarea.slp / (1 - @old_percentage)) - (subarea.slp * (@bmp.slope_reduction / 100))
            session[:old_percentage] = @bmp.slope_reduction / 100
          when "delete"
            subarea.slp = subarea.slp / (1 - session[:old_percentage])
          else
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end   # end method

### ID: 17
  def terrace_system(type)
    terrace_and_slope(type)
  end

### ID: 18
  def manure_control(type)
  	@bmp.animal_id = params[:bmp_mc][:animal_id]
  	@bmp.no3_n =params[:bmp_mc][:no3_n]
  	@bmp.po4_p =params[:bmp_mc][:po4_p]
  	@bmp.org_n =params[:bmp_mc][:no3_n]
  	@bmp.org_p =params[:bmp_mc][:po4_p]
    return "OK"
  end   # end method

### ID: 19
  def cover_crop(type)
    if type == "delete" then return "OK" end
    @bmp.crop_id = params[:bmp_ccr][:crop_id]
    @bmp.number_of_animals = params[:bmp_ccr][:year]
    @bmp.hours = params[:bmp_ccr][:month]
    @bmp.days = params[:bmp_ccr][:day]
    @bmp.irrigation_id = params[:bmp_ccr][:type_id]
    return "OK"
  end   # end method

### ID: 20 
  def rotational_grazing(type)
    @bmp.animal_id = params[:bmp_rg][:animal_id]
    @bmp.number_of_animals = params[:bmp_rg][:number_of_animals]
    @bmp.sides = params[:bmp_rg][:year]
    @bmp.irrigation_id = params[:bmp_rg][:year_to]
    @bmp.org_n = params[:bmp_rg][:month]
    @bmp.org_p = params[:bmp_rg][:month_to]
    @bmp.no3_n = params[:bmp_rg][:day]
    @bmp.po4_p = params[:bmp_rg][:day_to]
    @bmp.hours = params[:bmp_rg][:hours_grazed]
    @bmp.days = params[:bmp_rg][:days_grazed]
    @bmp.area = params[:bmp_rg][:rest_time]
    return "OK"
  end
### ID: 21
  def climate_change(type)
	return "OK"
	#@bmp.bmp = params[:bmp_mc][:animal_id]
  end

### ID: 22
  def create_climate(type)
    bmp_id = Bmp.find_by_bmpsublist_id(19).id
  	for i in 1..12
  		climate = Climate.new
  		climate.bmp_id = bmp_id
  		climate.month = i
  		climate.max_temp = params[:bmp_cc]["max_temp" + i.to_s]
  		climate.min_temp = params[:bmp_cc]["min_temp" + i.to_s]
  		climate.precipitation = params[:bmp_cc]["precipitation" + i.to_s]
  		climate.save
  	end
    return "OK"
  end


### ID: 23
  def asphalt_concrete(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
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
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end

  # end method

### ID: 24
  def grass_cover(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
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
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end

  # end method

### ID: 22
  def slope_adjustment(type)
    terrace_and_slope(type)
  end


### ID: 23
  def shading(type)
    case type
      when "create"
		@bmp.area = params[:bmp_fs][:area]
		@bmp.width = params[:bmp_fs][:width]
		@bmp.buffer_slope_upland = params[:bmp_fs][:buffer_slope_upland]
		@bmp.crop_id = params[:bmp_fs][:crop_id]
		@bmp.depth = params[:bmp_cb1]
        return create_new_subarea("Sdg", 23)
      when "update"
        update_existing_subarea("Sdg", 23)
      when "delete"
        subarea = Subarea.where(:scenario_id => params[:scenario_id], :subarea_type => "Sdg").first
        update_wsa("+", subarea.wsa)
      #Subarea.where(:scenario_id => params[:scenario_id], :subarea_type => "Sdg").first.delete
    end
  end  # end method

################### METHODS FOR INDIVIDUAL SUBLIST ACTIONS ###################
  def edit_climate(climate, i)
    case i
      when 1
        climate.max_temp = params[:climate][:max_1] unless params[:climate][:max_1] == ""
        climate.save
        climate.min_temp = params[:climate][:min_1] unless params[:climate][:min_1] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_1] unless params[:climate][:pcp_1] == ""
        climate.save
      when 2
        climate.max_temp = params[:climate][:max_2] unless params[:climate][:max_2] == ""
        climate.save
        climate.min_temp = params[:climate][:min_2] unless params[:climate][:min_2] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_2] unless params[:climate][:pcp_2] == ""
        climate.save
      when 3
        climate.max_temp = params[:climate][:max_3] unless params[:climate][:max_3] == ""
        climate.save
        climate.min_temp = params[:climate][:min_3] unless params[:climate][:min_3] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_3] unless params[:climate][:pcp_3] == ""
        climate.save
      when 4
        climate.max_temp = params[:climate][:max_4] unless params[:climate][:max_4] == ""
        climate.save
        climate.min_temp = params[:climate][:min_4] unless params[:climate][:min_4] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_4] unless params[:climate][:pcp_4] == ""
        climate.save
      when 5
        climate.max_temp = params[:climate][:max_5] unless params[:climate][:max_5] == ""
        climate.save
        climate.min_temp = params[:climate][:min_5] unless params[:climate][:min_5] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_5] unless params[:climate][:pcp_5] == ""
        climate.save
      when 6
        climate.max_temp = params[:climate][:max_6] unless params[:climate][:max_6] == ""
        climate.save
        climate.min_temp = params[:climate][:min_6] unless params[:climate][:min_6] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_6] unless params[:climate][:pcp_6] == ""
        climate.save
      when 7
        climate.max_temp = params[:climate][:max_7] unless params[:climate][:max_7] == ""
        climate.save
        climate.min_temp = params[:climate][:min_7] unless params[:climate][:min_7] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_7] unless params[:climate][:pcp_7] == ""
        climate.save
      when 8
        climate.max_temp = params[:climate][:max_8] unless params[:climate][:max_8] == ""
        climate.save
        climate.min_temp = params[:climate][:min_8] unless params[:climate][:min_8] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_8] unless params[:climate][:pcp_8] == ""
        climate.save
      when 9
        climate.max_temp = params[:climate][:max_9] unless params[:climate][:max_9] == ""
        climate.save
        climate.min_temp = params[:climate][:min_9] unless params[:climate][:min_9] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_9] unless params[:climate][:pcp_9] == ""
        climate.save
      when 10
        climate.max_temp = params[:climate][:max_10] unless params[:climate][:max_10] == ""
        climate.save
        climate.min_temp = params[:climate][:min_10] unless params[:climate][:min_10] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_10] unless params[:climate][:pcp_10] == ""
        climate.save
      when 11
        climate.max_temp = params[:climate][:max_11] unless params[:climate][:max_11] == ""
        climate.save
        climate.min_temp = params[:climate][:min_11] unless params[:climate][:min_11] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_11] unless params[:climate][:pcp_11] == ""
        climate.save
      when 12
        climate.max_temp = params[:climate][:max_12] unless params[:climate][:max_12] == ""
        climate.save
        climate.min_temp = params[:climate][:min_12] unless params[:climate][:min_12] == ""
        climate.save
        climate.precipitation = params[:climate][:pcp_12] unless params[:climate][:pcp_12] == ""
        climate.save
    end
  end

## USED FOR TERRACE SYSTEM(ID: 17) AND FOR SLOPE ADJUSTEMNT(ID: 22)
  def terrace_and_slope(type)
    @soils = Soil.where(:field_id => params[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
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
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end # end method


## USED FOR PADS AND PIPES FIELDS (ID: 4 to ID: 7)
  def pads_pipes(type)
    @soils = Soil.where(:field_id => params[:field_id])
    i = 0
    @soils.each do |soil|
      if soil.selected
        if @slope > soil.slope then
          @slope = soil.slope
        end
      end
      subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, params[:scenario_id])
      if subarea != nil then
        #if i == 0 then
          #@inps = subarea.inps #select the first soil, which is with bigest area
          #i += 1
        #end
        #if soil.selected
          #@iops = subarea.iops #selected the last iops to inform the subarea the folowing iops to create.
        #end

        case type
          when "create", "update"
            if @bmp.depth == 4
              subarea.pcof = 0.0
            else
              subarea.pcof = 0.5
            end
          when "delete"
            subarea.pcof = 0.0
        end # switch statement
		#assign bmp_id to subarea. Need to save the bmp first to get the bmp_id
		if subarea.subarea_type != "Soil" then
			subarea.bmp_id = @bmp.id
		else
			subarea.bmp_id = 0
		end
        if !subarea.save then
			return "Enable to save value in the subarea file"
		else
		end
      end #end if subarea !nil
      soil_ops = SoilOperation.where(:soil_id => soil.id, :scenario_id => params[:scenario_id], :activity_id => 1)
      soil_ops.each do |soil_op|
        case type
          when "create"
            soil_op.opv2 = soil_op.opv2 * 0.9
          when "update"
            # there is not updates only create and delete
          when "delete"
            soil_op.opv2 = soil_op.opv2 / 0.9 #return back to 100%
          else
        end # switch statement
      end # end soil_ops.each
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
	      @bmp.buffer_slope_upland = 1			# buffer_slope_upland is not used anymore; therefor it is set to 1
        if @bmp.area != nil && @bmp.width != nil && @bmp.grass_field_portion != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
      when 13
	      @bmp.buffer_slope_upland = 1			# buffer_slope_upland is not used anymore; therefor it is set to 1
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
      @soils = Soil.where(:field_id => params[:field_id])
      #i = 0
      #@inps = i
      @soils.each do |soil|
        if soil.selected
          if @slope > soil.slope then
            @slope = soil.slope
          end
        end
        subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, params[:scenario_id])
        @inps = 0
        if subarea != nil then
          #if i == 0 then
            @inps = subarea.inps #select the last soil, to informe the subarea to what soil the wetland is going to be.
            #i += 1
          #end
          if soil.selected
            @iops = subarea.iops + 1 #selected the last iops to inform the subarea the folowing iops to create.
          end
        end
      end
      create_subarea(name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(params[:field_id]).field_area, @bmp.id, id, false, "create")
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
      @soils = Soil.where(:field_id => params[:field_id])
      i = 0
      @soils.each do |soil|
        if soil.selected
          if @slope > soil.slope then
            @slope = soil.slope
          end
        end
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => params[:scenario_id]).first
        if subarea != nil then
          if i == 0 then
            @inps = subarea.inps #select the first soil, which is with bigest area
            i += 1
          end
          if soil.selected
            @iops = subarea.iops #selected the last iops to inform the subarea the folowing iops to create.
          end
        end
      end
      subarea = Subarea.where(:scenario_id => params[:scenario_id], :subarea_type => name).first
      update_wsa("-", subarea.wsa)
      update_subarea(subarea, name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(params[:field_id]).field_area, @bmp.bmp_id, @bmp.bmpsublist_id, false, "update")
      return "OK"
    else
      return "OK"
    end
  end

  def delete_existing_subarea(name)
    subarea = Subarea.find_by_scenario_id_and_subarea_type(params[:scenario_id], name)
	if !(subarea == nil) && @bmp.sides == 0 then
		return update_wsa("+", subarea.wsa)
	else
		return "OK"
	end
    subarea.delete
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
end # end class
