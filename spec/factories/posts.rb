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

  factory :no_images_post, class: Post do
    message { "test_message" }
    association :user
  end
end
