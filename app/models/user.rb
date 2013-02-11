class User < ActiveRecord::Base
  attr_accessible :email, :is_active, :is_admin, :password, :total_points, :username

  # Relationships
  has_many :user_games
  has_many :games, :through => :user_games

end
