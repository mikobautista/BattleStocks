class HomeController < ApplicationController
  def index
  	if logged_in?
  		@current_games = Game.current.for_user(current_user).ending_soonest
  		@upcoming_games = Game.upcoming.for_user(current_user).starting_soonest
  		@past_games = Game.past.for_user(current_user).most_recent

  		@current_user_games = UserGame.current.for_user(current_user).ending_soonest

  		@owned_stock = PurchasedStock.for_user(current_user)
  	end
  end
end
