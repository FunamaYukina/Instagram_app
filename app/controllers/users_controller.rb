# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :back_to_top, only: %i[new create]
  before_action :set_user, only: :show

  def show
    @user = User.eager_load([:profile, :posts, posts: [:images]]).find_by!(user_name: params[:username])
    @post = @user.posts
    @profile = @user.profile
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to root_path
    else
      flash.now[:danger] = "ユーザー登録に失敗しました"
      render "users/new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find_by!(user_name: params[:username])
    end

    def back_to_top
      redirect_to root_path if logged_in?
    end
end
