# frozen_string_literal: true

class SessionController < ApplicationController
  before_action :check_logged_in?, only: %i[login login_form]

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

  def login_form; end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to login_path
  end
end
