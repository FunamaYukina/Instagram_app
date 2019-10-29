# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :correct_user, only: %i[new create]

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    @post = @user.posts.eager_load([:images])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to root_path
    else
      render("users/new")
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
    end

  def correct_user
    redirect_to(root_path) if current_user
  end
end
