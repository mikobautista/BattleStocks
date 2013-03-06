class Game < ActiveRecord::Base
  attr_accessible :budget, :end_date, :is_terminated, :manager_id, :name, :start_date, :winner_id

  # Relationships
  has_many :invitations
  has_many :user_games
  has_many :users, :through => :user_games

  # Callbacks
  # -----------------------------
  before_create :dollars_to_cents

  # Scope
  # -----------------------------
  scope :for_user, lambda { |x| joins(:user_games).where("user_id = ?", x) }

def dollars_to_cents
	self.budget *= 100
end

end
