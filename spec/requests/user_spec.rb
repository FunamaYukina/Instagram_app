# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe User, type: :request do
  let(:user) { create(:user) }

  describe FactoryBot do
    it "有効なファクトリを持つこと" do
      expect(build(:user)).to be_valid
    end
  end

  describe "#new" do
    context "未ログインの場合" do
      it "レスポンス200が返ってくること" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "TOPページへリダイレクトされること" do
        log_in(user)
        get signup_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "新規登録ユーザー登録に成功する場合" do
      it "新規ユーザーが登録されること" do
        user_params = attributes_for(:another_user)
        post signup_path, params: { user: user_params }
        expect(response.status).to eq(302)
        expect(User.last.email).to eq user_params[:email]
        expect(response).to redirect_to root_path
      end

      it "メールアドレスは小文字で登録されること" do
        user_params = attributes_for(:another_user)
        post signup_path, params: { user: user_params }
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "another_example@test.com"
        expect(response).to redirect_to root_path
      end
    end

    context "新規ユーザーの登録に失敗する場合" do
      it "メールアドレスがない場合、ユーザー登録に失敗すること" do
        expect do
          user_params = attributes_for(:another_user, email: "")
          post signup_path, params: { user: user_params }
        end.not_to change(User, :count)
      end
    end

    context "ログイン済みの場合" do
      it "TOPページへリダイレクトされること" do
        log_in(user)
        expect do
          user_params = attributes_for(:another_user)
          post signup_path, params: { user: user_params }
        end.not_to change(User, :count)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#show" do
    context "未ログインの場合" do
      before do
        post_message_and_image
        logout
      end

      it "ユーザーページにアクセスできること" do
        get user_path(username: user.user_name)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include "プロフィールを編集"
      end
    end

    context "ログイン済みの場合" do
      before do
        post_message_and_image
      end

      it "マイページにアクセスした場合、プロフィール編集ボタンが表示されていること" do
        get user_path(username: user.user_name)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).to include "プロフィールを編集"
      end

      it "他人のユーザーページにアクセスした場合、プロフィール編集ボタンが表示されないこと" do
        logout
        get user_path(username: user.user_name)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include "プロフィールを編集"
      end
    end
  end

end
