# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit
    render "settings/passwords/edit"
  end

  def update
    current_user.update_password(params[:user][:current_password], params[:user][:password], params[:user][:password_confirmation])
    flash[:success] = "パスワードを更新しました"
    redirect_to password_path
  rescue ActiveRecord::RecordInvalid, Exceptions::NoCurrentPasswordError => e
    flash.now[:danger] = e.message
    render "settings/passwords/edit"
  end

  private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
