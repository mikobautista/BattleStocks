class HomeController < ApplicationController
  require 'will_paginate'
  def index
  	if logged_in?
  		@current_user_games = UserGame.current.for_user(current_user).ending_soonest.paginate(:page => params[:current_games_page]).per_page(10)
  		@upcoming_user_games = UserGame.upcoming.for_user(current_user).starting_soonest
  		@past_user_games = UserGame.past.for_user(current_user).most_recent

  		@owned_stock = PurchasedStock.for_user(current_user)
      
  	end
  end
end
