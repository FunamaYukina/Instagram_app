require 'rails_helper'

RSpec.describe User, type: :request do

  describe User do
    it "有効なファクトリを持つこと" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe "POST users#create" do

    context "新規登録ユーザー登録に成功する場合" do
      it "新規登録ページでのresponce成功" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "新規ユーザーを保存" do
        user_param = FactoryBot.attributes_for(:user)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end
      it "emailが大文字でも登録に成功" do
        user_param = FactoryBot.attributes_for(:user, email: "RRR@TEST.com")
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "新規ユーザー登録に失敗する場合" do
      it "新規登録ページでのresponce成功" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "名前が空欄の新規ユーザーの登録に失敗" do
        user_param = FactoryBot.attributes_for(:user, name: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
      end

      it "フルネームが空欄のユーザーの登録の失敗" do
        user_param = FactoryBot.attributes_for(:user, full_name: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
      end

      it "emailが空欄のユーザーの登録の失敗" do
        user_param = FactoryBot.attributes_for(:user, email: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
      end

      it "passwordが空欄のユーザーの登録の失敗" do
        user_param = FactoryBot.attributes_for(:user, password: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
      end

      it "emailが重複した際の登録の失敗" do
        User.create(
            email: "rrr@test.com",
            name: "rrr",
            full_name: "rrrrr",
            password: "rrrrrr")
        user = User.new(
            email: "rrr@test.com",
            name: "sss",
            full_name: "sssss",
            password: "ssssss")
        user.valid?
        expect(user.errors[:email]).to include 'はすでに存在します'
      end

      it "emailのフォーマットが正しくない場合の登録失敗" do
        user = User.new(
            email: "rrrtestcom",
            name: "sss",
            full_name: "sssss",
            password: "ssssss")
        user.valid?
        expect(user.errors[:email]).to include 'は不正な値です'
      end

      it "passwordが６文字未満の場合の登録失敗" do
        user = User.new(
            email: "rrrtestcom",
            name: "sss",
            full_name: "sssss",
            password: "sss")
        user.valid?
        expect(user.errors[:password]).to include 'は6文字以上で入力してください'
      end
    end
  end

  describe "POST login" do
    before do
      User.create(
          email: "rrr@test.com",
          name: "rrr",
          full_name: "rrrrr",
          password: "rrrrrr")
    end

    it "ログインページでのレスポンス成功" do
      get login_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "ログインに成功" do
      post login_path, params: {
          email: "rrr@test.com",
          password: "rrrrrr"
      }
      expect(response.status).to eq(302)
      expect(response).to redirect_to(home_path)
    end

    it "ログインに失敗" do
      post login_path, params: {
          email: "xxx@test.com",
          password: "rrrrrr"
      }
      expect(response.body).to include '間違っています'
    end
  end
end