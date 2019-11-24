# frozen_string_literal: true

class SessionController < ApplicationController
  before_action :back_to_top, only: %i[login login_form]

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      log_in(user)
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render "session/login_form"
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to login_path
  end

  private

    def back_to_top
      redirect_to root_path if logged_in?
    end
end
