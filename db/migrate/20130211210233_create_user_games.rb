class CreateUserGames < ActiveRecord::Migration
  def change
    create_table :user_games do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :balance, :default => 0
      t.integer :points, :default => 0
      t.integer :total_value_in_stocks, :default => 0
      t.boolean :is_active, :default => true

      t.timestamps
    end
  end
end
