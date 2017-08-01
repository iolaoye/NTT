include ScenariosHelper

class OperationsController < ApplicationController
  include ScenariosHelper
  require "open-uri"

################################  INDEX  #################################
# GET /operations
# GET /operations.json
  def index
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])

  	@scenario = Scenario.find(params[:scenario_id])
    @operations = @scenario.operations
  	crop_schedule()

    add_breadcrumb t('menu.operations')
    array_of_ids = @scenario.operations.order(:activity_id, :year).map(&:crop_id)
    @crops = Crop.find(array_of_ids).index_by(&:id).slice(*array_of_ids).values
    @operations.sort_by { |date| [date.year, date.month_id, date.day] }
	if @operations.last != nil
	  @highest_year = @operations.last.year
    else
	  @highest_year = 0
	end
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
  	@operation.activity_id = params[:operation]
  	@operation.crop_id = params[:crop]
    @fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true)
    @crops = Crop.load_crops(Location.find(session[:location_id]).state_id)
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
	@fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true)
    add_breadcrumb t('menu.operations'), project_field_scenario_operations_path(@project, @field, @scenario)
	  add_breadcrumb t('operation.new_operation')

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
	@fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true)
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
    add_breadcrumb 'Operations', project_field_scenario_operations_path(@project, @field, @scenario)
	  add_breadcrumb t('operation.edit')
  end

################################  CREATE  #################################
# POST /operations
# POST /operations.json
  def create
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    saved = false
    soil_op_saved = false
    msg = "Unknown error"
    ActiveRecord::Base.transaction do
      @operation = Operation.new(operation_params)
	  update_amount()   #CONVERT T/ac to lbs/ac
      @operation.scenario_id = params[:scenario_id]
      @crops = Crop.load_crops(Location.find(session[:location_id]).state_id)
      if @operation.save
        saved = true
        #operations should be created in soils too.
        msg = add_soil_operation()
        if msg.eql?("OK")
          soil_op_saved = true
        else
          soil_op_saved = false
          raise ActiveRecord::Rollback
        end
		if @operation.activity_id == 7 then
			operation_id = @operation.id
			@operation = Operation.new(operation_params)
			@operation.activity_id = 8
			@operation.year = params[:year1]
			@operation.month_id = params[:month_id1]
			@operation.day = params[:day1]
			@operation.type_id = operation_id
			@operation.scenario_id = params[:scenario_id]
			@operation.amount = 0
			@operation.depth = 0
			@operation.no3_n = 0
			@operation.po4_p = 0
			@operation.org_n = 0
			@operation.org_p = 0
			@operation.nh3 = 0
			@operation.moisture = 0
			@operation.subtype_id = 0
			@operation.save
		end
        msg = add_soil_operation()
        if msg.eql?("OK")
          soil_op_saved = true
        else
          soil_op_saved = false
          raise ActiveRecord::Rollback
        end
      else
        saved = false
      end
    end
    respond_to do |format|
      if saved
        if soil_op_saved
          if params[:add_more] == t('submit.add_more') && params[:finish] == nil
            format.html { redirect_to new_project_field_scenario_operation_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
            format.json { render json: @operation, status: :created, location: @operation }
          elsif params[:finish] == t('submit.finish') && params[:add_more] == nil
            format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
            format.json { render json: @operation, status: :created, location: @operation }
          end
        else
          format.html { render action: "new" }
          format.json { render json: msg, status: :unprocessable_entity }
        end
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
	@crops = Crop.load_crops(Location.find(session[:location_id]).state_id)
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    respond_to do |format|
      if @operation.update_attributes(operation_params)
		update_amount()
        soil_operations = SoilOperation.where(:operation_id => @operation.id)
        soil_operations.each do |soil_operation|
          update_soil_operation(soil_operation, soil_operation.soil_id, @operation)
        end
		if @operation.activity_id == 7 then
			if (Operation.find_by_type_id(@operation.type_id) != nil) then
				@operation1 = Operation.find_by_type_id(@operation.type_id)
			else
				operation_id = @operation.id
				@operation1 = Operation.new(operation_params)
				@operation1.activity_id = 8
				@operation1.type_id = operation_id
				@operation1.scenario_id = params[:scenario_id]
				@operation1.amount = 0
				@operation1.depth = 0
				@operation1.no3_n = 0
				@operation1.po4_p = 0
				@operation1.org_n = 0
				@operation1.org_p = 0
				@operation1.nh3 = 0
				@operation1.moisture = 0
				@operation1.subtype_id = 0
			end
			@operation1.year = params[:operation][:year].to_i
			@operation1.month_id = params[:operation][:month_id].to_i
			@operation1.day = params[:operation][:day].to_i
			@operation1.save
			soil_operations = SoilOperation.where(:operation_id => @operation1.id)
			soil_operations.each do |soil_operation|
			  update_soil_operation(soil_operation, soil_operation.soil_id, @operation1)
			end
		end 
        if params[:add_more] == t('submit.add_more') && params[:finish] == nil
          format.html { redirect_to new_project_field_scenario_operation_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
          format.json { render json: @operation, status: :created, location: @operation }
        elsif params[:finish] == t('submit.finish') && params[:add_more] == nil
          format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
          format.json { render json: @operation, status: :created, location: @operation }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

################################  DESTROY  #################################
# DELETE /operations/1
# DELETE /operations/1.json
  def destroy
    @operation = Operation.find(params[:id])
    soil_operations = SoilOperation.where(:operation_id => @operation.id)
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
	if @operation.activity_id == 7 then
		#delete stop grazing linked to this grazing operation
		Operation.find_by_type_id(@operation.id).destroy
	end
    if @operation.destroy
      flash[:notice] = t('models.operation') + t('notices.deleted')
    end
    if soil_operations != nil
      soil_operations.delete_all
    end
    respond_to do |format|
      format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario) }
      format.json { head :no_content }
    end
  end

