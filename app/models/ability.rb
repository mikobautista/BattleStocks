class Ability
  include CanCan::Ability
  
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  # helper_method :current_user
  
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

  def initialize(user)
    user ||= User.new
    
    if user.is_admin
      can :manage, :all
    else
      can :create, [User, Game, UserGame]
      
      can [:read, :create], PurchasedStock do |purchasedstock|
        purchasedstock.usergame.user_id == user.id
      end
      # can [:read, :create], PurchasedStock, :usergame => {:user_id => user.id}
      
      can [:read, :create], Transaction do |transaction|
        transaction.purchased_stock.usergame.user_id == user.id
      end
      # can [:read, :create], Transaction, :purchased_stock => {:usergame => {:user_id => user.id}}
      
      can :show, User
      can [:edit, :update], User do |x|  
        x.id == user.id
      end
      # can [:edit, :update], User, :email => user.email
      
      can :read, Game do |game|
        game == Game.for_user(user)
      end
      
      can :update, Game do |x|
        x.manager_id == user.id 
        # && game.start_date > Time.now.to_date
      end
      # can [:edit, :update], Game, :manager_id => user.id, :start_date => Time.now.to_date
      
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
