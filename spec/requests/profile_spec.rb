# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Profile", type: :request do
  let(:user) { create(:user) }

  describe "#edit" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトされること" do
        get profile_path
        expect(response).to redirect_to login_path
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
    context "未ログインの場合" do
      it "ユーザー情報の更新に失敗し、ログインページへリダイレクトされること" do
        user
        profile_params = FactoryBot.attributes_for(:user, user_name: "updated_user_name")
        patch profile_path, params: { user: profile_params }
        expect(User.last.user_name).not_to eq "updated_user_name"
        expect(response).to redirect_to login_path
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      context "ユーザー情報の更新に成功する場合" do
        it "ユーザーネームを変更した場合、正しく更新されること" do
          profile_params = FactoryBot.attributes_for(:user, user_name: "updated_user_name")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(302)
          expect(User.last.user_name).to eq "updated_user_name"
          expect(response).to redirect_to(profile_path)
        end

        it "フルネームを変更した場合、正しく更新されること" do
          profile_params = FactoryBot.attributes_for(:user, full_name: "updated_full_name")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(302)
          expect(User.last.full_name).to eq "updated_full_name"
          expect(response).to redirect_to(profile_path)
        end

        it "メールアドレスを変更した場合、正しく更新されること" do
          profile_params = FactoryBot.attributes_for(:user, email: "update@test.com")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(302)
          expect(User.last.email).to eq "update@test.com"
          expect(response).to redirect_to(profile_path)
        end

        it "自己紹介文を変更した場合、正しく更新されること" do
          profile_params = FactoryBot.attributes_for(:user, profile_attributes: { introduction: "テスト紹介です" })
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(302)
          expect(User.last.profile.introduction).to eq "テスト紹介です"
          expect(response).to redirect_to(profile_path)
        end

        it "プロフィール画像を変更した場合、正しく更新されること" do
          image = Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test_png.png"))
          profile_params = FactoryBot.attributes_for(:user, profile_attributes: { image_file: image })
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(302)
          expect(User.last.profile.image_file.model[:image_file]).to eq "test_png.png"
          expect(response).to redirect_to(profile_path)
        end
      end

      context "ユーザー情報の更新に失敗する場合" do
        it "ユーザーネームがない場合、更新されないこと" do
          profile_params = FactoryBot.attributes_for(:user, user_name: "")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(200)
          expect(User.last.user_name).not_to eq ""
          expect(response.body).to include "ユーザーネームを入力してください"
        end

        it "フルネームがない場合、更新されないこと" do
          profile_params = FactoryBot.attributes_for(:user, full_name: "")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(200)
          expect(User.last.full_name).not_to eq ""
          expect(response.body).to include "フルネームを入力してください"
        end

        it "メールアドレスがない場合、更新されないこと" do
          profile_params = FactoryBot.attributes_for(:user, email: "")
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(200)
          expect(User.last.email).not_to eq ""
          expect(response.body).to include "メールアドレスを入力してください"
        end
        it "自己紹介文が150文字を超える場合、更新されないこと" do
          profile_params = FactoryBot.attributes_for(:user, profile_attributes: { introduction: "a"*151 })
          patch profile_path, params: { user: profile_params }
          expect(response.status).to eq(200)
          expect(User.last.profile.introduction).not_to eq "a"*151
          expect(response.body).to include "自己紹介文は150文字以内で入力してください"
        end
      end
    end
  end
end
