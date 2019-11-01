# frozen_string_literal: true

def signup
  user_param = FactoryBot.attributes_for(:user, :with_profile)
  post signup_path, params: { user: user_param }
end

def log_in
  post login_path, params: {
    email: "example@test.com",
    password: "test_password"
  }
end

def logout
  post logout_path
end
