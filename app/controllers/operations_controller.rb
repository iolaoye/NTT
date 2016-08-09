class OperationsController < ApplicationController
  require "open-uri"
################################  operations list   #################################
  # GET /operations/1
  # GET /1/operations.json
  def list
    @operations = Operation.where(:scenario_id => session[:scenario_id]) # used to be params[:id]
		@project_name = Project.find(session[:project_id]).name
		@field_name = Field.find(session[:field_id]).field_name
		@scenario_name = Scenario.find(session[:scenario_id]).name
	respond_to do |format|
		format.html # list.html.erb
		format.json { render json: @fields }
	end
  end
################################  INDEX  #################################
  # GET /operations
  # GET /operations.json
  def index
    @operations = Operation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operations }
    end
  end
################################  SHOW  #################################
  # GET /operations/1
  # GET /operations/1.json
  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operation }
    end
  end

################################  NEW  #################################
  # GET /operations/new
  # GET /operations/new.json
  def new
    @operation = Operation.new
	@crops = Crop.load_crops(Location.find(session[:location_id]).state_id)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @operation }
    end
  end

################################  Edit  #################################
  # GET /operations/1/edit
  def edit
	@crops = Crop.load_crops(Location.find(session[:location_id]).state_id)
    @operation = Operation.find(params[:id])
  end

