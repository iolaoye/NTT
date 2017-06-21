class PasswordResetsController < ApplicationController
  before_filter :get_user, only: [:edit, :update]
  before_filter :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:error] = "Email address not found"
      render "new"
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      sign_in @user
      flash[:notice] = "Password has been reset."
      redirect_to @user
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
