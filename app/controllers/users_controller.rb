class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(request_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.name}"

        #MessageMailer.welcome_email(@user, get_root_path).deliver_later

        format.html {redirect_to root_path }
      else
        flash[:error] = @user.errors.full_messages.join(', ')

        format.html { render :action => :new }
      end
    end
  end

  private
    def request_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
