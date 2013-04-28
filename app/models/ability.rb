class Ability
  include CanCan::Ability
  
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

  def initialize(user)
    user ||= User.new
    
    if user.is_admin 
      # If you're an admin, you have the power to manage everything
      can :manage, :all
    else
      # All users can create users, games and hence usergames
      can :create, [User, Game, UserGame]
      
      # A user should be able to index and create purchased stocks, but nobody can read the details (show) since the relevant information is already shown in the index
      can [:index, :create], PurchasedStock do |purchasedstock|
        purchasedstock.usergame.user_id == user.id
      end
      
      # All users can create transactions in their own games
      can :create, Transaction do |transaction|
        transaction.purchased_stock.usergame.user_id == user.id
      end
      
      # All users can look at the details of other users, but only edit their own information
      can :show, User
      can [:edit, :update], User do |x|  
        x.id == user.id
      end
      # can [:edit, :update], User, :email => user.email
      
      # All users can see their own games
      can :read, Game do |game|
        game == Game.for_user(user)
      end
      
      # A user can edit and manage their own game, if they are the manager
      can :update, Game do |x|
        x.manager_id == user.id 
        # && game.start_date > Time.now.to_date
      end
      
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
