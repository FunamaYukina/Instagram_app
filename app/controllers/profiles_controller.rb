# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticated_user

  def edit
    render "settings/profiles/edit"
  end

  def update
    if current_user.update(user_params)
      flash[:success] = "ユーザー情報を編集しました"
      redirect_to profile_path
    else
      flash[:danger] = "ユーザー情報の更新に失敗しました"
      render "settings/profiles/edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :full_name, :email,
                                   [profile_attributes: %i[image_file introduction gender user_id]])
    end

    def authenticated_user
      flash[:danger] = "ログインしてください"
      redirect_to root_path unless logged_in?
    end
end
