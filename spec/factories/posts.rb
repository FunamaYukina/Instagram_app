# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    message { "test_message" }
    association :user
  end
end
