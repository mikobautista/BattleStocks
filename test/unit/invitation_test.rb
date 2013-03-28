hrequire 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # relationship macros
  should belong_to(:game)
  should have_many(:transactions)
  
  context "Creating one game" do
     # create the objects I want with factories
     setup do 
       @alex = FactoryGirl.create(:user, :email => "test@gmail.com", :username => "testuser1")
       @game1 = FactoryGirl.create(:game, :manager_id => @alex, :name => "test gameeee", :start_date => Time.now.to_date, 
       :end_date => 10.days.from_now.to_date, :budget => 10)
       @usergame1 = FactoryGirl.create(:user_game, :user_id => @alex, :game_id => @game1)
       @goog = FactoryGirl.create(:purchased_stock, :user_game => @usergame1, 
        :stock_code => 23, :total_quantity => 40, money_spent => 5000, :money_earned => 509000,
        :value_in_stocks => 80)
       @transaction1 = FactoryGirl.create(:transaction, :purchased_stock => @goog, :date => Time.now.to_date, :qty => 40, :value_per_stock => 45000, :is_buy => true)
     end

     # and provide a teardown method as well
     teardown do
       @alex.destroy
       @usergame1.destroy
       @game1.destroy
       @goog.destroy
       @transaction1.destroy
     end
     
     # now run the tests:
     # test one of each factory (not really required, but not a bad idea)
     should "show that all factories are properly created" do
       assert_equal "test@gmail.com", @alex.email
       assert_equal "testuser1", @alex.username
       assert_equal "test gameeee", @game1.name
       assert_equal 23, @goog.stock_code
       assert_equal 40, @transaction1.qty
     end

# now run tests:
# test the scope 'for_user_game'
should "show all user_games for user" do
       assert_equal @usergame1, UserGame.for_purchased_stock(@goog)
       assert_equal 1, UserGame.for_purchased_stock(@goog).size
end

 # test the scope 'for_user'
     should "show all games for user_game" do
       assert_equal @game1, Game.for_user_game(@usergame1)
       assert_equal 1, Game.for_user_game(@usergame1).size
     end

 # test the scope 'for_game'
     should "show all games for user" do
       assert_equal @game1, Game.for_user(@alex)
       assert_equal 1, Game.for_user(@alexh).size
     end

end
