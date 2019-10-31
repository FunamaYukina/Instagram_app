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
    @profile=@user.profile
  end

  def update
    @user = current_user
    @user.update(update_params)
    @profile=@user.profile
    if @user.save ||@profile.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to profile_path
    else
      render("users/edit")
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:user_name, :full_name, :email,:password, [profile_attributes: %i[image_file introduction gender user_id]])
  end

  def back_top_page
    redirect_to(root_path) if current_user
  end
end