##############################  DESTROY ALL  ###############################
  def delete_all
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    @operations = @scenario.operations.where(:crop_id => params[:id])
    @operations.destroy_all
    respond_to do |format|
      format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('notices.all') }
      format.json { head :no_content }
    end
  end

################################  CALL WHEN CLICK IN UPLOAD CROPPING SYSTEM  #################################
  def cropping_system
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    @operations = Operation.where(:scenario_id => session[:scenario_id])
    @count = @operations.count
    @highest_year = 0
    @operations.each do |operation|
      if (operation.year > @highest_year)
        @highest_year = operation.year
      end
    end
    @cropping_systems = CroppingSystem.where(:state_id => Location.find(session[:location_id]).state_id, :status => true)
    if @cropping_systems == nil then
      @cropping_systems = CroppingSystem.where(:state_id => 0, :status => true)
    end
    if params[:cropping_system] != nil
      if params[:cropping_system][:id] != "" then
        ActiveRecord::Base.transaction do
          @cropping_system_id = params[:cropping_system][:id]
          @tillage_id = params[:tillage][:id]
          if params[:replace] != nil
            #Delete operations for the scenario selected
            Operation.where(:scenario_id => params[:scenario_id]).destroy_all
          end
          #take the event for the cropping_system selected and replace the operation and soilOperaition files for the scenario selected.
          events = Event.where(:cropping_system_id => params[:cropping_system][:id])
          events.each do |event|
            @operation = Operation.new
            @operation.scenario_id = params[:scenario_id]
            #get crop_id from croppingsystem and state_id
            state_id = Location.find(session[:location_id]).state_id
            crop = Crop.find_by_number_and_state_id(event.apex_crop, state_id)
			if crop == nil then
				crop = Crop.find_by_number_and_state_id(event.apex_crop, '**')
			end
            plant_population = crop.plant_population_ft
            @operation.crop_id = crop.id
            @operation.activity_id = event.activity_id
            @operation.day = event.day
            @operation.month_id = event.month
            if params[:replace] != nil
              #replace
              @operation.year = event.year
            else
              #don't replace
              if @count > 0
                @operation.year = event.year + params[:year].to_i - 1
              else
                @operation.year = event.year
              end
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
              when 1 #planting operation. Take planting code from crop table and plant population as well
                @operation.type_id = Crop.find(@operation.crop_id).planting_code
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
            end #end case
            @operation.depth = event.apex_opv2
            @operation.scenario_id = params[:scenario_id]
            if @operation.save
              msg = add_soil_operation()
			  notice = t('scenario.operation') + " " + t('general.created')
              unless msg.eql?("OK")
                raise ActiveRecord::Rollback
              end
            else
              raise ActiveRecord::Rollback
            end
          end # end events.each
        end
      end #end if cropping_system_id != ""
      @operations = Operation.where(:scenario_id => params[:scenario_id])
      if params[:language] != nil then
        if params[:language][:language].eql?("es")
          I18n.locale = :es
        else
          I18n.locale = :en
        end
      end
      redirect_to scenario_operations_scenario_path(params[:scenario_id])
    else
      render action: 'upload'
    end # end if cropping_system_id != nil
  end # end method

