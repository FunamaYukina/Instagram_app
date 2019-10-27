FactoryBot.define do
  factory :post do
    # user_id { 1 }
    message { "test_message" }
    association :user
  end
end