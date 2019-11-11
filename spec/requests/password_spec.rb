# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Password", type: :request do
  let(:user) { create(:user) }

  describe "#update" do
    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      context "パスワードと確認用パスワードが一致している場合" do
        it "更新に成功すること" do
          new_password = "updated_password"
          password_params = FactoryBot.attributes_for(:user,
                                                      current_password: "test_password",
                                                      new_password: new_password,
                                                      new_password_confirmation: new_password)
          patch password_path, params: { user: password_params }
          expect(response.status).to eq(302)
          expect(!!user.reload.authenticate(new_password)).to be true
          expect(response).to redirect_to password_path
        end
      end

      context "パスワードと確認用パスワードが一致していない場合" do
        it "Validationエラーが発生すること" do
          password_params = FactoryBot.attributes_for(:user,
                                                      current_password: "test_password",
                                                      new_password: "password",
                                                      new_password_confirmation: "buzzword")
          patch password_path, params: { user: password_params }
          expect(response.status).to eq(200)
          expect(!!user.reload.authenticate("password")).to be false
          expect(flash[:danger]).to include "再入力パスワードとパスワードの入力が一致しません"
        end
      end

      context "現在のパスワードが正しくない場合" do
        it "NoCurrentPasswordErrorが発生すること" do
          password_params = FactoryBot.attributes_for(:user,
                                                      current_password: "buzzword",
                                                      new_password: "password",
                                                      new_password_confirmation: "password")
          patch password_path, params: { user: password_params }
          expect(response.status).to eq(200)
          expect(!!user.reload.authenticate("password")).to be false
          expect(flash[:danger]).to include "現在のパスワードが違います"
        end
      end
    end
  end
end
