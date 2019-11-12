# frozen_string_literal: true

module SessionHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def current_user_likes?(post_id)
    current_user.likes.find_by(post_id: post_id)
  end
end
