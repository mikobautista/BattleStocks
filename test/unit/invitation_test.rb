hrequire 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # relationship macros
  should belong_to(:game)
  should have_many(:transactions)
  
  # validations 
  should validate_presence_of(:email)
  should validate_presence_of(:game_id)
  
  should allow_value("Jonathan@gmail.com").for(:email)
  should allow_value("ab123@yahoo.com").for(:email)
  
  should_not allow_value("Jonathan!!!gmail.com").for(:email)

end
