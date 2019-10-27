# frozen_string_literal: true

def log_in
  post login_path, params: {
    email: "example@test.com",
    password: "test_password"
  }
end
