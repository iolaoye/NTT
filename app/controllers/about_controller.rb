class AboutController < ApplicationController
	def index
		@user = User.find(session[:user_id])
	end
	
	def show
	end
end
