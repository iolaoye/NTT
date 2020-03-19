include ScenariosHelper

class OperationsController < ApplicationController
  include ScenariosHelper
  require "open-uri"
################################  INDEX  #################################
# GET /operations
# GET /operations.json
def index
    #console
    add_breadcrumb t('menu.operations')
    if params[:bmp_ccr] != nil then
      add_cover_crop
    end
    crop_schedule()
    @operations = @operations.reorder("year, month_id, day, rotation, crop_id")
    #@rotations = @scenario.operations.where(:activity_id => 1).reorder("year, month_id, day, rotation, crop_id").select("rotation, crop_id").distinct
    @rotations = @scenario.operations.reorder("rotation, crop_id").select("rotation, crop_id").distinct
    if @operations.last != nil
      @highest_year = @operations.last.year
      else
      @highest_year = 0
    end
    
    respond_to do |format|
      format.html
      #Sformat.html # index.html.erb
      format.json { render json: @operations }
    end
  end
########################################################################
## add a new cover crop. this is adding as a planting operation with
## subtype_id at 1 to identify it as cover crop
  def add_cover_crop
    operation = Operation.new
    operation.crop_id = params[:bmp_ccr][:crop_id]
    operation.year = params[:bmp_ccr][:year]
    operation.month_id = params[:bmp_ccr][:month]
    operation.day = params[:bmp_ccr][:day]
    operation.activity_id = 1
    operation.type_id = params[:bmp_ccr][:type_id]
    operation.subtype_id = 1
    operation.scenario_id = @scenario.id
    operation.rotation = params[:bmp_ccr][:year]
    operation.amount = Crop.find_by_id(params[:bmp_ccr][:crop_id]).plant_population_ft
    if operation.save
      add_soil_operation(operation)
      if @scenario.operations.where("subtype_id = 1 and activity_id = 1").count > 1 then
        #means there are more than one crop rotation. Advice user to average seeding
        flash[:alert] = t('scenario.cover_crop_info')
      end
      flash[:notice] = t('scenario.cover_crop_added')
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
    @operation.rotation = params[:rotation]
    @operation.activity_id = params[:operation]  #this is used only in Add specific operation i.e "Add Planting Operation" in crop view. Otherwise is nil.
    @operation.crop_id = params[:crop]
    @crops = Crop.load_crops(@project.location.state_id)
    @fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true).order("name")

    cc_operation = @scenario.operations.where(:activity_id => 5).last
    if cc_operation != nil
      @cc_plt_date = Date.parse(sprintf("%2d", cc_operation.year) + "/" + sprintf("%2d", cc_operation.month_id) + "/" + sprintf("%2d", cc_operation.day))
      @cc_plt_date += 2.days
    end

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
    @operation = Operation.find(params[:id])
    #find the crop lu_number to know if it is tree or not
    @lu_number = Crop.find(@operation.crop_id).lu_number
    #if @operation.activity_id == 2 && @operation.type_id == 1 && @operation.po4_p > 0 && @operation.po4_p < 100 then
      #@operation.po4_p = (@operation.po4_p / PO4_TO_P2O5).round(1)
    #end
    if @operation.activity_id == 1 && @operation.subtype_id == 1 then
      @crops = Crop.where("type1 like '%CC%'")
    else
      @crops = Crop.load_crops(Location.find_by_project_id(@project.id).state_id)
    end
    @fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true).order("name")
    add_breadcrumb 'Operations', project_field_scenario_operations_path(@project, @field, @scenario)
    add_breadcrumb t('operation.edit')
  end

