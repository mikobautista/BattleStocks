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

  # factory :purchased_stock do
  # end
  # 
  # factory :invitation do 
  # end
  # 
  # factory :transaction do 
  # end
  
end
