class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to welcomes_path
    else
      flash[:error] = "Email address not found"
      redirect_to welcomes_path
    end
  end

  def edit
  end

  def update
    if (params[:user][:password].empty? || params[:user][:password_confirmation].empty?)
      flash[:error] = "Password can't be empty"
      render 'edit'
    elsif (!params[:user][:password].eql?(params[:user][:password_confirmation]))
      flash[:error] = "Password does not match the confirmation password"
      render 'edit'
    elsif @user.update_attributes(user_params)
      session[:user_id] = @user.id
      redirect_to user_projects_path(current_user.id), :notice => "Password has been reset"
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by_email(params[:email])
    end

    def check_expiration
      if @user.password_reset_expired?
        flash.now[:error] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

end
