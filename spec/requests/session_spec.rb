# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Session", type: :request do
  before do
    FactoryBot.create(:user)
  end

  describe "#login_form" do
    context "未ログインの場合" do
      it "ログインページでレスポンス200が返ってくること" do
        get login_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "TOPへリダイレクトすること" do
        log_in
        get login_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#login" do
    context "未ログインの場合" do
      it "ユーザーが存在する場合ログイン出来ること" do
        log_in
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq 1
      end

      it "ユーザーが存在しない場合ログインできないこと" do
        post login_path, params: {
          email: "xxx@test.com",
          password: "test_password"
        }
        expect(response.body).to include "間違っています"
      end
    end
  end

  describe "#logout" do
    context "ログイン済みの場合" do
      it "ログアウトに成功すること" do
        log_in
        post logout_path
        expect(response).to redirect_to(login_path)
        expect(session[:user_id]).to be_nil
      end
    end

    context "ログイン済みの場合" do
      it "TOPへリダイレクトすること" do
        log_in
        post login_path, params: {
            email: "example@test.com",
            password: "test_password"
        }
        expect(response).to redirect_to root_path
      end
    end
  end
end