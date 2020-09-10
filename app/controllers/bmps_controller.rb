include ScenariosHelper
class BmpsController < ApplicationController
  before_action :take_names

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
    if request.url.include? "ntt.bk" or request.url.include? "localhost" then
      bmpsublists = Bmpsublist.where(:status => true)
    else
      bmpsublists = Bmpsublist.where(:status => true).where("id != 27 and id != 28")
    end
    @bmps = Array.new
    #@bmps = Bmp.where(:bmpsublist_id => 0)
    @bmps[0] = Bmp.new
	  @climates = Climate.where(:id => 0)

  	bmpsublists.each do |bmpsublist|
  		bmp = Bmp.find_by_scenario_id_and_bmpsublist_id(params[:scenario_id], bmpsublist.id)
  		if bmp.blank? || bmp == nil then
  			bmp = Bmp.new
  			bmp.bmpsublist_id = bmpsublist.id
  			case bmp.bmpsublist_id
  			  when 1  #autoirrigation/autofertigation - defaults
    				bmp.water_stress_factor = 0.2
    				bmp.days = 14
    				bmp.irrigation_efficiency = 0
            bmp.maximum_single_application = 3
            bmp.dry_manure = 0
  			end
      end
      @bmps[bmp.bmpsublist_id-1] = bmp # contains bmp.id
      if bmp.bmpsublist_id == 1 then
        @crop_arr = Array.new
        temp_hash = Hash.new
        crops = Crop.where(id: @scenario.operations.select(:crop_id).distinct)
        crops.each do |c|
          ts = Timespan.find_by_bmp_id_and_crop_id(bmp.id, c.id)
          if ts != nil
            temp_hash = {
              "id":c.id,
              "name": Crop.find_by(id:c.id).name,
              "start_month": ts.start_month,
              "start_day": ts.start_day,
              "end_month": ts.end_month,
              "end_day": ts.end_day
            }
          else
            temp_hash = {
              "id":c.id,
              "name": Crop.find_by(id:c.id).name,
              "start_month": "0",
              "start_day": "0",
              "end_month": "0",
              "end_day": "0"
            }
          end
          @crop_arr << temp_hash
        end
      end

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
  		bmp_list = 28
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

  def save_bmps
    @values = params
    save_bmps_values()
  end

  def save_bmps_from_load(values)
    @values = values
    @project = Project.find(@values[:project_id])
    save_bmps_values()
  end
