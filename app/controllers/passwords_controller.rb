# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit
    render "settings/passwords/edit"
  end

  def update
    if current_user.authenticate(params[:user][:current_password])
      if current_user.update(password_params)
        flash[:success] = "パスワードを更新しました"
        redirect_to password_path
      else
        render "settings/passwords/edit"
      end
    else
      flash[:danger] = "現在のパスワードが違います"
      render "settings/passwords/edit"
    end
  end

  private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
