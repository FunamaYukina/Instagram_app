# frozen_string_literal: true

def log_in(user)
  post login_path, params: {
    email: user.email,
    password: user.password
  }
end

def post_message_and_image
  log_in(user)
  get root_path
  post_param = FactoryBot.attributes_for(:post, :with_picture)
  post posts_path(id: 1), params: {
    post: post_param
  }
end

def logout
  post logout_path
end
