require 'rails_helper'

RSpec.describe User, type: :request do

  describe "POST users#create" do
    context "新規登録ユーザー登録に成功する場合" do
      it "新規登録ページでのresponce成功" do
        get "/signup"
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "新規ユーザーを保存" do
        expect do
          post "/signup", params: {
              email: "rrr@test.com",
              name: "rrr",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to change(User, :count).by(1)
      end
    end

    context "新規ユーザー登録に失敗する場合" do
      it "新規登録ページでのresponce成功" do
        get "/signup"
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "新規ユーザーの登録に失敗" do
        expect do
          post "/signup", params: {
              email: "rrr@test.com",
              name: "",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "フルネームが空欄のユーザーの登録の失敗" do
        expect do
          post "/signup", params: {
              email: "rrr@test.com",
              name: "rrr",
              full_name: "",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "emailが空欄のユーザーの登録の失敗" do
        expect do
          post "/signup", params: {
              email: "",
              name: "rrr",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "passwordが空欄のユーザーの登録の失敗" do
        expect do
          post "/signup", params: {
              email: "rrr@test.com",
              name: "rrr",
              full_name: "rrrrr",
              password: ""
          }
        end.to_not change(User, :count)
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