################################  save BMPS  #################################
# POST /bmps/scenario
  def save_bmps_values()
	  if @values[:button] == t('submit.savecontinue')
  		@slope = 100
  		#take the Bmps that already exist for that scenario and then delete them and any other information related one by one.
  		bmps = Bmp.where(:scenario_id => @values[:scenario_id])
  		bmps.each do |bmp|
  			@bmp = bmp
  			msg = input_fields("delete", 0)
  			if msg == "OK" then
  				bmp.destroy
  			end
  		end  # bmps.each
  		#Bmp.where(:scenario_id => @values[:scenario_id]).delete_all  #delete all of the bmps for this scenario and then create the new ones that have information.
      if @values[:bmp_ai] != nil then
    		if !(@values[:bmp_ai][:irrigation_id] == "") then
    			if !(@values[:bmp_cb1] == nil)
    				if @values[:bmp_cb1] == "1" then
    					create(1)   #autoirrigation
    				end
    				if @values[:bmp_cb1] == "2" then
    					create(1)   #autofertigation
    				end
    			end
    		end
      end

      if !(@values[:bmp_td] == nil)
  		  if !(@values[:bmp_td][:depth] == "") then
  			 create(3)
  		  end
      end

  	 	if !(@values[:bmp_ppnd] == nil)  # when this is hidden because it is not MO, MS states
    			if !(@values[:bmp_ppnd][:width] == "") then
    				if @values[:bmp_cb2] == "4" then
    					create(4)
    				end
    				if @values[:bmp_cb2] == "5" then
    					create(4)
    				end
    				if @values[:bmp_cb2] == "6" then
    					create(4)
    				end
    				if @values[:bmp_cb2] == "7" then
    					create(4)
    				end
    			end
  		end

    	if @values[:bmp_wl] != nil then
      	if !(@values[:bmp_wl][:area] == "") then
    			create(8)
    		end
      end
		  # =>  pond
  		if @values.has_key?(:select) && !@values[:select][:"9"].nil? then
  			create(9)
  		end
		  #stream fencing
		  if @values.has_key?(:select) && !@values[:select][:"10"].nil? then
  			create(10)
  		end

  		if !(@values[:bmp_sbs] == nil)
  			if @values[:bmp_sbs][:id] == "1" then
  				create(11)
  			end
  		end
		  #riparian forest
      if @values[:bmp_fs] != nil then
    		if !(@values[:bmp_fs][:grass_field_portion] == "") then
    			if !(@values[:bmp_cb3] == nil)
    				if @values[:bmp_cb3] == "12" then
    					create(12)   #riparian forest
    				end
          end
        end
      end
      if @values[:bmp_fs] != nil then
        if !(@values[:bmp_fs][:width] == "") then
          if !(@values[:bmp_cb3] == nil)
    				if @values[:bmp_cb3] == "13" then
    					create(13)   #filter strip
    				end
          end
  			end
      end

      if @values[:bmp_ww] != nil then
    		if !(@values[:bmp_ww][:width] == "") then
    			create(14)
    		end
      end

      if !(@values[:bmp_cb] == nil)
        if @values[:bmp_cb][:width] > "1" then
          create(15)
        end
      end

      if @values[:bmp_ll] != nil then
    		if !(@values[:bmp_ll][:slope_reduction] == "") then
    			create(16)
    		end
      end

  		if @values.has_key?(:select) && !@values[:select][:"17"].nil? then
  			create(17)
  		end

		  if !(@values[:bmp_mc] == nil) # when this is hidden because there is not manure application
  			if !(@values[:bmp_mc][:animal_id] == "") && !(@values[:bmp_mc][:animal_id] == nil) then
  				create(18)
  			end
		  end

      if @values.has_key?(:select) && !@values[:select][:"19"].nil? then
      #cover crop (bmp_ccr)
        create(19)
      end

      if @values.has_key?(:select) && !@values[:select][:"20"].nil? then
      #Reservoir
        create(20)
      end

  		if !(@values[:select] == nil) and @values[:select][:"21"] == "1" then
  			create(21)
  		end
      # =>  liming
      if @values.has_key?(:select) && !@values[:select][:"27"].nil? then
        create(27)
      end
      # =>  Future Climate
      if @values.has_key?(:select) && !@values[:select][:"28"].nil? and @values[:bmp_clm1] != nil then
        create(28)
      end
      if @values[:action] == "save_bmps" then
  		  redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
      else
        return
      end
	  else
		    redirect_to scenarios_path
	  end # end if @values[:button]
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
    @bmp.scenario_id = @values[:scenario_id]
    @bmp.bmpsublist_id = bmpsublist
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    #@irrigation = Irrigation.arel_table
    @climate_array = create_hash()
    @state = @project.location.state_id
    #@state = Location.find(Location.find_by_project_id(@project.id)).state_id
    msg = input_fields("create", bmpsublist)
    if msg == "OK" then
      if !@bmp.save then
    	 return "Error saving BMP"
      end
    end
    if !(@values[:select] == nil) && @values[:select][:"21"] == "1" && bmpsublist == 21 then
    	msg = create_climate("create")
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
    @bmp = Bmp.find(@values[:id])
    @animals = Fertilizer.where(:fertilizer_type_id => 2)
    @climates = Climate.where(:bmp_id => @bmp.id)
    #@irrigation = Irrigation.arel_table
    @climate_array = create_hash()
    if @bmp.bmpsublist_id == 21
      @climate_array = populate_array(@climates, @climate_array)
    end
    msg = input_fields("update", 0)

    respond_to do |format|
      if msg == "OK"
        if @bmp.update_attributes(bmp_params)
          format.html { redirect_to list_bmp_path(@values[:scenario_id]), notice: t('operation.bmp') + " " + t('general.updated') }
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

    msg = input_fields("delete",0)
    if @bmp.destroy
      flash[:notice] = t('models.bmp') + " " + Bmpsublist.find(@bmp.bmpsublist_id).name + t('notices.deleted')
    end

    respond_to do |format|
      format.html { redirect_to list_bmp_path(params[:scenario_id]) }
      format.json { head :no_content }
    end
  end  # end method

