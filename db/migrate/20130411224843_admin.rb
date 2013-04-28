class Admin < ActiveRecord::Migration
  def up
    admin = User.new
    admin.username = "Admin"
    admin.email = "admin@gmail.com"
    admin.password = "admin"
    admin.password_confirmation = "admin"
    admin.is_admin = true
    admin.total_points = 1000000
    admin.is_active = true
    admin.auth_token = "auth_token"
    admin.save!
  end

  def down
    admin = User.find_by_email "admin@example.com"
    User.delete admin
  end
end
