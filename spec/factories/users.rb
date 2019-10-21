FactoryBot.define do
  factory :user do
    email "rrr@test.com"
    name "rrr"
    full_name "rrrrr"
    password "rrr"
  end

  factory :exist_user, class: User do
    email "zzz@test.com"
    password  "zzz"
  end
end
