class PurchasedStock < ActiveRecord::Base
  attr_accessible :money_earned, :money_spent, :stock_code, :total_qty, :user_game_id, :value_in_stocks, :get_price

  # Relationships
  # -----------------------------
  has_many :transactions
  belongs_to :user_game

  # Callbacks
  # -----------------------------
  before_create :stock_code_upper

   
  # Validations
  # -----------------------------

  validates_format_of :stock_code, :with => /.+/, :message => "stock_code cannot be blank"
  validates_numericality_of :money_earned, :greater_than_or_equal_to => 0
  validates_numericality_of :money_spent, :greater_than_or_equal_to => 0
  validates_numericality_of :total_qty, :greater_than_or_equal_to => 0
  validates_numericality_of :value_in_stocks, :greater_than_or_equal_to => 0

  validates_presence_of :money_earned
  validates_presence_of :money_spent
  validates_presence_of :stock_code
  validates_presence_of :total_qty
  validates_presence_of :user_game_id
  validates_presence_of :value_in_stocks

  # Scope
  # -----------------------------
  scope :for_user_game, lambda { |x| where("user_game_id = ?", x) }
  scope :for_game, lambda { |x| joins(:user_game).where("game_id = ?", x) }
  scope :for_user, lambda { |x| joins(:user_game).where("user_id = ?", x) }
  scope :nonzero_cost_basis, where("money_spent > ?", 0)
  scope :nonzero, where("total_qty > ?", 0)

  # Methods
  # -----------------------------
  def stock_code_upper
  	self.stock_code.upcase!
  end

  def get_price
    require 'yahoo_stock'
    return ((YahooStock::Quote.new(:stock_symbols => [self.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
  end

  # searches for all stocks by name
  def self.search(search)
    if search
      require 'yahoo_stock'
      return ((YahooStock::Quote.new(:stock_symbols => [search]).results(:to_array).output[0][1].to_f) * 100).to_i
    end
  end

end
