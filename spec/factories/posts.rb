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

  trait :with_picture do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test.jpg")) }
    association :post
  end
end
