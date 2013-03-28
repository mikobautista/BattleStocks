class Invitation < ActiveRecord::Base
  attr_accessible :email, :game_id

  # Relationships
  belongs_to :game
  
  # Validations
  validates_presence_of :game_id

end
