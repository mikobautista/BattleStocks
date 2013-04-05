class Invitation < ActiveRecord::Base
  attr_accessible :email, :game_id

  # Relationships
  # -----------------------------
  belongs_to :game
  
  # Validations
  # -----------------------------
  validates_presence_of :game_id
  # email must be unique and in proper format
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

end
