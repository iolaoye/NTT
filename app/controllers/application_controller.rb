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
	add_breadcrumb 'Home', :root_path
	add_breadcrumb 'Projects', :root_path
	
	if params[:project_id] != nil then 
		@project = Project.find(params[:project_id]) 
		add_breadcrumb @project.name		
	end
	if params[:field_id] != nil and params[:field_id].to_i != 0 then
		@field = Field.find(params[:field_id])
		add_breadcrumb "Fields", project_fields_path(@project)
		add_breadcrumb @field.field_name
	end
	if params[:scenario_id] != nil then
		@scenario = Scenario.find(params[:scenario_id])
		add_breadcrumb "Scenarios", project_field_scenarios_path(@project, @field)
		add_breadcrumb @scenario.name
	end
  end  # end method

end  # end class
