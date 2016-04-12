class WelcomesController < ApplicationController
  def show
  end

  def index
  	if signed_in?
      @projects = Project.where(:user_id => session[:user_id])
      redirect_to user_projects_path(current_user)
  	else
     	redirect_to login_path
	end
	 
	 #redirect_to :controller => :projects, :action => "index", :locale => "en", :projects => @projects
  end
end 
