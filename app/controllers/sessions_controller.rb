class SessionsController < ApplicationController

  def create # runs when logging in.
    if user = User.authenticate(params[:email], params[:password]) # authenticated user
      session[:user_id] = user.id
      session[:status] = "signed" # store user id in session
      redirect_to user_projects_path(current_user.id), :notice => t('general.log_in') # redirect is successful
    else
      flash[:info] = "Invalid login/password combination" # alert if error
      redirect_to root_path # redirect to the same page
    end
  end

####################### INDEX  ##########################################################
  def index
    if signed_in? # authenticated user
      @projects = Project.where(:user_id => session[:user_id])
      redirect_to user_projects_path(current_user.id)
    else
      #render :action => 'new'
      #redirect_to "users/new"
    end
  end

####################### NEW  ##########################################################
  def new
    @user = User.new
    redirect_to users_new_path
  end

####################### DESTROY  ##########################################################
#destroy session on login out
  def destroy
    reset_session # reset all of the values for the current session
    redirect_to root_path, :notice => t('general.log_out') # redirect
    session[:user_id] = ""
    session[:status] = "" # store user id in session
    sign_out
  end
end
