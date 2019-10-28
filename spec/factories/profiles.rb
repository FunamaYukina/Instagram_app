# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    image_file { "MyString" }
    gender { false }
    introduction { "MyText" }
  end
end
