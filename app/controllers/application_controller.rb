class ApplicationController < ActionController::Base
	#protect_from_forgery   #this will clear all of the session code added. If we need to add this for some reason, no needed now, will have to find a way to retrieve the session information such us send them to map and map send them back. Oscar Gallego.
  	include SessionsHelper
	before_filter :set_locale
	before_filter :set_breadcrumbs

	def set_locale
	  I18n.locale = params[:locale] || I18n.default_locale
	end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_breadcrumbs	
	add_breadcrumb t('general.home'), :root_path
	add_breadcrumb t('menu.projects'), :root_path
	
	if params[:project_id] != nil then 
		@project = Project.find(params[:project_id]) 
		add_breadcrumb @project.name		
	end
	if params[:field_id] != nil and params[:field_id].to_i != 0 then
		@field = Field.find(params[:field_id])
		add_breadcrumb t('menu.fields'), project_fields_path(@project)
		add_breadcrumb @field.field_name
	end
	if params[:scenario_id] != nil then
		@scenario = Scenario.find(params[:scenario_id])
		add_breadcrumb t('menu.scenarios'), project_field_scenarios_path(@project, @field)
		add_breadcrumb @scenario.name
	end
  end  # end method

  ################## Read all of the tables in the DB and create a seed file ##################
  def create_seeds
	files_string = ""
	tables = ActiveRecord::Base.connection.tables
	i = 0
	tables.each do |table|
		if ActiveRecord::Base.connection.table_exists? table then
			if i == 0 then
				i+=1
				next
			end
			create_seed(table)			
			files_string += "file = " + "\"" + File.join(Rails.root, 'db', 'seeds', table + '.rb') +"\"" + "\n" + "load file" + "\n" + "\n"
		end
	end
	print_string(files_string, File.join(Rails.root, 'db', 'seeds', 'seeds.rb'))
  end

  def create_seed(table)
	type = table.classify.constantize
	@record_string = ""
    table_name = type.to_s
    # delete all of the records for the table
    @record_string += table_name + ".delete_all" + "\n"
	# take all ot the columns and rows of the table
	
	columns = type.column_names
	records = type.all
	#read record by record and create a line for each record in the seeds file
	records.each do |record|
		first = true
		@record_string += table_name + ".create!({"
		columns.each do |column|
			if column == "created_at" || column == "updated_at" then next end
			if first == false then @record_string += "," end
			first = false
			value = record[column.to_sym]
			case true
				when (value.class.to_s.include? "String")
					@record_string += ":" + column + " => \"" + value.to_s + "\""
				when (value.class.to_s.include? "NilClass")
					@record_string += ":" + column + " => " + "nil"
				when (value.class.to_s.include? "TimeWithZone")
					@record_string += ":" + column + " => \"" + value.to_s + "\""
				else
					@record_string += ":" + column + " => " + value.to_s
		    end
		end
		if table_name == "User" then
			@record_string += ",:password => '1234'"
		end
		@record_string += "}, :without_protection => true)" + "\n"
	end
	@record_string += "\n"
	print_string(@record_string, File.join(Rails.root, 'db', 'seeds', table + '.rb'))
  end

  def print_string(data, file)
    #path = File.join(APEX, "APEX" + session[:session_id])
    #FileUtils.mkdir(path) unless File.directory?(path)
    path = File.join(file)
    File.open(path, "w+") do |f|
      f << data
      f.close
    end
  end

  ################## ERASE ALL PROJECTS AND CORRESPONDING FILES ##################
  def self.wipe_database
    ApexControl.delete_all
    ApexParameter.delete_all
    Bmp.delete_all
    Chart.delete_all
    Climate.delete_all
    Field.delete_all
    Layer.delete_all
    Location.delete_all
    Operation.delete_all
    Project.delete_all
    Result.delete_all
    Scenario.delete_all
    Site.delete_all
    Soil.delete_all
    SoilOperation.delete_all
    Subarea.delete_all
    Watershed.delete_all
    WatershedScenario.delete_all
    Weather.delete_all
  end
end  # end class
