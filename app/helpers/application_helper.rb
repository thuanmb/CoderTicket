module ApplicationHelper
  def current_user
    return nil if !session[:user_id] || !User.where(id: session[:user_id]).presence

    @current_user ||= User.find(session[:user_id])
  end

  def signed_in?
    current_user
  end

  def require_login
    if !signed_in?
      flash[:error] = 'Please login!'
      redirect_to login_path
    end
  end
end
