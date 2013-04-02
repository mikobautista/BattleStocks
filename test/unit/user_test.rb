require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Relationships 
  should have_many(:user_games)
  should have_many(:games).through(:user_games)
  
  # Validations 
  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_presence_of(:username)
  should validate_presence_of(:total_points)
  should validate_presence_of(:is_admin)
  should validate_presence_of(:is_active)
  
  # Validating email
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  context "Creating one game" do
     # create the objects I want with factories
     setup do
       @alex = FactoryGirl.create(:user, :email => "testalex@gmail.com", :username => "testalex")
       @mark = FactoryGirl.create(:user, :email => "testmark@gmail.com", :username => "testmark")
       @rachel = FactoryGirl.create(:user, :email => "testrachel@gmail.com", :username => "testrachel", :is_active => false)
       @game1 = FactoryGirl.create(:game, :manager_id => @alex, :name => "test gameeee", :start_date => Time.now.to_date,
       :end_date => 10.days.from_now.to_date, :budget => 10)
     end
      # and provide a teardown method as well
     teardown do
      @rachel.destroy
      @mark.destroy
      @alex.destroy
     end
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "testalex", @alex.username
      assert_equal "testalex@gmail.com", @alex.email
      assert_equal "testmark", @mark.username
      assert_equal "testmark@gmail.com", @mark.email
      assert_equal "testrachel", @rachel.username
      assert_equal "testrachel@gmail.com", @rachel.email
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three users in in alphabetical order" do
      assert_equal ["testalex", "testmark", "testrachel"], User.alphabetical.map{|u| u.username}
    end
    
    # test the scope 'active'
    should "shows that there are two active owners" do
      assert_equal 2, User.active.size
      assert_equal ["testalex", "testmark"], User.active.alphabetical. map{|u| u.username}
    end
    
    # test the scope 'in_game'
    
      
  end
end



