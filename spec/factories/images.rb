# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test.jpg")) }
  end

  trait :with_picture do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test.jpg")) }
    association :post
  end
  trait :with_incorrect_file_type do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test.xlsx")) }
    association :post
  end
  trait :with_large_file do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/13MB.jpg")) }
    association :post
  end
end
