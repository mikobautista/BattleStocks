require 'test_helper'

class PurchasedStockTest < ActiveSupport::TestCase
  # relationship macros 
  should have_many(:transactions)
  # test "the truth" do
  #   assert true
  # end
  should belong_to(:user_game)
end