################################  CREATE  #################################
# POST /operations
# POST /operations.json
  def create
    msg = "OK"
    saved = false
    soil_op_saved = false
    
    ActiveRecord::Base.transaction do
      case true
      when params[:op] != nil
        if params[:op][:activity_id] != "7" && params[:op][:activity_id] != "9"
          calculate_nutrients(params[:op][:total_n_con].to_f, params[:op][:moisture].to_f, params[:op][:total_p_con].to_f, params[:operation][:activity_id], params[:operation][:type_id], params[:operation][:subtype_id])
        end
      when params[:operation] != nil
        if params[:operation][:activity_id] != "7" && params[:operation][:activity_id] != "9"
          calculate_nutrients(params[:operation][:org_c].to_f, params[:operation][:moisture].to_f, params[:operation][:nh4_n].to_f, params[:operation][:activity_id], params[:operation][:type_id], params[:operation][:subtype_id])
        end
      end
      operation = Operation.new(operation_params)
      #calculate the days animals in field
      if operation.activity_id == 7 or operation.activity_id == 9 then
        operation.subtype_id = (Date.new(params[:year1].to_i,params[:month_id1].to_i,params[:day1].to_i) - Date.new(params[:operation][:year].to_i,params[:operation][:month_id].to_i,params[:operation][:day].to_i)).to_i + 1
      end
      operation.scenario_id = params[:scenario_id]
      if operation.activity_id == 9 then
        operation.moisture = params[:operation][:moisture]
        operation.nh4_n = params[:operation][:nh4_n]
      else
        operation.moisture = params[:op][:moisture] unless params[:op]  == nil
        operation.nh4_n = params[:op][:total_p_con] unless params[:op]  == nil
      end
      operation.org_c = params[:op][:total_n_con] unless params[:op]  == nil
      operation.rotation = params[:operation][:rotation]
      @crops = Crop.load_crops(@project.location.state_id)

      if operation.activity_id == 7 || operation.activity_id == 9
          if params[:access] != nil
            operation.org_c = 1
          else
            operation.org_c = 0
          end
      end
      if operation.save
        #saves start grazing operation in SoilOperation table
        if operation.activity_id != 9 && operation.activity_id != 10 then
          msg = add_soil_operation(operation)
        end
        saved = true
        #operations should be created in soils too. but not for rotational grazing
        if msg.eql?("OK")
          soil_op_saved = true
        else
          soil_op_saved = false
          raise ActiveRecord::Rollback
        end
        if operation.activity_id == 7 || operation.activity_id == 9 then
          operation_id = operation.id
          operation1 = Operation.new(operation_params)
          if operation.activity_id == 7 then
            operation1.activity_id = 8
          else
            operation1.activity_id = 10
          end
          operation1.year = params[:year1]
          operation1.month_id = params[:month_id1]
          operation1.day = params[:day1]
          operation1.type_id = operation_id
          operation1.scenario_id = params[:scenario_id]
          operation1.amount = 0
          operation1.depth = 0
          operation1.no3_n = 0
          operation1.po4_p = 0
          operation1.org_n = 0
          operation1.org_p = 0
          operation1.nh3 = 0
          operation1.subtype_id = 0
          operation1.rotation = params[:operation][:rotation]
          operation1.save
          if operation1.activity_id == 8 then
            msg = add_soil_operation(operation1)
            if msg.eql?("OK")
              soil_op_saved = true
            else
              soil_op_saved = false
              raise ActiveRecord::Rollback
            end
          end
        end
      else
        saved = false
      end

      respond_to do |format|
        if saved
          if soil_op_saved
            if params[:add_more] == t('submit.add_more') && params[:finish] == nil
              format.html { redirect_to new_project_field_scenario_operation_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
              format.json { render json: operation, status: :created, location: operation }
            elsif params[:finish] == t('submit.finish') && params[:add_more] == nil
              format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('scenario.operation') + " " + t('general.created') }
              format.json { render json: operation, status: :created, location: operation }
            end
          else
            @fertilizers = Fertilizer.where(:fertilizer_type_id => operation.type_id, :status => true).order("name")
            format.html { render action: "new" }
            format.json { render json: msg, status: :unprocessable_entity }
          end
        else
          @fertilizers = Fertilizer.where(:fertilizer_type_id => operation.type_id, :status => true).order("name")
          @operation = operation
          format.html { render action: "new" }
          format.json { render json: operation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

################################  UPDATE  #################################
# PATCH/PUT /operations/1
# PATCH/PUT /operations/1.json
  def update
    if params[:operation][:activity_id] != "7" && params[:operation][:activity_id] != "9"
      calculate_nutrients(params[:operation][:org_c].to_f, params[:operation][:moisture].to_f, params[:operation][:nh4_n].to_f, params[:operation][:activity_id], params[:operation][:type_id], params[:operation][:subtype_id])
    end
    @operation = Operation.find(params[:id])
    @crops = Crop.load_crops(@project.location.state_id)
    @fertilizers = Fertilizer.where(:fertilizer_type_id => @operation.type_id, :status => true).order("name")
    respond_to do |format|
      if @operation.update_attributes(operation_params)
        if params[:operation][:activity_id] == "7" || params[:operation][:activity_id] == "9" 
          if params[:access] != nil
            @operation.org_c = 1
          else
            @operation.org_c = 0
          end
          #calculate the days animals in field
          @operation.subtype_id = (Date.new(params[:year1].to_i,params[:month_id1].to_i,params[:day1].to_i) - Date.new(params[:operation][:year].to_i,params[:operation][:month_id].to_i,params[:operation][:day].to_i)).to_i + 1
          @operation.save
        end
        SoilOperation.where("operation_id = ? OR (type_id = ? AND apex_operation = ?)", @operation.id, @operation.id, 427).delete_all  #delete updated soilOperation and create the new ones.
        if @operation.activity_id != 9 && @operation.activity_id != 10 then add_soil_operation(@operation) end
        if @operation.activity_id == 7 || @operation.activity_id == 9 then
          if (Operation.find_by_type_id(@operation.id) != nil) then
            @operation1 = Operation.find_by_type_id(@operation.id)
          else
            operation_id = @operation.id
            @operation1 = Operation.new(operation_params)
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
          if @operation.activity_id == 7 then
            @operation1.activity_id = 8
          else
            @operation1.activity_id = 10
          end
          @operation1.year = params[:year1]
          @operation1.month_id = params[:month_id1]
          @operation1.day = params[:day1]
          @operation1.save
          if @operation1.activity_id != 9 && @operation1.activity_id != 10 then add_soil_operation(@operation1) end
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
    operation = Operation.find(params[:id])
    soil_operations = SoilOperation.where(:operation_id => operation.id)
    if operation.activity_id == 7 || operation.activity_id == 9 then
      #delete stop grazing linked to this grazing operation
      stop_op = Operation.find_by_type_id(operation.id)
      if stop_op != nil then stop_op.destroy end
    end
    if operation.destroy
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
    @operations = @scenario.operations.where(:crop_id => params[:id], :rotation => params[:rotation])
    @operations.destroy_all
    respond_to do |format|
      format.html { redirect_to project_field_scenario_operations_path(@project, @field, @scenario), notice: t('notices.all') }
      format.json { head :no_content }
    end
  end

################################  CALL WHEN CLICK IN UPLOAD CROPPING SYSTEM  #################################
  def cropping_system
    @operations = @scenario.operations
    
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
            operation = Operation.new
            operation.scenario_id = params[:scenario_id]
            #get crop_id from croppingsystem and state_id
            state_id = Location.find(session[:location_id]).state_id
            crop = Crop.find_by_number_and_state_id(event.apex_crop, state_id)
            if crop == nil then
              crop = Crop.find_by_number_and_state_id(event.apex_crop, '**')
            end
            plant_population = crop.plant_population_ft
            operation.crop_id = crop.id
            operation.activity_id = event.activity_id
            operation.day = event.day
            operation.month_id = event.month
            if params[:replace] != nil
              #replace
              operation.year = event.year
            else
              #don't replace
              if @count > 0
                operation.year = event.year + params[:year].to_i - 1
              else
                operation.year = event.year
              end
            end
            #type_id is used for fertilizer and todo (others. identify). FertilizerTypes 1=commercial 2=manure
            #note fertilizer id and code are the same so far. Try to keep them that way
            operation.type_id = 0
            operation.no3_n = 0
            operation.po4_p = 0
            operation.org_n = 0
            operation.org_p = 0
            operation.nh3 = 0
            operation.subtype_id = 0
            case operation.activity_id
              when 1 #planting operation. Take planting code from crop table and plant population as well
                operation.type_id = Crop.find(operation.crop_id).planting_code
                operation.amount = plant_population
              when 2, 7
                fertilizer = Fertilizer.find(event.apex_fertilizer) unless event.apex_fertilizer == 0
                operation.amount = event.apex_opv1
                if fertilizer != nil then
                  operation.type_id = fertilizer.fertilizer_type_id
                  operation.no3_n = fertilizer.qn
                  operation.po4_p = fertilizer.qp
                  operation.org_n = fertilizer.yn
                  operation.org_p = fertilizer.yp
                  operation.nh3 = fertilizer.nh3
                  operation.subtype_id = event.apex_fertilizer
                end
              when 3
                operation.type_id = event.apex_operation
              else
                operation.amount = event.apex_opv1
            end #end case
            operation.depth = event.apex_opv2
            operation.scenario_id = params[:scenario_id]
            if operation.save
              msg = add_soil_operation(operation)
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
    @operations = Operation.where(:scenario_id => params[:scenario_id])
    @count = @operations.count
    @highest_year = 0
    @operations.each do |operation|
      if (operation.year > @highest_year)
        @highest_year = operation.year
      end
    end
    state_id = @project.location.state_id
    if state_id < 10 then
      state_id_text = "0" + state_id.to_s
    else
      state_id_text = state_id.to_s
    end

    @cropping_systems = CropSchedule.where(:status => true, :class_id => 1).where("state_id LIKE ? OR state_id LIKE ?", "%#{state_id_text}%","*")
    @tillages = CropSchedule.where(:state_id => state_id, :status => true).where("class_id = 3")
    if @cropping_systems.blank? then
      @cropping_systems = CropSchedule.where(:state_id => "*", :status => true).where("class_id < 2")
    end
    if @tillages.blank? then
      @tillages = CropSchedule.where(:state_id => "*", :status => true).where("class_id = 3")
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

    if params[:language] != nil then
      if params[:language][:language].eql?("es")
          I18n.locale = :es
      else
          I18n.locale = :en
      end
    end
  end # end method

########################################### Create_tillage_rotation ##################
  def create_tillage
    #take the event for the tillage selected and add to the operation and soilOperaition files for the scenario selected.
    events = Schedule.where(:crop_schedule_id => params[:tillage][:id])
    events.each do |event|
      operation = Operation.new
      operation.scenario_id = params[:scenario_id]
      if @crop == nil then
        @crop_temp = Operation.where("year = ? and scenario_id = ? and activity_id > ?", event.year, params[:scenario_id], 0).last
        if @crop_temp == nil or @crop_temp.blank? then  #if @crop still nil finish
          break
        else
          @crop = Crop.find(@crop_temp.crop_id)
        end
      end
      operation.crop_id = @crop.id
      #plant_population = @crop.plant_population_ft
      operation.activity_id = event.activity_id
      operation.day = event.day
      operation.month_id = event.month
      if params[:replace] != nil
        #replace
        operation.year = event.year
      else
        #don't replace
        if @count > 0
          operation.year = event.year + params[:year].to_i - 1
        else
          operation.year = event.year
        end
      end
      #type_id is used for fertilizer and todo (others. identify). FertilizerTypes 1=commercial 2=manure
      #note fertilizer id and code are the same so far. Try to keep them that way
      operation.type_id = 0
      operation.no3_n = 0
      operation.po4_p = 0
      operation.org_n = 0
      operation.org_p = 0
      operation.nh3 = 0
      operation.subtype_id = 0
      operation.type_id = event.apex_operation
      operation.depth = event.apex_opv2
      operation.scenario_id = @scenario.id
      operation.rotation = operation.year
      if operation.save
        msg = add_soil_operation(operation)
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
    add_field_operations(params[:replace], params[:scenario_id], params[:cropping_system][:id], params[:year], params[:tillage][:id])
  end  # end method

########################################### DOWNLOAD OPERATION IN XML FORMAT ##################
  def download
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
    params.require(:operation).permit(:amount, :crop_id, :day, :depth, :month_id, :nh3, :no3_n, :activity_id, :org_n, :org_p, :po4_p, :type_id, :year, :subtype_id, :moisture, :org_c, :nh4_n, :rotation)
  end

  def add_soil_operation(operation)
    soils = @field.soils
    msg = "OK"
    soils.each do |soil|
      if msg.eql?("OK")
        msg = update_soil_operation(SoilOperation.new, soil.id, operation)
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

end #end class
