# frozen_string_literal: true

class SessionController < ApplicationController
  before_action :correct_user, only: %i[login login_form]

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      log_in(user)
      flash[:notice] = "ログインしました"
      redirect_to root_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("session/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to login_path
  end

  private

    def correct_user
      redirect_to(root_path) if current_user
    end
end
