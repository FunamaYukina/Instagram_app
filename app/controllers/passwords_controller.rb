# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit
    render "settings/passwords/edit"
  end

  def update
    begin
      current_user.update_password(password_params[:current_password],password_params[:new_password],password_params[:new_password_confirmation])
      flash[:success] = "パスワードを更新しました"
      redirect_to password_path
    rescue ActiveRecord::RecordInvalid, Exceptions::NoCurrentPasswordError => e
      flash.now[:danger] = e.message
      render "settings/passwords/edit"
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password,:new_password, :new_password_confirmation)
  end
end
