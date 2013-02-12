class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :email
      t.boolean :is_admin
      t.boolean :is_active
      t.integer :total_points

      t.timestamps
    end
  end
end
