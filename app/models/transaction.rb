class Transaction < ActiveRecord::Base
  attr_accessible :date, :is_buy, :purchased_stock_id, :qty, :value_per_stock, :stock_code, :game_id
  attr_accessor :stock_code, :game_id

  # Relationships
  # -----------------------------
  belongs_to :purchased_stock

  # Callbacks
  # -----------------------------
  # validate :get_price_and_update_purchased_stock_and_user_game

  # Validations
  # -----------------------------
  validates_presence_of :date
  validates_presence_of :is_buy
  validates_presence_of :purchased_stock_id
  validates_presence_of :game_id
  validates_presence_of :qty
  validates_presence_of :value_per_stock
  validates_presence_of :stock_code
  
  validates_numericality_of :qty, :greater_than => 0
  #validates_format_of :qty, :with => /^[1-9]\d*/, :message => "should only be positive integers only without decimals"

  # Methods
  # -----------------------------

  def get_price_and_update_purchased_stock_and_user_game
    require 'yahoo_stock'
    @purchase = self.purchased_stock
    @user_game = self.purchased_stock.user_game
    self.value_per_stock = ((YahooStock::Quote.new(:stock_symbols => [@purchase.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
    # invalid stock code -> no such thing as free stocks
    # can't buy/sell negative stocks
    if self.value_per_stock == 0 or self.qty <= 0
      return false
    end
    money_involved = self.qty * self.value_per_stock
    # can't buy if not enough money
    if self.is_buy and @user_game.balance >= money_involved
      @purchase.total_qty += self.qty
      @purchase.money_spent += money_involved
      @purchase.value_in_stocks += money_involved
      @user_game.balance -= money_involved
      @user_game.total_value_in_stocks += money_involved
      @purchase.save!
      @user_game.save!
      return true
    # can't sell more than you currently have
    elsif (!self.is_buy) and @purchase.total_qty >= self.qty
      @purchase.total_qty -= self.qty
      @purchase.money_earned += money_involved
      @purchase.value_in_stocks -= money_involved
      @user_game.balance += money_involved
      @user_game.total_value_in_stocks -= money_involved
      @purchase.save!
      @user_game.save!
      return true
    else
      return false
    end
  end
end