################################  CALL WHEN CLICK IN UPLOAD CROP SCHEDULE  #################################
  def crop_schedule
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    @operations = Operation.where(:scenario_id => params[:scenario_id])
    @count = @operations.count
    @highest_year = 0
    @operations.each do |operation|
      if (operation.year > @highest_year)
        @highest_year = operation.year
      end
    end
    @cropping_systems = CropSchedule.where(:state_id => Location.find(session[:location_id]).state_id, :status => true).where("class_id < 3")
    @tillages = CropSchedule.where(:state_id => Location.find(session[:location_id]).state_id, :status => true).where("class_id == 3")
    if @cropping_systems == nil or @cropping_systems.blank? then
      @cropping_systems = CropSchedule.where(:state_id => 0, :status => true).where("class_id < 3")
    end
    if @tillages == nil or @tillages.blank? then
      @tillages = CropSchedule.where(:state_id => 0, :status => true).where("class_id == 3")
    end
    if params[:cropping_system] != nil
      if params[:cropping_system][:id] != "" then
        ActiveRecord::Base.transaction do
          @cropping_system_id = params[:cropping_system][:id]
		  #create operations for crop rotation selected and take the crop to add to the tillage selected.
		  create_crop_rotation()
        end   #end transaction do
      end #end if cropping_system_id != ""
    end # end if cropping_system != nil

    if params[:tillage] != nil
      if params[:tillage][:id] != "" then
        ActiveRecord::Base.transaction do
          @tillage_id = params[:tillage][:id]
		  #create operations for tillage selected and take the crop from last operation added.
		  create_tillage()
        end   #end transaction do
      end #end if tillage_id != ""
    end # end if tillage != nil

    @operations = Operation.where(:scenario_id => params[:scenario_id])
    if params[:language] != nil then
    if params[:language][:language].eql?("es")
        I18n.locale = :es
    else
        I18n.locale = :en
    end
    end
  end # end method

########################################### Create_crop_rotation ##################
  def create_tillage
		#take the event for the tillage selected and add to the operation and soilOperaition files for the scenario selected.
		events = Schedule.where(:crop_schedule_id => params[:tillage][:id])				
		events.each do |event|
			@operation = Operation.new
			@operation.scenario_id = params[:scenario_id]
			#get crop_id from croppingsystem and state_id
			#state_id = Location.find(session[:location_id]).state_id
			#@crop = Crop.find_by_number_and_state_id(event.apex_crop, state_id)
			#if crop is nil the model will look at the table for the year and scenario operarions to find the crop. If not nothins will be added.
			if @crop == nil then
				@crop_temp = Operation.where("year == ? and scenario_id == ? and activity_id > ?", event.year, params[:scenario_id], 0).last
				if @crop_temp == nil or @crop_temp.blank? then  #if @crop still nil finish
					break
				else
					@crop = Crop.find(@crop_temp.crop_id)
				end
			end
			@operation.crop_id = @crop.id
			#plant_population = @crop.plant_population_ft
			@operation.activity_id = event.activity_id
			@operation.day = event.day
			@operation.month_id = event.month
			if params[:replace] != nil
				#replace
				@operation.year = event.year
			else
				#don't replace
				if @count > 0
					@operation.year = event.year + params[:year].to_i - 1
				else
					@operation.year = event.year
				end
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
			@operation.type_id = event.apex_operation
			@operation.depth = event.apex_opv2
			@operation.scenario_id = @scenario.id
			if @operation.save
				msg = add_soil_operation()
				notice = t('scenario.operation') + " " + t('general.created')
				unless msg.eql?("OK")
				raise ActiveRecord::Rollback
				end
			else
				raise ActiveRecord::Rollback
			end
		end # end events.each
  end  # end method

