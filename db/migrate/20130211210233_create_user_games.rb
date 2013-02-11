class CreateUserGames < ActiveRecord::Migration
  def change
    create_table :user_games do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :balance
      t.integer :points
      t.integer :total_value_in_stocks
      t.boolean :is_active

      t.timestamps
    end
  end
end