##############################  INPUT FIELDS  ###############################

  def input_fields(type, bmpsublist)
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
      when 12
        return riparian_forest(type)
      when 13
        if bmpsublist == 13 then return filter_strip(type) else return riparian_forest(type) end
      when 14
        return waterway(type)
      when 15
        return contour_buffer(type)
      when 16
        return land_leveling(type)
      when 17
        return terrace_system(type)
      when 18
        return manure_control(type)
      when 19
        return cover_crop(type)
      when 20
        return reservoir(type)
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
      when 27
        return liming(type)
      when 28
        return future_climate(type)
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
    #@soils = Soil.where(:field_id => params[:field_id])
    #@soils.each do |soil|
    @scenario.subareas.each do |subarea|
      #subarea = soil.subareas.find_by_scenario_id(@values[:scenario_id])
      if subarea != nil then
        case type
          when "create", "update"
  		      @bmp.irrigation_id = @values[:bmp_ai][:irrigation_id]
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
            subarea.iri = @values[:bmp_ai][:days]
			      @bmp.days = subarea.iri
            subarea.bir = @values[:bmp_ai][:water_stress_factor]
			      subarea.bir = (100 - subarea.bir) / 100
            @bmp.water_stress_factor = 1-subarea.bir
            if subarea.bir >= 1 then subarea.bir = 0.99 end
            subarea.efi = 1.0 - (@values[:bmp_ai][:irrigation_efficiency].to_f / 100)
			      @bmp.irrigation_efficiency = subarea.efi
            subarea.armx = @values[:bmp_ai][:maximum_single_application].to_f * IN_TO_MM
  		      @bmp.maximum_single_application = @values[:bmp_ai][:maximum_single_application].to_f
      		  subarea.fdsf = 0
      		  @bmp.depth = @values[:bmp_cb1]
        		if @values[:bmp_ai][:safety_factor] == nil then
        			subarea.fdsf = 0
        		else
        			subarea.fdsf = @values[:bmp_ai][:safety_factor]
        		end
            @bmp.safety_factor = subarea.fdsf
            if @values[:bmp_ai][:n_rate] == nil then
              subarea.fnp4 = 0
              @bmp.dry_manure = 0
            else
              # 02/03/20. fnp4 and bft
              subarea.fnp4 = 0
              #subarea.fnp4 = @values[:bmp_ai][:n_rate].to_f * LBS_TO_KG
              @bmp.dry_manure = @values[:bmp_ai][:n_rate]
            end
        		if @bmp.depth == 1 then
        			subarea.idf4 = 0.0
        			subarea.bft = 0.0
        		else
        			subarea.idf4 = 0.0
        			subarea.bft = 0.0
            end
            if @bmp.save then
              if params[:mycrop] != nil then
                params[:mycrop].each do |id, v|
                  ts = Timespan.find_by_bmp_id_and_crop_id(@bmp.id, id)
                  if id && ts == nil
                    @timespan = Timespan.new(bmp_id: @bmp.id, crop_id:id, start_month:params["bmp_ai"]["sm"][id], start_day:params["bmp_ai"]["sd"][id], end_month:params["bmp_ai"]["em"][id], end_day:params["bmp_ai"]["ed"][id])
                    @timespan.save
                  end
                end
              end
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
            subarea.fnp4 = 0.0
            subarea.fmx = 0.0
			  end   # end case type
        if !subarea.save then
  			   return "Unable to save value in the subarea file"
  		  end
      end #end if subarea !nil
    end # end subareas.each
    return "OK"
  end  # end method

### ID: 3
  def tile_drain(type)
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
            subarea.idr = @values[:bmp_td][:depth].to_f * FT_TO_MM
            @bmp.depth = @values[:bmp_td][:depth]
            @bmp.irrigation_id = 0
            subarea.tdms = 0
            @bmp.crop_id = 0
            if !(@values[:irrigation_id] == nil) then
              @bmp.irrigation_id = 1
              #subarea.tdms = 43    #only TD management is applicable in APEX. Bio is calculatd here.
            end
            if !(@values[:crop_id] == nil) then
              @bmp.crop_id = 1
              #subarea.tdms = 33.  #not used for now. If activated should aadd_subarea_file look for tdms column.
            end
			      subarea.drt = 2
          when "delete"
            subarea.idr = params[:field][:depth]
            # subarea.idr = Field.where(:id => @values[:field_id]).first[:depth]
            subarea.drt = 0
            subarea.tdms = 0
        end
        if !subarea.save then return "Unable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end # end method

