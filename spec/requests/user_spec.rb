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
        expect(response).to redirect_to(home_path)
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
    end
  end
  describe "POST login" do
    it "ログインページでのレスポンス成功" do
      get "/login"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "ログインに成功" do
      post "/login", params: {
          email: "aaa@test.com",
          password: "aaa"
      }
      expect(response.body).to include '間違っています'
    end

    it "ログインに失敗" do
      post "/login", params: {
          email: "xxx@test.com",
          password: "rrr"
      }
      expect(response.body).to include '間違っています'
    end
  end
end