# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :back_to_top, only: %i[new create]
  before_action :correct_user, only: %i[edit_profile edit_password update_profile update_password]
  before_action :set_user, only: %i[show edit_profile edit_password update_profile update_password]

  def show
    @post = @user.posts.eager_load([:images])
    @profile = @user.profile
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.build_profile(introduction: "")
      if @user.profile.save
        log_in(@user)
        flash[:success] = "ユーザー登録が完了しました"
        redirect_to root_path
      else
        flash[:danger] = "ユーザー登録に失敗しました"
        render("users/new")
      end
    else
      render "users/new"
    end
  end

  def edit_profile
  end

  def edit_password
  end

  def update_profile
    if @user.update(update_profile_params)
      flash[:success] = "ユーザー情報を編集しました"
      redirect_to profile_path
    else
      flash[:danger] = "ユーザー情報の更新に失敗しました"
      render("users/edit_profile")
    end
  end

  def update_password
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_password_params)
        flash[:success] = "パスワードを更新しました"
        redirect_to password_path
      else
        render("users/edit_password")
      end
    else
      flash[:danger] = "現在のパスワードが違います"
      render("users/edit_password")
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def update_profile_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def update_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def correct_user
      redirect_to(root_path) unless current_user
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def back_to_top
      redirect_to root_path if logged_in?
    end
end
