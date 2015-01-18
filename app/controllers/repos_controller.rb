class ReposController < ApplicationController
  before_action :user_signed_in?

  def edit
    @repos = current_user.repos.empty? ?
      current_user.get_repos :
      current_user.repos
  end
end

