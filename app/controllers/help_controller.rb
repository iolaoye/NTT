class HelpController < ApplicationController
	def index
		@project = Project.find(params[:project_id])
	end
	
	def show
		@project = Project.find(params[:project_id])
		render template: "help/#{params[:page]}"
	end
	
end
