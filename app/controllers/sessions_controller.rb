class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:user][:email])

    if !@user.presence
      flash[:error] = "User with #{params[:user][:email]} is not exist."

      render :action => :new

    elsif @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}"

      redirect_to root_path

    else
      flash[:error] = @user.errors.full_messages.join(', ')

      render :action => :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
