class CreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string :email
      t.boolean :is_active
      t.boolean :is_admin
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :oauth_expires_at
      t.string :oauth_token
      t.string :provider
      t.integer :total_points
      t.string :uid

      t.timestamps
    end
  end
end
