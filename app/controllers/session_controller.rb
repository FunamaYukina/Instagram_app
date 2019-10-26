# frozen_string_literal: true

class SessionController < ApplicationController
  before_action :logged_in_user, only: %i[login login_form]

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to root_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("session/login_form")
    end
  end

  def login_form
    redirect_to root_path if logged_in_user
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to login_path
  end
end
