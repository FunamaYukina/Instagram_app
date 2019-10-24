FactoryBot.define do
  factory :user do
    email "example@test.com"
    user_name "test_user_name"
    full_name "test_full_name"
    password "test_password"
    password_confirmation "test_password"
  end

  factory :another_user, class: User do
    email "another_example@test.com"
    user_name "test_another_user_name"
    full_name "test_another_full_name"
    password "test_another_password"
    password_confirmation "test_another_password"
  end
end