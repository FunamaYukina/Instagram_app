# frozen_string_literal: true

def log_in(user)
  post login_path, params: {
    email: user.email,
    password: user.password
  }
end
