# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Profile", type: :request do
  let(:user) { create(:user) }

  describe "#edit" do
    context "未ログインの場合" do
      it "TOPページへリダイレクトされること" do
        get profile_path
        expect(response).to redirect_to root_path
      end
    end

    context "ログイン済みの場合" do
      it "レスポンス200が返ってくること" do
        log_in(user)
        get profile_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#update" do
    before do
      log_in(user)
    end

    context "未ログインの場合" do
      it "ユーザー情報を更新に失敗し、TOPページへリダイレクトされること" do
        logout
        user_params = FactoryBot.attributes_for(:user, user_name: "updated_user_name")
        patch profile_path, params: {user: user_params}
        expect(User.last.user_name).to_not eq "updated_user_name"
        expect(response).to redirect_to root_path
      end
    end

    context "ログイン済みの場合" do
      context "ユーザー情報の更新に成功する場合" do
        it "ユーザーネームを変更した場合、正しく更新されること" do
          user_params = FactoryBot.attributes_for(:user, user_name: "updated_user_name")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(302)
          expect(User.last.user_name).to eq "updated_user_name"
          expect(response).to redirect_to(profile_path)
        end

        it "フルネームを変更した場合、正しく更新されること" do
          user_params = FactoryBot.attributes_for(:user, full_name: "updated_full_name")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(302)
          expect(User.last.full_name).to eq "updated_full_name"
          expect(response).to redirect_to(profile_path)
        end

        it "メールアドレスを変更した場合、正しく更新されること" do
          user_params = FactoryBot.attributes_for(:user, email: "update@test.com")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(302)
          expect(User.last.email).to eq "update@test.com"
          expect(response).to redirect_to(profile_path)
        end
      end

      context "ユーザー情報の更新に失敗する場合" do
        it "ユーザーネームがない場合、更新されないこと" do
          user_params = FactoryBot.attributes_for(:user, user_name: "")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(200)
          expect(User.last.user_name).to_not eq ""
          expect(response.body).to include "ユーザーネームを入力してください"
        end

        it "フルネームがない場合、更新されないこと" do
          user_params = FactoryBot.attributes_for(:user, full_name: "")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(200)
          expect(User.last.full_name).to_not eq ""
          expect(response.body).to include "フルネームを入力してください"
        end

        it "メールアドレスがない場合、更新されないこと" do
          user_params = FactoryBot.attributes_for(:user, email: "")
          patch profile_path, params: {user: user_params}
          expect(response.status).to eq(200)
          expect(User.last.email).to_not eq ""
          expect(response.body).to include "メールアドレスを入力してください"
        end
      end
    end
  end
end
