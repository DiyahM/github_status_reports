class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.string :image
      t.string :access_token

      t.timestamps
    end
  end
end