### ID: 4
  def ppnd(type)
  	if type == "create" then
  		pad_and_pipe = @values[:bmp_cb2].to_i
  	else
  		pad_and_pipe = @bmp.depth
  	end
    case pad_and_pipe
    when 4, 5
      @bmp.width = @values[:bmp_ppnd][:width]
      @bmp.sides = @values[:bmp_ppnd][:sides]
      @bmp.area = 0
		  @bmp.depth = @values[:bmp_cb2]
    when 6
      ppde(type)
    when 7
      pptw(type)
    end
    return pads_pipes(type)
  end    # end method


### ID: 5
  def ppds(type)
    @bmp.width = @values[:bmp_ppnd][:width]
    @bmp.sides = @values[:bmp_ppnd][:sides]
    @bmp.area = 0
    @bmp.depth = @values[:bmp_cb2]
    return pads_pipes(type)
  end   # end method


  ### ID: 6
  def ppde(type)
    case type
      when "create"
    		@bmp.width = @values[:bmp_ppnd][:width]
    		@bmp.sides = @values[:bmp_ppnd][:sides]
    		@bmp.area = @values[:bmp_ppnd][:area]
    		@bmp.depth = @values[:bmp_cb2]
    		@iops = @field.soils.count
    		@inps = 1
        if @bmp.save then
          msg = pads_pipes(type)
          if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
            create_subarea("PPDE", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(@values[:field_id]).field_area, @bmp.id, @bmp.depth, false, "create", false)
          end
        else
         return "Error saving BMP"
        end
      when "update"
        if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
          update_existing_subarea("PPDE")
        end
      when "delete"
        delete_existing_subarea("PPDE")
    end
  end   # end method


  ### ID: 7
  def pptw(type)
    case type
      when "create"
  		  @bmp.width = @values[:bmp_ppnd][:width]
  		  @bmp.sides = @values[:bmp_ppnd][:sides]
  		  @bmp.area = @values[:bmp_ppnd][:area]
  		  @bmp.depth = @values[:bmp_cb2]
  		  @iops = @field.soils.count
  		  @inps = 1
  		  if @bmp.save then
  			  msg = pads_pipes(type)
  			  if @bmp.area != nil && @bmp.width != nil && @bmp.sides != nil
  				  create_subarea("PPTW", @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(@values[:field_id]).field_area, @bmp.id, @bmp.depth, false, "create", false)
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
  end   # end method


### ID: 8
  def wetlands(type)
    case type
      when "create"
    	  @bmp.area = @values[:bmp_wl][:area]
    		if @values[:bmp_wl][:buffer_land] == nil then
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

### ID: 9. This was the old pond version. It only adda the pond fraction to the fields in the subarea file
  def pond(type)
  	@bmp.irrigation_efficiency = @values[:bmp_pnd][:irrigation_efficiency].to_f
    @soils = Soil.where(:field_id => @values[:field_id])
    i = 0
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
              subarea.pcof = @bmp.irrigation_efficiency
          when "delete"
            subarea.pcof = 0
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end     # end method

### ID: 9. This was the new pond version. It add a new field for the pond
  def pond_new(type)
    case type
      when "create"
        @bmp.area = 0
        if @values[:bmp_pnd][:irrigation_efficiency] == nil then
          @bmp.sides = 0
          @bmp.irrigation_efficiency = 0
        else
          @bmp.sides = 1
          @bmp.irrigation_efficiency = @values[:bmp_pnd][:irrigation_efficiency]
          @bmp.area = @field.field_area * @bmp.irrigation_efficiency
        end
        if @bmp.save then
          return create_new_subarea("PND", 9)
        end
      when "update"
        update_existing_subarea("PND", 9)
      when "delete"
        @scenario.subareas.each do |subarea|
          subarea.pcof = 0
          subarea.save
        end
        return delete_existing_subarea("PND")
    end
  end     # end method

