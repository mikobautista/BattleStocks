class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :manager_id
      t.integer :winner_id
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :budget
      t.boolean :is_terminated, :default => false

      t.timestamps
    end
  end
end
