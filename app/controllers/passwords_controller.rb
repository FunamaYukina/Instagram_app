# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :set_user
  before_action :correct_user

  def edit
  end

  def update
    if @user.authenticate(params[:user][:current_password])
      if @user.update(user_params)
        flash[:success] = "パスワードを更新しました"
        redirect_to password_path
      else
        render("passwords/edit")
      end
    else
      flash[:danger] = "現在のパスワードが違います"
      render("passwords/edit")
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def correct_user
      redirect_to(root_path) unless current_user == @user
    end
end
