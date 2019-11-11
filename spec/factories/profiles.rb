# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test.jpg")) }
    gender { false }
    introduction { "test" }
    association :user
  end
end