########################################### Create_crop_rotation ##################
  def create_crop_rotation
		if params[:replace] != nil
			#Delete operations for the scenario selected
			Operation.where(:scenario_id => params[:scenario_id]).destroy_all
		end
		byebug
		#take the event for the cropping_system and tillage selected and add to the operation and soilOperaition files for the scenario selected.
		crop_schedule_class_id = @cropping_systems.find(params[:cropping_system][:id]).class_id
		events = Schedule.where(:crop_schedule_id => params[:cropping_system][:id])				
		events.each do |event|
		@operation = Operation.new
		@operation.scenario_id = params[:scenario_id]
		#get crop_id from croppingsystem and state_id
		state_id = Location.find(session[:location_id]).state_id
		@crop = Crop.find_by_number_and_state_id(event.apex_crop, state_id)
		if @crop == nil then
			@crop = Crop.find_by_number_and_state_id(event.apex_crop, '**')
		end
		@operation.crop_id = @crop.id
		plant_population = @crop.plant_population_ft
		@operation.activity_id = event.activity_id
		@operation.day = event.day
		@operation.month_id = event.month
		if params[:replace] != nil
			#replace
			@operation.year = event.year
		else
			#don't replace
			if @count > 0
				@operation.year = event.year + params[:year].to_i - 1
			else
				@operation.year = event.year
			end
		end
		if crop_schedule_class_id == 2 then
			case true
				when @highest_year > 1 && params[:year].to_i >= @highest_year
					if event.activity_id == 5 then @operation.year = 1 else @operation.year = @highest_year end
				when @highest_year > 1 && params[:year].to_i < @highest_year
					if event.activity_id == 5 then @operation.year = params[:year].to_i + 1 else @operation.year = params[:year].to_i end
			end
		end
		if event.crop_schedule_id == 4 && @highest_year > @operation.year && @operation.activity_id == 5 # ask if corp rotation is winter wheat and the highest year is > than the kill operation. Since the kill is first in the table we need to be sure where to put it.
			@operation.year += 1
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
			when 1 #planting operation. Take planting code from crop table and plant population as well
				@operation.type_id = Crop.find(@operation.crop_id).planting_code
				@operation.amount = plant_population
			when 2, 7
				fertilizer = Fertilizer.find(event.apex_fertilizer) unless event.apex_fertilizer == 0
				@operation.amount = event.apex_opv1
				if fertilizer != nil then
					@operation.type_id = fertilizer.fertilizer_type_id
				if @operation.type_id == 2 then @operation.amount * 1000 end
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
		end #end case
		@operation.depth = event.apex_opv2
		@operation.scenario_id = @scenario.id
		if @operation.save
			msg = add_soil_operation()
			notice = t('scenario.operation') + " " + t('general.created')
			unless msg.eql?("OK")
			raise ActiveRecord::Rollback
			end
		else
			raise ActiveRecord::Rollback
		end
		end # end events.each
  end  # end method