################################  CREATE  #################################
  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)
    @operation.scenario_id = session[:scenario_id]
    respond_to do |format|
      if @operation.save
				#operations should be created in soils too.
				add_soil_operation()
        format.html { redirect_to list_operation_path(session[:scenario_id]), notice: t('scenario.operation') + " " + t('general.created') }
        format.json { render json: @operation, status: :created, location: @operation }
      else
        format.html { render action: "new" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

################################  UPDATE  #################################
  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    @operation = Operation.find(params[:id])
    respond_to do |format|
      if @operation.update_attributes(operation_params)
		soil_operations = SoilOperation.where(:operation_id => @operation.id)
		soil_operations.each do |soil_operation|
			update_soil_operation(soil_operation, soil_operation.soil_id)
		end
        format.html { redirect_to list_operation_path(session[:scenario_id]), notice: t('scenario.operation') + " " + t('general.updated') }
				format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation = Operation.find(params[:id])
    soil_operations = SoilOperation.where(:operation_id => @operation.id)
    @operation.destroy
	if soil_operations != nil then
		soil_operations.delete_all
	end if

    respond_to do |format|
      format.html { redirect_to list_operation_path(session[:scenario_id]) }
      format.json { head :no_content }
    end
  end

  def cropping_system
	@operations = Operation.where(:scenario_id => session[:scenario_id])
    @highest_year = 0
    @operations.each do |operation|
      if(operation.year > @highest_year)
        @highest_year = operation.year
      end
    end
	@cropping_systems = CroppingSystem.where(:state_id => Location.find(session[:location_id]).state_id)
	if @cropping_systems == nil then
		@cropping_systems = CroppingSystem.where(:state_id => "All")
	end
  	if params[:cropping_system] != nil
		if params[:cropping_system][:id] != "" then
			@cropping_system_id = params[:cropping_system][:id]
      if params[:replace] != nil
        #Delete operations for the scenario selected
        Operation.where(:scenario_id => params[:id]).destroy_all
        #SoilOperation.where(:scenario_id => params[:id]).delete_all
      end
	  #take the event for the cropping_system selected and replace the operation and soilOperaition files for the scenario selected.
	  events = Event.where(:cropping_system_id => params[:cropping_system][:id])
	  events.each do |event|
		@operation = Operation.new
		@operation.scenario_id = params[:id]
		#get crop_id from croppingsystem and state_id
		state_id = Location.find(session[:location_id]).state_id
		crops = Crop.where(:number => event.apex_crop)
		crop_id = event.apex_crop
		plant_population = crops[0].plant_population_ft
		crops.each do |crop|
			if crop.state_id == state_id then
				crop_id = crop.id
				break
			else
				crop_id = crop.id
			end
		end
		@operation.crop_id = crop_id
		@operation.activity_id = event.activity_id
		@operation.day = event.day
		@operation.month_id = event.month
      if params[:replace] != nil
        @operation.year = event.year
      else
        @operation.year = event.year + params[:year].to_i
      end
      #type_id is used for fertilizer and todo (others. identify). FertilizerTypes 1=commercial 2=manure
      #note fertilizer id and code are the same so far. Try to keep them that way
      @operation.type_id = 0
      @operation.no3_n = 0
      @operation.po4_p = 0
      @operation.org_n = 0
      @operation.org_p = 0
      @operation.nh3 = 0
      @operation.subtype_id = 0
      case @operation.activity_id
        when 1  #planting operation. Take planting code from crop table and plant population as well
          @operation.type_id = Crop.find(crop_id).planting_code
          @operation.amount = plant_population
        when 2, 7
          fertilizer = Fertilizer.find(event.apex_fertilizer) unless event.apex_fertilizer == 0
          @operation.amount = event.apex_opv1
          if fertilizer != nil then
            @operation.type_id = fertilizer.fertilizer_type_id
            @operation.no3_n = fertilizer.qn
            @operation.po4_p = fertilizer.qp
            @operation.org_n = fertilizer.yn
            @operation.org_p = fertilizer.yp
            @operation.nh3 = fertilizer.nh3
            @operation.subtype_id = event.apex_fertilizer
          end
        when 3
          @operation.type_id = event.apex_operation
        else
			@operation.amount = event.apex_opv1
		end  #end case
		@operation.depth = event.apex_opv2
		@operation.scenario_id = params[:id]
		if @operation.save then
			add_soil_operation()
		end
	  end  # end events.each
	end  #end if cropping_system_id != ""
	@operations = Operation.where(:scenario_id => params[:id])
	if params[:language] != nil then
		if params[:language][:language].eql?("es") 
			I18n.locale = :es
		else
			I18n.locale = :en
		end
	end
		render action: 'list'
	else
		render action: 'upload'
	end  # end if cropping_system_id != nil
  end  # end method

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def operation_params
      params.require(:operation).permit(:amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id, :moisture)
    end

	def add_soil_operation()
		soils = Soil.where(:field_id => Scenario.find(@operation.scenario_id).field_id)
		soils.each do |soil|
			update_soil_operation(SoilOperation.new, soil.id)
		end
	end

	def update_soil_operation(soil_operation, soil_id)
    soil_operation.activity_id = @operation.activity_id
    soil_operation.scenario_id = @operation.scenario_id
    soil_operation.operation_id = @operation.id
    soil_operation.soil_id = soil_id
    soil_operation.year = @operation.year
    soil_operation.month = @operation.month_id
    soil_operation.day = @operation.day
    case @operation.activity_id
      when 1, 3	#planting, tillage
        soil_operation.apex_operation = @operation.type_id
        soil_operation.type_id = @operation.type_id
      when 2, 7   #fertilizer, grazing
        soil_operation.apex_operation = Activity.find(@operation.activity_id).apex_code
        soil_operation.type_id = @operation.subtype_id
      when 4   #Harvest. Take harvest operation from crop table
        soil_operation.apex_operation = Crop.find(@operation.crop_id).harvest_code
        soil_operation.type_id = @operation.subtype_id
      else
        soil_operation.apex_operation = Activity.find(@operation.activity_id).apex_code
        soil_operation.type_id = @operation.type_id
    end
    soil_operation.tractor_id = 0
    soil_operation.apex_crop = Crop.find(@operation.crop_id).number
    soil_operation.opv1 = set_opval1
    soil_operation.opv2 = set_opval2(soil_operation.soil_id)
    soil_operation.opv3 = 0
    soil_operation.opv4 = set_opval4
    soil_operation.opv5 = set_opval5
    soil_operation.opv6 = 0
    soil_operation.opv7 = 0
    soil_operation.save
	end

	def set_opval5
		case @operation.activity_id
			when 1    #planting
				lu_number = Crop.find(@operation.crop_id).lu_number
				if lu_number != nil then
					if @operation.amount == 0 then
						if @operation.crop_id == Crop_Road then return 0 end
					else
						if @operation.amount / FT_TO_M < 1 then
							return (@operation.amount / FT2_TO_M2).round(6)  #plant population converte from ft2 to m2 if it is not tree
						else
							return (@operation.amount / FT2_TO_M2).round(0)  #plant population converte from ft2 to m2 if it is not tree
						end
						if lu_number == 28 then
							return (@operation.amount / FT_TO_HA).round(0)  #plant population converte from ft2 to ha if it is tree
						end
					end
				end
			else
				return 0
		end  #end case
	end #end set_val5

	def set_opval1
		opv1 = 1.0
		case @operation.activity_id
			when 1  #planting take heat units
				#uri = URI.parse(URL_HU +  "?op=getHU&crop=" + @operation.crop_id.to_s + "&nlat=" + Weather.find_by_field_id(session[:field_id]).latitude.to_s + "&nlon=" + Weather.find_by_field_id(session[:field_id]).longitude.to_s)
				#uri.open
				#opv1 = uri.read
				#opv1 = Hash.from_xml(open(uri.to_s).read)["m"]{"p".inject({}) do |result, elem
				client = Savon.client(wsdl: URL_HU)
				response = client.call(:get_hu, message:{"crop" => Crop.find(@operation.crop_id).number, "nlat" => Weather.find_by_field_id(session[:field_id]).latitude, "nlon" => Weather.find_by_field_id(session[:field_id]).longitude})
				opv1 = response.body[:get_hu_response][:get_hu_result]
				#opv1 = 2.2
			when 2   #fertilizer - converte amount applied
				if @operation.subtype_id == 57  then
					opv1 = (@operation.amount * 8.25 * 0.005 * 1121.8).round(2)  #kg/ha of fertilizer applied converted from liquid manure
                else
					opv1 = (@operation.amount * LBS_TO_KG / AC_TO_HA).round(2)  #kg/ha of fertilizer applied converted from lbs/ac
				end
			when 6   #irrigation
				opv1 = operation.amount * IN_TO_MM  #irrigation volume from inches to mm.
			when 10  #liming
				opv1 = @operation.amount / THA_TO_TAC        #converts input t/ac to APEX t/ha
		end
		return opv1
	end   #end ser_opval1

	def set_opval4
		opv4 = 0.0
		case @operation.activity_id
			when 6  #irrigation
				opv4 = 1 - @operation.depth unless @operatin.depth == nil
		end
		return opv4
	end #end set_opval4

	def set_opval2(soil_id)
		opv2 = 0.0
		case @operation.activity_id
			when 1  #planting. Take curve number
				case Soil.find(soil_id).group[0,1]
					when "A"
						opv2 = Crop.find_by_number(@operation.crop_id).soil_group_a
					when "B"
						opv2 = Crop.find_by_number(@operation.crop_id).soil_group_b
					when "C"
						opv2 = Crop.find_by_number(@operation.crop_id).soil_group_c
					when "D"
						opv2 = Crop.find_by_number(@operation.crop_id).soil_group_d
				end  #end case Soil
				if opv2 > 0 then opv2 = opv2 * -1 end
			when 2  #fertilizer - convert depth
				opv2 = @operation.depth * IN_TO_MM unless @operation.depth == nil
		end  #end case @operation
		return opv2
	end  #end set_opval2

end   #end class