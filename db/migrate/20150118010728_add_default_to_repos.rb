class AddDefaultToRepos < ActiveRecord::Migration
  def change
    change_column :repos, :email_frequency, :string, :default => "off"
  end
end
