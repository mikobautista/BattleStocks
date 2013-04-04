class PurchasedStock < ActiveRecord::Base
  attr_accessible :money_earned, :money_spent, :stock_code, :total_qty, :user_game_id, :value_in_stocks

  # Relationships
  has_many :transactions
  belongs_to :user_game

  # Callbacks
  before_create :stock_code_upper

  # Scope
  # -----------------------------
  scope :for_user_game, lambda { |x| where("user_game_id = ?", x) }
  scope :for_game, lambda { |x| joins(:user_game).where("game_id = ?", x) }
  scope :for_user, lambda { |x| joins(:user_game).where("user_id = ?", x) }

  def stock_code_upper
  	self.stock_code.upcase!
  end

end
