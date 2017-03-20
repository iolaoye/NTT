class UsersController < ApplicationController
	def index
		@user = User.new
	end

	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
	    respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @user }
        end
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				session[:user_id] = @user.id 		# store user id in session
				#format.html { redirect_to "welcomes/0", notice: 'User successfully added' }
				if ENV["APP_VERSION"] == "modified"
					format.html { redirect_to root_path, :notice => "User successfully added"	}# redirect is successful	  
				else
					format.html { redirect_to welcome_path(0), :notice => "User successfully added"	}# redirect is successful	  
				end
			else
				format.html { render action: :new }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
	  end
  end

  def edit
	set_user
  end

  def update
		if @user.update(user_params)
			#redirect_to welcomes_path, notice: 'Updated user information succesfully'
		else
			render action: 'edit'
		end
  end

  private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:email, :hashed_password, :name, :company, :password, :password_confirmation)
	end
end