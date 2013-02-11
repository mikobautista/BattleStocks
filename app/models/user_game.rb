class UserGame < ActiveRecord::Base
  attr_accessible :balance, :game_id, :is_active, :points, :total_value_in_stocks, :user_id

  # Relationships
  has_many :purchased_stocks
  belongs_to :user
  belongs_to :game

end
