class Invitation < ActiveRecord::Base
  attr_accessible :email, :game_id

  # Relationships
  belongs_to :game

end
