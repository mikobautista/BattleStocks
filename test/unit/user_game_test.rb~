require 'test_helper'

class UserGameTest < ActiveSupport::TestCase
  # Relationships
  # -----------------------------
  should have_many :purchased_stocks
  should belong_to :user
  should belong_to :game

  # Validations
  # -----------------------------
  should validate_presence_of :user_id
  should validate_presence_of :game_id
end
