# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe User, type: :request do
  describe FactoryBot do
    it "有効なファクトリを持つこと" do
      expect(build(:user)).to be_valid
    end
  end

  describe "#new" do
    let(:user) { create(:user) }

    context "未ログインの場合" do
      it "レスポンス200が返ってくること" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "TOPページへリダイレクトされること" do
        signup
        log_in
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
      let(:user) { create(:user) }

      it "TOPページへリダイレクトされること" do
        signup
        log_in
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
        signup
        logout
      end

      it "自分ではないユーザーページにアクセスできること" do
        get user_page_path(id: 1)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include "プロフィールを編集"
      end
    end

    context "ログイン済みの場合" do
      before do
        signup
        post_message_and_image
      end

      it "マイページにアクセスできること" do
        get user_page_path(id: 1)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).to include "プロフィールを編集"
      end

      it "自分ではないユーザーページにアクセスできること" do
        logout
        sign_up_another_user
        log_in_another_user
        get user_page_path(id: 1)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include "プロフィールを編集"
      end
    end
  end

  describe "#edit" do
    context "未ログインの場合" do
      before do
        signup
        logout
      end

      it "TOPページへリダイレクトされること" do
        get profile_path(id: 1)
        expect(response).to redirect_to root_path
      end
    end

    context "ログイン済みの場合" do
      before do
        signup
      end

      it "レスポンス200が返ってくること" do
        log_in
        get profile_path(id: 1)
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#update_profile" do
    before do
      sign_up_another_user
      log_in_another_user
    end
    context "(ログイン済みの場合で、)ユーザー情報の更新に成功する場合" do
      it "ユーザーネームを変更した場合、正しく更新されること" do
        user_params = FactoryBot.attributes_for(:another_user, user_name: "test_user_name2")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(302)
        expect(User.last.user_name).to eq "test_user_name2"
        expect(response).to redirect_to(profile_path)
      end

      it "フルネームを変更した場合、正しく更新されること" do
        user_params = FactoryBot.attributes_for(:another_user, full_name: "test_full_name2")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(302)
        expect(User.last.full_name).to eq "test_full_name2"
        expect(response).to redirect_to(profile_path)
      end

      it "メールアドレスを変更した場合、正しく更新されること" do
        user_params = FactoryBot.attributes_for(:another_user, email: "example2@test.com")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "example2@test.com"
        expect(response).to redirect_to(profile_path)
      end
    end

    context "(ログイン済みの場合で、)ユーザー情報の更新に失敗する場合" do

      it "ユーザーネームがない場合、更新されないこと" do
        user_params = FactoryBot.attributes_for(:another_user, user_name: "")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "ユーザーネームを入力してください"
      end

      it "フルネームがない場合、更新されないこと" do
        user_params = FactoryBot.attributes_for(:another_user, full_name: "")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "フルネームを入力してください"
      end

      it "メールアドレスがない場合、更新されないこと" do
        user_params = FactoryBot.attributes_for(:another_user, email: "")
        patch profile_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "メールアドレスを入力してください"
      end
    end
  end
  describe "#update_password" do
    before do
      sign_up_another_user
      log_in_another_user
    end
    context '(ログイン済みの場合で)パスワードの更新に成功する場合' do
      it 'パスワードの更新に成功すること' do
        user_params = FactoryBot.attributes_for(:another_user,
                                                current_password: "test_another_password",
                                                password: "test_pass",
                                                password_confirmation: "test_pass")
        patch password_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(password_path)
      end
    end
    context '(ログイン済みの場合で)パスワードの更新に失敗する場合' do
      it '現在のパスワードが違う場合、更新されないこと' do
        user_params = FactoryBot.attributes_for(:another_user,
                                                current_password: "test_test_password",
                                                password: "test_pass",
                                                password_confirmation: "test_pass")
        patch password_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "現在のパスワードが違います"
      end
      it '新しいパスワードと再入力パスワードが異なる場合、更新されないこと' do
        user_params = FactoryBot.attributes_for(:another_user,
                                                current_password: "test_another_password",
                                                password: "test_pass",
                                                password_confirmation: "test_password")
        patch password_path(id: 1), params: { user: user_params }
        expect(response.status).to eq(200)
        expect(response.body).to include "再入力パスワードとパスワードの入力が一致しません"
      end
    end
  end
end
