# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery

  def new
    redirect_to root_path if logged_in_user
    @user = User.new
  end

  def create
    if logged_in_user
      redirect_to root_path
    else
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "ユーザー登録が完了しました"
        # redirect_to("/users/#{@user.id}")
        redirect_to root_path
      else
        render("users/new")
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
  end
end
