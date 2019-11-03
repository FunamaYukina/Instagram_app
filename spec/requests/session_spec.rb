# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Session", type: :request do
    let(:user) {FactoryBot.create(:user)}

  describe "#login_form" do
    context "未ログインの場合" do
      it "レスポンス200が返ってくること" do
        get login_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "TOPへリダイレクトされること" do
        log_in(user)
        get login_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#login" do
    context "未ログインの場合" do
      it "ユーザーが存在する場合、ログイン出来ること" do
        log_in(user)
        expect(response.status).to eq(302)
        expect(response).to redirect_to root_path
        expect(session[:user_id]).to eq 1
      end

      it "ユーザーが存在しない場合、ログインできないこと" do
        post login_path, params: {
            email: "xxx@test.com",
            password: "test_password"
        }
        expect(response.body).to include "間違っています"
        expect(session[:user_id]).to be_nil
      end
    end

    context "ログイン済みの場合" do
      it "TOPへリダイレクトされること" do
        log_in(user)
        post login_path, params: {
            email: "example@test.com",
            password: "test_password"
        }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#logout" do
    context "ログイン済みの場合" do
      it "ログアウトに成功すること" do
        log_in(user)
        post logout_path
        expect(response).to redirect_to(login_path)
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
