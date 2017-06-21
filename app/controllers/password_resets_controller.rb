class PasswordResetsController < ApplicationController

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
end
