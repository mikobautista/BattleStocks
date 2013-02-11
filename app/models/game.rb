class Game < ActiveRecord::Base
  attr_accessible :budget, :end_date, :is_terminated, :manager_id, :name, :start_date, :winner_id
end
