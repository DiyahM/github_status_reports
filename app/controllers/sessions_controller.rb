class SessionsController < ApplicationController

  def create
    @current_user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @current_user.id
    redirect_to user_repos_path
  end

  def destroy
    @current_user = nil
    redirect_to root_path
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
