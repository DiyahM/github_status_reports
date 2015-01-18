class AddGhUsernameToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :nickname, :gh_username 
  end
end
