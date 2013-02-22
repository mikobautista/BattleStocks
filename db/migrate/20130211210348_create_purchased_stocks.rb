class CreatePurchasedStocks < ActiveRecord::Migration
  def change
    create_table :purchased_stocks do |t|
      t.integer :user_game_id
      t.string :stock_code
      t.integer :total_qty, :default => 0
      t.integer :money_spent, :default => 0
      t.integer :money_earned, :default => 0
      t.integer :value_in_stocks, :default => 0

      t.timestamps
    end
  end
end
