# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe User, type: :request do
  describe FactoryBot do
    it "有効なファクトリを持つこと" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe "#new" do
    before do
      FactoryBot.create(:user)
    end

    context "未ログインの場合" do
      it "レスポンス200が返ってくること" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "TOPページへリダイレクトされること" do
        log_in
        get signup_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "新規登録ユーザー登録に成功する場合" do
      it "新規ユーザーが登録されること" do
        user_param = FactoryBot.attributes_for(:another_user)
        post signup_path, params: { user: user_param }
        expect(response.status).to eq(302)
        expect(User.last.email).to eq user_param[:email]
        expect(response).to redirect_to(root_path)
      end

      it "メールアドレスは小文字で登録されること" do
        user_param = FactoryBot.attributes_for(:another_user)
        post signup_path, params: { user: user_param }
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "another_example@test.com"
        expect(response).to redirect_to(root_path)
      end
    end

    context "新規ユーザーの登録に失敗する場合" do
      it "メールアドレスがない場合、ユーザー登録に失敗すること" do
        expect do
          user_param = FactoryBot.attributes_for(:another_user, email: "")
          post signup_path, params: { user: user_param }
        end.not_to change(User, :count)
      end
    end

    context "ログイン済みの場合" do
      before do
        FactoryBot.create(:user)
      end

      it "TOPページへリダイレクトされること" do
        log_in
        expect do
          user_param = FactoryBot.attributes_for(:another_user)
          post signup_path, params: { user: user_param }
        end.not_to change(User, :count)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
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

    context "ログイン済みの場合で、ユーザー情報の更新に成功する場合" do
      before do
        signup
        log_in
      end
      it 'ユーザーネームを変更した場合、正しく更新されること' do
        user_param = FactoryBot.attributes_for(:another_user,user_name:"test_user_name2")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.user_name).to eq "test_user_name2"
        expect(response).to redirect_to(profile_path)
      end
      it 'フルネームを変更した場合、正しく更新されること' do
        user_param = FactoryBot.attributes_for(:another_user,full_name:"test_full_name2")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.full_name).to eq "test_full_name2"
        expect(response).to redirect_to(profile_path)
      end
      it 'メールアドレスを変更した場合、正しく更新されること' do
        user_param = FactoryBot.attributes_for(:another_user,email:"example2@test.com")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "example2@test.com"
        expect(response).to redirect_to(profile_path)
      end
      it 'パスワードを変更した場合、正しく更新されること' do
        user_param = FactoryBot.attributes_for(:another_user,password:"test_password2",password_confirmation:"test_password2")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.password_digest).not_to eq nil
        expect(response).to redirect_to(profile_path)
      end
    end
    context "ログイン済みの場合で、ユーザー情報の更新に失敗する場合" do
      before do
        signup
        log_in
      end
      it 'ユーザーネームがない場合、更新されないこと' do
        user_param = FactoryBot.attributes_for(:another_user,user_name:"")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include "ユーザーネームを入力してください"
      end
      it 'フルネームがない場合、更新されないこと' do
        user_param = FactoryBot.attributes_for(:another_user,full_name:"")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include "フルネームを入力してください"
      end
      it 'メールアドレスがない場合、更新されないこと' do
        user_param = FactoryBot.attributes_for(:another_user,email:"")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include "メールアドレスを入力してください"
      end
      it 'パスワードがない場合、更新されないこと' do
        user_param = FactoryBot.attributes_for(:another_user,password:"")
        patch profile_path(id: 1),params: {user: user_param}
        expect(response.status).to eq(200)
        expect(User.last.password_digest).not_to eq nil
        expect(response.body).to include "パスワードは6文字以上で入力してください"
      end
    end
  end
end
