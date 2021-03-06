class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :logged_in?

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def user_signed_in?
    if current_user.nil?
      redirect_to root_path, { flash: { error: "Please sign in first" } }
    end
  end
end
