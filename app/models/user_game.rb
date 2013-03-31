class UserGame < ActiveRecord::Base
  attr_accessible :balance, :game_id, :is_active, :points, :total_value_in_stocks, :user_id, :get_rank

  # Relationships
  has_many :purchased_stocks
  belongs_to :user
  belongs_to :game

  #Scopes
  # -----------------------------
  scope :by_balance, order('balance DESC')
  scope :for_game, lambda { |x| where("game_id = ?", x) }
  scope :for_user, lambda { |x| where("user_id = ?", x) }
  scope :current, joins(:game).where('start_date <= ?', Time.now).where('end_date > ?', Time.now).where('is_terminated = ?', false)
  scope :ending_soonest, joins(:game).order('end_date, start_date')

  def get_rank
    hash = Hash[UserGame.for_game(self.game.id).by_balance.map.with_index.to_a]
    return hash[self] + 1
  end

end
