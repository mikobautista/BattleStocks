class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :purchased_stock_id
      t.datetime :date
      t.integer :qty
      t.integer :value_per_stock
      t.boolean :is_buy

      t.timestamps
    end
  end
end
