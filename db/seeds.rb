# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if User.last.nil?
  10.times do |number|
    user_name = "user_name#{number}"
    User.create!(user_name: user_name,
                 full_name: "full_name",
                 email: "#{user_name}@example.com",
                 password: "password",
                 password_confirmation: "password",)
  end

  users = User.all

  users.each do |user|
    post = user.posts.build
    image = post.images.build
    image.image_file = open("#{Rails.root}/db/fixtures/sample.png")
    post.save!(message: "test_message")
  end

  users.each do |user|
    5.times do
      post_id = rand(1..10)
      user.like!(post_id)
    end
  end
end