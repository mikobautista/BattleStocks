class Transaction < ActiveRecord::Base
  attr_accessible :date, :is_buy, :purchased_stock_id, :qty, :value_per_stock

  # Relationships
  belongs_to :purchased_stock

  # Callbacks
  before_create :get_price

  def get_price
  	require 'yahoo_stock'
  	rel_purchased_stock_code = PurchasedStock.find(self.purchased_stock_id).stock_code 
  	self.value_per_stock = ((YahooStock::Quote.new(:stock_symbols => [rel_purchased_stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
  end

end
