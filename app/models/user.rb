class User < ActiveRecord::Base
  attr_accessible :email, :is_active, :is_admin, :password, :total_points, :username
end
