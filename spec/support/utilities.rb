# frozen_string_literal: true

def signup
  user_param = FactoryBot.attributes_for(:user, :with_profile)
  post signup_path, params: {user: user_param}
end

def log_in
  post login_path, params: {
      email: "example@test.com",
      password: "test_password"
  }
end

def post_message_and_image
  log_in
  get root_path
  post_param = FactoryBot.attributes_for(:post, :with_picture)
  post post_path(id: 1), params: {
      post: post_param
  }
end

def sign_up_another_user
  user_param = FactoryBot.attributes_for(:another_user, :with_profile)
  post signup_path, params: {user: user_param}
end

def log_in_another_user
  post login_path, params: {
      email: "another_example@test.com",
      password: "test_another_password"
  }
end

def logout
  post logout_path
end
