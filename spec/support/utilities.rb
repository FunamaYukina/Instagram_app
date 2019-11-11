# frozen_string_literal: true

def log_in(user)
  post login_path, params: {
    email: user.email,
    password: user.password
  }
end

def post_message_and_image
  get root_path
  post_params = attributes_for(:no_images_post)
  post posts_path(username: user.user_name), params: {
    post: {
      message: post_params[:message],
      images_attributes: {
        "0": FactoryBot.attributes_for(:image)
      }
    }
  }
end

def logout
  post logout_path
end
