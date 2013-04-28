class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.string :email
      t.integer :total_points, :default => 0
      t.boolean :is_admin, :default => false
      t.boolean :is_active, :default => true
      t.string :auth_token

      t.timestamps
    end
  end
end
