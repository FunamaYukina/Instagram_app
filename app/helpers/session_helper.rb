# frozen_string_literal: true

module SessionHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in_user
    @logged_in_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
