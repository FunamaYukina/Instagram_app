# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    image_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    association :post
  end

  trait :with_picture do
    image_file { File.new("#{Rails.root}/spec/fixtures/test.jpg") }
  end
end
