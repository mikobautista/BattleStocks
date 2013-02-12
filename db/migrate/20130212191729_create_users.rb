class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.string :email
      t.integer :total_points
      t.boolean :is_admin
      t.boolean :is_active

      t.timestamps
    end
  end
end
