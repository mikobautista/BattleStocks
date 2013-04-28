class UserGame < ActiveRecord::Base
  attr_accessible :balance, :game_id, :is_active, :points, :total_value_in_stocks, :user_id, :get_rank

  # Relationships
  # -----------------------------
  has_many :purchased_stocks
  belongs_to :user
  belongs_to :game

  # Validations
  # -----------------------------
  validates_presence_of :game_id
  validates_presence_of :user_id
  validates_presence_of :balance
  #validates_presence_of :is_active
  validates_presence_of :points
  validates_presence_of :total_value_in_stocks

  validates_numericality_of :balance, :greater_than_or_equal_to => 0
  validates_numericality_of :total_value_in_stocks, :greater_than_or_equal_to => 0 
  validates_numericality_of :points, :greater_than_or_equal_to => 0
  validates :is_active, :inclusion => {:in => [true, false]}

  #Scopes
  # -----------------------------
  scope :by_portfolio_value, order('balance + total_value_in_stocks DESC')
  scope :for_game, lambda { |game_id| where("game_id = ?", game_id) }
  scope :for_user, lambda { |user_id| where("user_id = ?", user_id) }
  scope :current, joins(:game).where('start_date <= ?', Time.now).where('end_date > ?', Time.now).where('is_terminated = ?', false)
  scope :upcoming, joins(:game).where('start_date > ?', Time.now).where('is_terminated = ?', false)
  scope :past, joins(:game).where('end_date <= ?', Time.now)
  scope :ending_soonest, joins(:game).order('end_date, start_date')
  scope :starting_soonest, joins(:game).order('start_date, end_date')
  scope :most_recent, joins(:game).order('end_date DESC, start_date DESC')
  scope :alphabetical, joins(:user).order('username')

  # Methods
  # -----------------------------
  
  # Gets the rank of a user playing in a game. Ties are resolved by checking the portfolio value of the person before (and so on if they're equal).
  def get_rank
    hash = Hash[UserGame.for_game(self.game.id).by_portfolio_value.map.with_index.to_a]
    if hash[self] == 0
      return 1
    else
      x = hash[self]
      while x > 0 && hash.key(x).get_portfolio == hash.key(x-1).get_portfolio
          x -= 1
      end
      return x + 1
    end
  end
  
  # Adds available balance and total value in stocks
  def get_portfolio
    return self.total_value_in_stocks + self.balance
  end

  # Gets the return on investment of a user (value changed in stocks), from purchasing stocks to current
  def get_ROI
    require 'yahoo_stock'

    stocks = []
    qtys = []
    for purchase in PurchasedStock.for_user_game(self.id)
      stocks += [purchase.stock_code]
      qtys += [purchase.total_qty]
    end

    values = [0] * stocks.length
    for i in (0..stocks.length-1)
      yesterday_price = (YahooStock::History.new(:stock_symbol => stocks[i], :start_date => Date.today-1, :end_date => Date.today-1)).results(:to_array).output[0][4].to_f
      values[i] = yesterday_price
    end

    qtys_and_values = [0] * stocks.length
    for i in (0..stocks.length-1)
      qtys_and_values[i] = [qtys[i] * values[i]]
    end
    total_value = 0
    for price in qtys_and_values
      total_value += price[0]
    end
    return (self.total_value_in_stocks-(total_value * 100))/(total_value * 100)
  end
end
