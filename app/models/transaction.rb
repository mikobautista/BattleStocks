class Transaction < ActiveRecord::Base
  attr_accessible :date, :is_buy, :purchased_stock_in, :qty, :value_per_stock
end
