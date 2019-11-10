# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Password", type: :request do
  let(:user) { create(:user) }

  describe "#update" do
    before do
      log_in(user)
    end

    context "(ログイン済みの場合で)パスワードの更新に成功する場合" do
      it "パスワードの更新に成功すること" do
        password_params = FactoryBot.attributes_for(:user,
                                                    current_password: "test_password",
                                                    password: "test_update_pass",
                                                    password_confirmation: "test_update_pass")
        patch password_path, params: { user: password_params }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(password_path)
      end
    end

    context "(ログイン済みの場合で)パスワードの更新に失敗する場合" do
      it "現在のパスワードが違う場合、更新されないこと" do
        password_params = FactoryBot.attributes_for(:user,
                                                    current_password: "test_wrong_password",
                                                    password: "test_update_pass",
                                                    password_confirmation: "test_update_pass")
        patch password_path, params: { user: password_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "現在のパスワードが違います"
      end

      it "新しいパスワードと再入力パスワードが異なる場合、更新されないこと" do
        password_params = FactoryBot.attributes_for(:user,
                                                    current_password: "test_password",
                                                    password: "test_update_pass",
                                                    password_confirmation: "test_wrong_pass")
        patch password_path, params: { user: password_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "再入力パスワードとパスワードの入力が一致しません"
      end
    end
  end
end
