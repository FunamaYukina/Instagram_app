# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    message { "test_message" }
    association :user
    images {
      [
          FactoryBot.build(:image)
      ]
    }
  end

  trait :with_post do
    after(:create) do |user|
      user.posts.create(FactoryBot.attributes_for(:post))
    end
  end

  factory :no_images_post, class: Post do
    message { "test_message" }
    association :user
  end

  factory :many_images_post, class: Post do
    message { "test_message" }
    association :user
    images {
      [
          FactoryBot.build(:image),
          FactoryBot.build(:image)
      ]
    }
  end
end