### ID: 10
  def stream_fencing(type)
    case type
    when "create"  	#@bmp.number_of_animals = @values[:bmp_sf][:number_of_animals]
  	    @bmp.width = @values[:bmp_sf][:width]
  	    @bmp.depth = Math::sqrt(@field.field_area * AC_TO_FT2)
        @bmp.area = @bmp.width * @bmp.depth / AC_TO_FT2
        op = @scenario.operations.where("activity_id = ? or activity_id = ?", 7, 9).first
        if op != nil
          @bmp.crop_id = Crop.find(op.crop_id).number
        end
      	#@bmp.animal_id = @values[:bmp_sf][:animal_id]
      	#@bmp.dry_manure = @values[:bmp_sf][:dry_manure]
      	#@bmp.no3_n = @values[:bmp_sf][:no3_n]
      	#@bmp.po4_p = @values[:bmp_sf][:po4_p]
      	#@bmp.org_n = @values[:bmp_sf][:org_n]
      	#@bmp.org_p = @values[:bmp_sf][:org_p]
      	#return "OK"
        if @bmp.save then
          if @bmp.area > 0 then
            return create_new_subarea("SF", 10)
          else
            return "OK"
          end
        end
    when "delete"
        return delete_existing_subarea("SF")
    end
end

### ID: 11
  def streambank_stabilization(type)
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
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
    		@bmp.area = @values[:bmp_fs][:area]
    		@bmp.width = @values[:bmp_fs][:width]
    		@bmp.grass_field_portion = @values[:bmp_fs][:grass_field_portion]
    		@bmp.buffer_slope_upland = @values[:bmp_fs][:buffer_slope_upland]
        @bmp.slope_reduction = @values[:bmp_fs][:floodplain_flow]
    		@bmp.crop_id = 1 #record not found error
        @bmp.bmpsublist_id = 13
  			if @values[:bmp_fs][:buffer_land] == nil then
  				@bmp.sides = 0
  			else
  				@bmp.sides = 1
  			end
    		@bmp.depth = @values[:bmp_cb3]
        if @bmp.area == 0 || @bmp.area == nil then
          length = Math.sqrt(@field.field_area * AC_TO_M2)    #convert ac to m2 and take sqrt to find lenght
          width = (@bmp.width + @bmp.grass_field_portion) * FT_TO_M  # convert width ft to width m
          @bmp.area = (length * width) / AC_TO_M2   # calculate area in m2 and convert back to ac
        end
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
    		@bmp.area = @values[:bmp_fs][:area]
    		@bmp.width = @values[:bmp_fs][:width]
    		@bmp.buffer_slope_upland = @values[:bmp_fs][:buffer_slope_upland]
    		@bmp.grass_field_portion = @values[:bmp_fs][:grass_field_portion]
        @bmp.slope_reduction = @values[:bmp_fs][:floodplain_flow]
    		@bmp.crop_id = @values[:bmp_fs][:crop_id]
    		if @values[:bmp_fs][:buffer_land] == nil then
    			@bmp.sides = 0
    		else
    			@bmp.sides = 1
    		end
    		@bmp.depth = @values[:bmp_cb3]
        if @bmp.depth == 12 then
          @bmp.crop_id = 1
        else
          @bmp.grass_field_portion = 0.00
        end
    		if @bmp.area == 0 || @bmp.area == nil then
          length = Math.sqrt(@field.field_area * AC_TO_M2)    #convert ac to m2 and take sqrt to find lenght
          width = (@bmp.width + @bmp.grass_field_portion) * FT_TO_M  # convert width ft to width m
          @bmp.area = (length * width) / AC_TO_M2   # calculate area in m2 and convert back to ac
    		end
      	if @bmp.save then
    			if @bmp.depth == 13 then
    				return create_new_subarea("FS", 13)
    			else
    				return create_new_subarea("RF", 12)
    			end
    		end
      when "update"
    		if @values[:bmp_cb1] == "13" then
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
		    @bmp.width = @values[:bmp_ww][:width]
		    @bmp.crop_id = @values[:bmp_ww][:crop_id]
        @bmp.grass_field_portion = @values[:bmp_ww][:length]
        @bmp.slope_reduction = @values[:bmp_ww][:floodplain_flow]
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

