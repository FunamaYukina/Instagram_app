# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    user_id { 1 }
    image_file { "MyString" }
  end
end
