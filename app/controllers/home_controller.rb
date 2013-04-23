class HomeController < ApplicationController
  require 'will_paginate'
  def index
  	if logged_in?
  		@current_user_games = UserGame.current.for_user(current_user).ending_soonest.paginate(:page => params[:current_games_page]).per_page(10)
  		@upcoming_user_games = UserGame.upcoming.for_user(current_user).starting_soonest
  		@past_user_games = UserGame.past.for_user(current_user).most_recent

  		@owned_stock = PurchasedStock.for_user(current_user).nonzero.paginate(:page => params[:owned_stock_page]).per_page(6)
      @owned_stock_array = []
      for stock in @owned_stock
        @owned_stock_array += [[stock.stock_code, stock.get_price]]
      end
  	end
  end

  def search 
    # allows for the admin to search from their dashboard
    @query = params[:query]
    if @query != ""
      @stock_value = PurchasedStock.search(@query)
    end
  end
end
