class PurchasedStock < ActiveRecord::Base
  attr_accessible :money_earned, :money_spent, :stock_code, :total_qty, :user_game_id, :value_in_stocks

  # Relationships
  has_many :transactions
  belongs_to :user_game

  # Scope
  # -----------------------------
  scope :for_game, lambda { |x| joins(:user_game).where("game_id = ?", x) }

end
