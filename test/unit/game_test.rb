require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # Relationships
  should have_many(:user_games)
  should have_many(:users).through(:user_games)

  # Presence of...1
  should validate_presence_of(:start_date)
  should validate_presence_of(:end_date)
  should validate_presence_of(:budget)
  should validate_presence_of(:name)

  # Name
  should allow_value("Jonathan").for(:name)
  should allow_value("jonathan").for(:name)
  should allow_value("asdf").for(:name)
  should allow_value("123 test game!!").for(:name)
  should allow_value("#hashtag #unittesting #whatwhat").for(:name)
  should_not allow_value("").for(:name)

  # Dates
  should allow_value(1.day.from_now.to_date).for(:start_date)
  should_not allow_value("asdfasdf").for(:start_date)
  should_not allow_value("asdfasdf").for(:end_date)

  # Budget
  should allow_value(1000000).for(:budget)
  should_not allow_value(0).for(:budget)
  should_not allow_value("asdfasdf").for(:budget)
  should_not allow_value(-10000).for(:budget)

  context "Creating one game" do
    # create the objects I want with factories
     setup do 
       @alex = FactoryGirl.create(:user, :email => "tester@gmail.com", :username => "tester")
       @game1 = FactoryGirl.create(:game, :name => "test gameeee", :start_date => 1.day.from_now.to_date, 
       :end_date => 10.days.from_now.to_date, :budget => 10000)
       @usergame1 = FactoryGirl.create(:user_game, :user_id => @alex.id, :game_id => @game1.id)
     end
     
     # and provide a teardown method as well
     teardown do
       @alex.destroy
       @game1.destroy
       @usergame1.destroy
     end
    
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "tester@gmail.com", @alex.email
      assert_equal "tester", @alex.username
      assert_equal "test gameeee", @game1.name
    end
    
    # test the scope 'for_user'
    should "show all games for user" do
      assert_equal 1, Game.for_user(@alex).size
      assert_equal @game1, Game.for_user(@alex).first
    end
    
    # test the method 'dollars_to_cents' works
    should "shows that dollars_to_cents method works" do
      assert_equal 1000000, @game1.budget
    end
    
    # THIS STILL NEEDS FIXING UP
    # # test the method 'convert_to_est' works
    # should "shows that convert_to_est method works" do
    #   assert_equal Datetime.current += 18000, @game1.start_date
    # end

  end
end
