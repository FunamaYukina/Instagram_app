# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :back_to_top, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to root_path
    else
      render "users/new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
    end

    def back_to_top
      redirect_to root_path if logged_in?
    end
end
