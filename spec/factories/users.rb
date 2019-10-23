FactoryBot.define do
  factory :user do
    email "rrr@test.com"
    user_name "rrr"
    full_name "rrrrr"
    password"rrrrrr"
    password_digest "rrrraaaarr"
  end

  factory :exist_user, class: User do
    email "zzz@test.com"
    password "zzzzzz"
  end
end