## ID: 15
  def contour_buffer(type)
    case type
    when "create"
      @bmp.crop_id = @values[:bmp_cb][:crop_id]
      @bmp.crop_width = @values[:bmp_cb][:crop_width]
      @bmp.width = @values[:bmp_cb][:width]
      @bmp.area = @field.field_area * (@bmp.width / (@bmp.width+@bmp.crop_width))
      if @bmp.save then
        return create_new_subarea("CB",15)
      end
    when "delete"
      @bmp.crop_width = 0
      @bmp.width = 0
      @bmp.crop_id = 0
      #delete all of CB subarea_type
      subareas = @scenario.subareas.where(:subarea_type => "CB")
      subareas.destroy_all
      #delete all of the SoilOperations ofor CB
      @bmp.soil_operations.delete_all
      # now restore the area of the subareas with "Soil" as subarea_type
      @scenario.subareas.each do |subarea|
        subarea.wsa = @field.field_area * AC_TO_HA * @field.soils.find(subarea.soil_id).percentage / 100
        subarea.save
      end
    end
    return "OK"
  end

### ID: 16
  def land_leveling(type)
    @bmp.slope_reduction = @values[:bmp_ll][:slope_reduction].to_f
    subareas = @scenario.subareas
    subareas.each do |subarea|
      #subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
      if subarea != nil then
        case type
          when "create"
            subarea.slp = subarea.slp * (100 - @bmp.slope_reduction) / 100
            #session[:old_percentage] = @values[:bmp_ll][:slope_reduction].to_f / 100
          when "update"
            #subarea.slp = (subarea.slp / (1 - @old_percentage)) - (subarea.slp * (@bmp.slope_reduction / 100))
            #session[:old_percentage] = @bmp.slope_reduction / 100
          when "delete"
            subarea.slp = @field.soils.find(subarea.soil_id).slope / 100
            #subarea.slp = subarea.slp * 100 / (100 - @bmp.slope_reduction)
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
  	@bmp.animal_id = @values[:bmp_mc][:animal_id]
  	@bmp.no3_n =@values[:bmp_mc][:no3_n]
  	@bmp.po4_p =@values[:bmp_mc][:po4_p]
  	@bmp.org_n =@values[:bmp_mc][:no3_n]
  	@bmp.org_p =@values[:bmp_mc][:po4_p]
    return "OK"
  end   # end method

### ID: 19
  def cover_crop(type)
    if type == "delete" then return "OK" end
    @bmp.crop_id = @values[:bmp_ccr][:crop_id]
    @bmp.number_of_animals = @values[:bmp_ccr][:year]
    @bmp.hours = @values[:bmp_ccr][:month]
    @bmp.days = @values[:bmp_ccr][:day]
    @bmp.irrigation_id = @values[:bmp_ccr][:type_id]
    return "OK"
  end   # end method

### ID: 20
  def reservoir(type)
    @bmp.water_stress_factor = @values[:bmp_rs][:rsee].to_f
    @bmp.irrigation_efficiency = @values[:bmp_rs][:rsae].to_f
    @bmp.maximum_single_application = @values[:bmp_rs][:rsve].to_f
    @bmp.safety_factor = @values[:bmp_rs][:rsep].to_f
    @bmp.depth = @values[:bmp_rs][:rsap].to_f
    @bmp.area = @values[:bmp_rs][:rsvp].to_f
    @bmp.dry_manure = @values[:bmp_rs][:rsv].to_f
    @bmp.days = @values[:bmp_rs][:rsrr].to_f
    @bmp.no3_n = @values[:bmp_rs][:rsys].to_f
    @bmp.po4_p = @values[:bmp_rs][:rsyn].to_f
    @bmp.org_n = @values[:bmp_rs][:rshc].to_f
    @bmp.hours = @values[:bmp_rs][:rsdp].to_f
    @bmp.org_p = @values[:bmp_rs][:rsbd].to_f
    @soil = @field.soils.last
    i = 0
    #@soils.each do |soil|
      subarea = Subarea.where(:soil_id => @soil.id, :scenario_id => @values[:scenario_id]).last
      if subarea != nil then
        case type
          when "create", "update"
            subarea.rsee = @bmp.water_stress_factor
            subarea.rsae = @bmp.irrigation_efficiency
            subarea.rsve = @bmp.maximum_single_application
            subarea.rsep = @bmp.safety_factor
            subarea.rsap = @bmp.depth
            subarea.rsvp = @bmp.area
            subarea.rsv = @bmp.dry_manure
            subarea.rsrr = @bmp.days
            subarea.rsys = @bmp.no3_n
            subarea.rsyn = @bmp.po4_p
            subarea.rshc = @bmp.org_n
            subarea.rsdp = @bmp.hours
            subarea.rsbd = @bmp.org_p
          when "delete"
            subarea.rsee = 0
            subarea.rsae = 0
            subarea.rsve = 0
            subarea.rsep = 0
            subarea.rsap = 0
            subarea.rsvp = 0
            subarea.rsv = 0
            subarea.rsrr = 0
            subarea.rsys = 0
            subarea.rsyn = 0
            subarea.rshc = 0
            subarea.rsdp = 0
            subarea.rsbd = 0
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    #end # end soils.each
    return "OK"
  end     # end method

