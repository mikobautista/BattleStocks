class CreatePurchasedStocks < ActiveRecord::Migration
  def change
    create_table :purchased_stocks do |t|
      t.integer :user_game_id
      t.string :stock_code
      t.integer :total_qty
      t.integer :money_spent
      t.integer :money_earned
      t.integer :value_in_stocks

      t.timestamps
    end
  end
end
