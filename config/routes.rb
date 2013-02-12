BattleStocks::Application.routes.draw do

  resources :users


  get "home/index"

  # main resources
  resources :invitations
  resources :games
  resources :transactions
  resources :purchased_stocks
  resources :user_games  # facebook routes
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  # set the root
  root :to => "home#index"
end
