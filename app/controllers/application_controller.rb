class ApplicationController < ActionController::Base
	#protect_from_forgery   #this will clear all of the session code added. If we need to add this for some reason, no needed now, will have to find a way to retrieve the session information such us send them to map and map send them back. Oscar Gallego.
  	include SessionsHelper
	before_filter :set_locale
	 
	def set_locale
	  I18n.locale = params[:locale] || I18n.default_locale
	end

   def default_url_options(options = {})
     { locale: I18n.locale }.merge options
   end
end
