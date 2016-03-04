class WelcomesController < ApplicationController
  def show
  end

  def index
     @projects = Project.where(:user_id => session[:user_id])
     redirect_to user_projects_path(@projects)
	 #redirect_to :controller => :projects, :action => "index", :locale => "en", :projects => @projects
  end
end 
