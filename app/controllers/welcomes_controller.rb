class WelcomesController < ApplicationController

  layout 'welcome'

  def show
  end

  def new
    @user = User.new
  end

  def index
  	if signed_in?
      @projects = Project.where(:user_id => session[:user_id])
      redirect_to user_projects_path(current_user)
  	else
     	redirect_to new_welcome_path
	end
	 
	 #redirect_to :controller => :projects, :action => "index", :locale => "en", :projects => @projects
  end
end 
