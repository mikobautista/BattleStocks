FactoryGirl.define do
  
  factory :user do
    username "lalala"
    email "flabbergast@gmail.com"
    total_points 0
    password "secret"
    password_confirmation "secret"
    is_admin false
    is_active true
  end
  
  factory :game do
    is_terminated false
    name "wootwoot"
    budget 10000
    start_date 1.day.from_now.to_date
    end_date 10.days.from_now.to_date
    manager_id 0
  end
  
  factory :user_game do
    points 0
    total_value_in_stocks 0
    is_active true
    association :user
    association :game
  end
  
   factory :purchased_stock do
    association :user_game
    stock_code "goog"
    total_qty 100
    money_spent 5000
    money_earned 100
    value_in_stocks 80
  end
 
  factory :invitation do 
    association :game
    email "flabby@gmail.com"
  end
   
  factory :transaction do
    association :purchased_stock
    date Time.now.to_date
    qty 40
    value_per_stock 45000
    is_buy true
  end
  
end
