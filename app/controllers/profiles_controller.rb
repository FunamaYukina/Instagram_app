# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :check_user
  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を編集しました"
      redirect_to profile_path
    else
      flash[:danger] = "ユーザー情報の更新に失敗しました"
      render("profiles/edit")
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email, :password, :password_confirmation,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def check_user
      redirect_to root_path unless logged_in?
    end

    def set_user
      @user = current_user
    end
end
