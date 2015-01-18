class UsersController < ApplicationController

  def update
    puts "user params **** #{user_params}"
    current_user.update!(user_params)
    redirect_to user_repos_path, :flash => { :notice => "Settings saved" }
  end

  private

  def user_params
    params[:user].permit(:repos_attributes => [ :id, :email_frequency ])
  end
end 
