# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  def authenticated_user
    return if logged_in?

    flash[:danger] = "ログインしてください"
    redirect_to login_path
  end

  def set_user
    @user = User.find_by!(user_name: params[:username])
  end
end
