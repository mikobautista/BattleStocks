class Game < ActiveRecord::Base
  attr_accessible :budget, :end_date, :is_terminated, :manager_id, :name, :start_date, :winner_id

  # Relationships
  has_many :invitations
  has_many :user_games
  has_many :users, :through => :user_games

end
