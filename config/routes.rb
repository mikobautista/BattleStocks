BattleStocks::Application.routes.draw do

  get "sessions/new"

  resources :users


  get "home/index"

  # main resources
  resources :invitations
  resources :games
  resources :transactions
  resources :purchased_stocks
  resources :user_games

  #bcrypt routes
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  resources :users
  resources :sessions

  # set the root
  root :to => "home#index"
  
end
