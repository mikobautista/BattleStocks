class HomeController < ApplicationController
  def index
  	@games = Game.for_user(current_user)
  end
end
