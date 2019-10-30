# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :back_top_page, only: %i[new create]

  def show
    @user = User.find_by(id: params[:id])
    @post = @user.posts.eager_load([:images])
    @profile = @user.profile
  end

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
      render("users/new")
    end
  end

  def edit
    @user = current_user
    @post = @user.posts.eager_load([:images])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.full_name = params[:full_name]
    @user.user_name = params[:user_name]
    @user.email = params[:email]
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
  end

  def back_top_page
    redirect_to(root_path) if current_user
  end
end
