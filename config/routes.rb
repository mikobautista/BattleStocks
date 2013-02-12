BattleStocks::Application.routes.draw do

  get "home/index"

  # main resources
  resources :invitations
  resources :games
  resources :transactions
  resources :purchased_stocks
  resources :user_games
  resources :users

  # set the root
  root :to => "home#index"
end
