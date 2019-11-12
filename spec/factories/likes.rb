# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    post_id { 1 }
    user_id { 1 }
  end


  trait :with_like do
    after(:create) do |user|
      user.likes.create(FactoryBot.attributes_for(:like))
    end
  end
end