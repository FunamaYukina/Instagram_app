# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery
  before_action :back_top_page, only: %i[new create]
  before_action :correct_user, only: %i[update edit]

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
      @user.build_profile(introduction: "")
      if @user.profile.save
        log_in(@user)
        flash[:notice] = "ユーザー登録が完了しました"
        redirect_to root_path
      else
        flash[:notice] = "ユーザー登録に失敗"
        render("users/new")
      end
    else
      render("users/new")
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(update_params)
    if @user.profile.save && @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to profile_path
    else
      render("users/edit")
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def update_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user
    end

    def back_top_page
      redirect_to(root_path) if current_user
    end
end