########################################### DOWNLOAD OPERATION IN XML FORMAT ##################
  def download
    #require 'open-uri'
    #require 'net/http'
    #require 'rubygems'

    operations = Operation.where(:scenario_id => params[:scenario_id])

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.operations {
	    operations.each do |operation|
			xml.operation {
			  xml.crop_id operation.crop_id
			  xml.activity_id operation.activity_id
			  xml.day operation.day
			  xml.month operation.month_id
			  xml.year operation.year
			  xml.type_id operation.type_id
			  xml.amount operation.amount
			  xml.depth operation.depth
			  xml.no3_n operation.no3_n
			  xml.po4_p operation.po4_p
			  xml.org_n operation.org_n
			  xml.org_p operation.org_p
			  xml.nh3 operation.nh3
			  xml.subtype_id operation.subtype_id
			  #soil_operations = SoilOperation.where(:operation_id => operation.id)
			  #xml.soil_operations {
				#soil_operations.each do |so|
				  #save_soil_operation_information(xml, so)
				#end # end soil_operations.each
			  #} # end xml.soil_operation
			} # xml each operation end
		end # end operations.each
      } # end xml.operations
    end #builder do end

    file_name = session[:session_id] + ".opr"
    path = File.join(DOWNLOAD, file_name)
    content = builder.to_xml
    File.open(path, "w") { |f| f.write(content) }
    #file.write(content)
    send_file path, :type => "application/xml", :x_sendfile => true
  end
  #download operation def end

  ########################################### UPLOAD CROPPING SYSTEM FILE IN XML FORMAT ##################
  def upload_system
    saved = false
    msg = ""
    ActiveRecord::Base.transaction do
		#begin
		if params[:Cropping_system] == nil then
			redirect_to open_operation_path
			flash[:notice] = t('general.please') + " " + t('general.select') + " " + t('models.project') and return false
		end
		@data = Nokogiri::XML(params[:Cropping_system])

		@data.root.elements.each do |node|
			case node.name
			  when "operation"
				msg = upload_operation_info(node, params[:scenario_id], params[:field_id])
			  else
			end
		end
    end
	redirect_to project_field_scenario_operations_path(params[:project_id], params[:field_id], params[:scenario_id])
  end

  def open
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
  end

  #########################################################################################################################
  ############## private methods - Just to be seen from inside this controller. ###########################################
  private

# Use this method to whitelist the permissible parameters. Example:
# params.require(:person).permit(:name, :age)
# Also, you can specialize this method with per-user checking of permissible attributes.
  def operation_params
    params.require(:operation).permit(:amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id, :moisture)
  end

  def add_soil_operation()
    @project = Project.find(params[:project_id])
    @field = Field.find(params[:field_id])
    @scenario = Scenario.find(params[:scenario_id])
    soils = Soil.where(:field_id => Scenario.find(@operation.scenario_id).field_id)
    msg = "OK"
    soils.each do |soil|
      if msg.eql?("OK")
        msg = update_soil_operation(SoilOperation.new, soil.id, @operation)
      else
        break
      end
    end
    return msg
  end

  def upload_operation_info(node, scenario_id, field_id)
    @operation = Operation.new
    @operation.scenario_id = scenario_id
    event_id = 0
    scenario = ""
    apex_till_code = 0
    node.elements.each do |p|
      case p.name
        when "crop_id"
          @operation.crop_id = p.text
        when "activity_id"
          @operation.activity_id = p.text
        when "year"
          @operation.year = p.text
        when "month"
          @operation.month_id = p.text
        when "day"
          @operation.day = p.text
        when "type_id"
          @operation.type_id = p.text
        when "amount"
          @operation.amount = p.text
        when "depth"
          @operation.depth = p.text
        when "no3_n"
          @operation.no3_n = p.text
        when "po4_p"
          @operation.po4_p = p.text
        when "org_n"
          @operation.org_n = p.text
        when "org_p"
          @operation.org_p = p.text
        when "nh3"
          @operation.nh3 = p.text
        when "subtype_id"
          @operation.subtype_id = p.text.to_i
      end # case
    end # end each
    if @operation.save then
      soils = Soil.where(:field_id => field_id)
      soils.each do |soil|
		update_soil_operation(SoilOperation.new, soil.id, @operation)
      end # end soils.each
      return "OK"
    else
      return "Error saving operation"
    end
  end

  def update_amount()
	  if @operation.activity_id == 2 and @operation.type_id == 2 then @operation.amount *= 2000 end
	  @operation.save
  end

end #end class
