require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Relationships 
  should have_many(:user_games)
  should have_many(:games).through(:user_games)
  
  # Validations 
  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_presence_of(:username)
  #should validate_presence_of(:total_points)
  #should validate_presence_of(:is_admin)
  #should validate_presence_of(:is_active)
  
  # Validating email
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  def new_user(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    attributes[:is_admin] ||= false
    user = User.new(attributes)
    user.valid? # run validations
    user
  end

  def setup
    User.delete_all
  end

  def test_valid
    assert new_user.valid?
  end

  def test_require_username
    assert_equal ["can't be blank", "Username should only contain letters, numbers, or .-_@"], new_user(:username => '').errors[:username]
  end

  def test_require_password
    assert_equal ["can't be blank", "is too short (minimum is 4 characters)" ], new_user(:password => '').errors[:password]
  end

  def test_require_well_formed_email
    assert_equal ["is invalid"], new_user(:email => 'foo@bar@example.com').errors[:email]
  end

  def test_validate_uniqueness_of_email
    new_user(:email => 'bar@example.com').save!
    assert_equal ["has already been taken"], new_user(:email => 'bar@example.com').errors[:email]
  end

  def test_validate_uniqueness_of_username
    new_user(:username => 'uniquename').save!
    assert_equal ["has already been taken"], new_user(:username => 'uniquename').errors[:username]
  end

  def test_validate_odd_characters_in_username
    assert_equal ["Username should only contain letters, numbers, or .-_@"], new_user(:username => 'odd ^&(@)').errors[:username]
  end

  def test_validate_password_length
    assert_equal ["is too short (minimum is 4 characters)"], new_user(:password => 'bad').errors[:password]
  end

  def test_require_matching_password_confirmation
    assert_equal ["doesn't match confirmation"], new_user(:password_confirmation => 'nonmatching').errors[:password]
  end

  def test_generate_password_hash_and_salt_on_create
    user = new_user
    user.save!
    assert user.password_hash
    assert user.password_salt
  end

  def test_authenticate_by_email
    User.delete_all
    user = new_user(:email => 'foo@bar.com', :password => 'secret')
    user.save!
    assert_equal user, User.authenticate('foo@bar.com', 'secret')
  end

  def test_authenticate_bad_username
    assert_nil User.authenticate('nonexisting', 'secret')
  end

  def test_authenticate_bad_password
    User.delete_all
    new_user(:username => 'foobar', :password => 'secret').save!
    assert_nil User.authenticate('foobar', 'badpassword')
  end
  
  
  # Factory Tests
  # -----------------------------
  context "Creating one game" do
     # create the objects I want with factories
     setup do
       @alex = FactoryGirl.create(:user, :email => "testalex@gmail.com", :username => "testalex")
       @mark = FactoryGirl.create(:user, :email => "testmark@gmail.com", :username => "testmark")
       @rachel = FactoryGirl.create(:user, :email => "testrachel@gmail.com", :username => "testrachel", :is_active => false)
       @game1 = FactoryGirl.create(:game, :name => "test gameeee", :start_date => Time.now.to_date, 
       :end_date => 10.days.from_now.to_date, :budget => 10) 
       @usergame1 = FactoryGirl.create(:user_game, :user_id => @alex.id, :game_id => @game1.id, :balance => 2000, :is_active => true, :points => 200, :total_value_in_stocks => 3000)
       @usergame2 = FactoryGirl.create(:user_game, :user_id => @mark.id, :game_id => @game1.id, :balance => 2000, :is_active => true, :points => 200, :total_value_in_stocks => 3000)
       #@usergame3 = FactoryGirl.create(:user_game, :user_id => @alex.id, :game_id => @game1.id, :balance => 2000, :is_active => true, :points => 200, :total_value_in_stocks => 3000)
     end
      # and provide a teardown method as well
     teardown do
      @rachel.destroy
      @mark.destroy
      @alex.destroy
      @game1.destroy
     end

    # now run the tests:
    #test one of each factory (not really required, but not a bad idea)
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
    
  #  # test the scope 'active'
    should "shows that there are two active owners" do
      assert_equal 2, User.active.size
      assert_equal ["testalex", "testmark"], User.active.alphabetical. map{|u| u.username}
    end
    
    # test the scope 'in_game'  
    should "show all the users that are in a particular game" do  
      assert_equal ["testalex", "testmark"], User.in_game(@game1).map{|u| u.username}  
    end  
  end
end