### ID: 21
  def climate_change(type)
	return "OK"
	#@bmp.bmp = @values[:bmp_mc][:animal_id]
  end

### ID: 22
  def create_climate(type)
    bmp_id = Bmp.find_by_bmpsublist_id(19).id
  	for i in 1..12
  		climate = Climate.new
  		climate.bmp_id = bmp_id
  		climate.month = i
  		climate.max_temp = @values[:bmp_cc]["max_temp" + i.to_s]
  		climate.min_temp = @values[:bmp_cc]["min_temp" + i.to_s]
  		climate.precipitation = @values[:bmp_cc]["precipitation" + i.to_s]
  		climate.save
  	end
    return "OK"
  end

### ID: 23
  def asphalt_concrete(type)
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
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
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
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

### ID: 25
  def slope_adjustment(type)
    terrace_and_slope(type)
  end

### ID: 23
  def shading(type)
    case type
      when "create"
		@bmp.area = @values[:bmp_fs][:area]
		@bmp.width = @values[:bmp_fs][:width]
		@bmp.buffer_slope_upland = @values[:bmp_fs][:buffer_slope_upland]
		@bmp.crop_id = @values[:bmp_fs][:crop_id]
		@bmp.depth = @values[:bmp_cb1]
        return create_new_subarea("Sdg", 23)
      when "update"
        update_existing_subarea("Sdg", 23)
      when "delete"
        subarea = Subarea.where(:scenario_id => @values[:scenario_id], :subarea_type => "Sdg").first
        update_wsa("+", subarea.wsa)
      #Subarea.where(:scenario_id => @values[:scenario_id], :subarea_type => "Sdg").first.delete
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

  ## Liming. No paramters required. Only change the lm in subarea from 1 to 0
  def liming(type)
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
      if subarea != nil then
        case type
          when "create", "update"
            subarea.lm = 0.0
          when "delete"
            subarea.lm = 1.0
        end
        if !subarea.save then return "Enable to save value in the subarea file" end
      end #end if subarea !nil
    end # end soils.each
    return "OK"
  end  # end method

  ## future climate. Save the selected scenario
  def future_climate(type)
    @bmp.depth = params[:bmp_clm1]
    return "OK"
  end  # end method


  ## USED FOR TERRACE SYSTEM(ID: 17) AND FOR SLOPE ADJUSTEMNT(ID: 22)
  def terrace_and_slope(type)
    @soils = Soil.where(:field_id => @values[:field_id])
    @soils.each do |soil|
      subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
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
    #PPND: 1) reduce CN bu 10%, 2) reduce field area by bmp.widht * bmp.sides after calculate area.
    #PPDS: same as PPND and 3) add a pond 0.5 in PCOF.
    #PPDE: Same as PPDS and add a reservoir.
    @soils = Soil.where(:field_id => @values[:field_id])
    i = 0
    @soils.each do |soil|
      if @slope > soil.slope then
        @slope = soil.slope
      end
      subarea = Subarea.find_by_soil_id_and_scenario_id(soil.id, @values[:scenario_id])
      if subarea != nil then
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
    		end
      end #end if subarea !nil
      soil_ops = SoilOperation.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id], :activity_id => 1)
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
      when 9
        if @bmp.irrigation_efficiency != nil
          is_filled = true;
        end
      when 10
        if @bmp.width != nil && @bmp.depth != nil
          is_filled = true;
        end
      when 12
	      @bmp.buffer_slope_upland = 1			# buffer_slope_upland is not used anymore; therefor it is set to 1
        if @bmp.grass_field_portion != nil && @bmp.buffer_slope_upland != nil
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
      when 15  # contour buffer
        if @bmp.width != nil and @bmp.crop_width != nil
          is_filled = true;
        end
      when 23
        if @bmp.area != nil && @bmp.width != nil && @bmp.buffer_slope_upland != nil
          is_filled = true;
        end
    end
    if is_filled
      @soils = @field.soils
      @soils.each do |soil|
          if @slope > soil.slope then
            @slope = soil.slope
          end
        subarea = @scenario.subareas.find_by_soil_id(soil.id)
        @inps = 1
        if subarea != nil then
            @iops = subarea.iops + 1 #selected the last iops to inform the subarea the folowing iops to create.
        else
            @iops = @scenario.subareas.count
        end
      end
      if id == 15 then   #contour buffer
        total_width = @bmp.width + @bmp.crop_width
        total_strips = ((@field.field_area * AC_TO_HA * 10000) / (total_width * FT_TO_MM)).to_i
        buffer_area = @bmp.width / total_width
        crop_area = @bmp.crop_width / total_width
        if total_strips > MAX_STRIPS then total_strips = MAX_STRIPS end
        subareas = @scenario.subareas
        number = subareas.count + 1
        iops = subareas[subareas.count-1].iops + 1
        inps = subareas[subareas.count-1].inps + 1
        iow = subareas[subareas.count-1].iow + 1
        areas = Array.new
        iops = 0
        crop = Crop.find(@bmp.crop_id)
        add_buffer_operation(139, crop.number, 0, crop.heat_units, 0, 33, 2, @scenario.id)
        (total_strips*2).times do |i|
          j=0
          subareas.each do |s|
            if i == 0 then  # update the current subareas. And save the initial areas in an array to calculate further areas.
              areas[j] = s.wsa
              s.rchl = s.chl
              s.wsa = s.wsa / total_strips * crop_area
              if j > 0 && s.wsa > 0 then
                s.wsa *= -1
              end
              s.save
              j += 1
              iops = s.iops
            else
              s_new = s.dup
              s_new.rchl = s_new.chl
              s_new.number = number
              number += 1
              #s_new.iops = iops
              #s_new.inps = inps
              #s_new.iow = iow
              s_new.subarea_type = "CB"
              #if s_new.chl == s_new.rchl then
                #s_new.rchl *= 0.90
              #end
              s_new.bmp_id = @bmp.id
              if i.even? then
                s_new.wsa = areas[j] / total_strips * crop_area
                s_new.description = "0000000000000000  .sub Contour Main Crop Strip"
                s_new.wsa *= -1
              else
                s_new.wsa = areas[j] / total_strips * buffer_area
                s_new.description = "0000000000000000  .sub Contour Buffer Grass Strip"
                s_new.iops = iops + 1
                if j > 0 then
                  s_new.wsa *= -1
                else
                  s_new.rchl = s_new.chl * 0.9
                end
              end
              j += 1
              s_new.save
            end
          end
        end
      else  # others
        create_subarea(name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, @field.field_area, @bmp.id, id, false, "create", false)
      end
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
      @soils = Soil.where(:field_id => @values[:field_id])
      i = 0
      @soils.each do |soil|
        #if soil.selected
          if @slope > soil.slope then
            @slope = soil.slope
          end
        #end
        subarea = Subarea.where(:soil_id => soil.id, :scenario_id => @values[:scenario_id]).first
        if subarea != nil then
          if i == 0 then
            @inps = subarea.inps #select the first soil, which is with bigest area
            i += 1
          end
          #if soil.selected
            @iops = subarea.iops #selected the last iops to inform the subarea the folowing iops to create.
          #end
        end
      end
      subarea = Subarea.where(:scenario_id => @values[:scenario_id], :subarea_type => name).first
      update_wsa("-", subarea.wsa)
      update_subarea(subarea, name, @inps, @bmp.area, @slope, false, 0, "", @bmp.scenario_id, @iops, 0, 0, Field.find(@values[:field_id]).field_area, @bmp.bmp_id, @bmp.bmpsublist_id, false, "update")
      return "OK"
    else
      return "OK"
    end
  end

  def delete_existing_subarea(name)
    subarea = Subarea.find_by_scenario_id_and_subarea_type(@values[:scenario_id], name)
  	#if !(subarea == nil) && @bmp.sides == 0 then
    if !(subarea == nil) && !(@bmp.bmpsublist_id == 9) then
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
