class SessionsController < ApplicationController

  def create  #runs when logging in.
    if user = User.authenticate(params[:email], params[:password])  # authenticated user 
	  session[:user_id] = user.id
	  session[:status] = "signed"									# store user id in session
	  redirect_to welcomes_index_path, :notice => "Logged in successfully"	# redirect is successful	  
	else
	  flash.now[:alert] = "Invalid login/password combination"		# alert if error
	  render :action => 'index'										# redirect to the same page
	end
  end

####################### INDEX  ##########################################################
  def index  
    if session[:status] == "signed"  # authenticate user 
	  redirect_to welcomes_index_path, :notice => "Already loged"	#run when comes to web page and user is already logged in
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
    reset_session													# reset all of the values for the current session
    redirect_to login_path, :notice => "You successfully logged out"	# redirect
	session[:user_id] = ""
	session[:status] = ""									# store user id in session
  end
end
