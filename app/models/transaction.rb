class Transaction < ActiveRecord::Base
  attr_accessible :date, :is_buy, :purchased_stock_id, :qty, :value_per_stock, :stock_code, :game_id
  attr_accessor :stock_code, :game_id

  # Relationships
  belongs_to :purchased_stock

  # Callbacks
  before_create :get_price_and_update_purchased_stock_and_user_game

  def get_price_and_update_purchased_stock_and_user_game
  	require 'yahoo_stock'
    @purchase = self.purchased_stock
    @user_game = self.purchased_stock.user_game
  	self.value_per_stock = ((YahooStock::Quote.new(:stock_symbols => [@purchase.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
    money_involved = self.qty * self.value_per_stock
    if self.is_buy
      @purchase.total_qty += self.qty
      @purchase.money_spent += money_involved
      @purchase.value_in_stocks += money_involved
      @user_game.balance -= money_involved
      @user_game.total_value_in_stocks += money_involved
    else
      @purchase.total_qty -= self.qty
      @purchase.money_earned += money_involved
      @purchase.value_in_stocks -= money_involved
      @user_game.balance += money_involved
      @user_game.total_value_in_stocks -= money_involved
    end
    @purchase.save!
    @user_game.save!
  end

end
