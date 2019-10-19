require 'rails_helper'

RSpec.describe User, type: :request do

  describe "POST users#create" do
    context "新規登録ユーザーが妥当な場合" do
      it "signup success" do
        get "/signup"
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "save new user" do
        expect do
          post "/users/create", params: {
              email: "rrr@test.com",
              name: "rrr",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to change(User, :count).by(1)
      end
    end

    context "新規ユーザーが妥当でない場合" do
      it "signup success" do
        get "/signup"
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "failed to save no-name user" do
        expect do
          post "/users/create", params: {
              email: "rrr@test.com",
              name: "",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "failed to save no-full-name user" do
        expect do
          post "/users/create", params: {
              email: "rrr@test.com",
              name: "rrr",
              full_name: "",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "failed to save no-email user" do
        expect do
          post "/users/create", params: {
              email: "",
              name: "rrr",
              full_name: "rrrrr",
              password: "rrr"
          }
        end.to_not change(User, :count)
      end
      it "failed to save no-password user" do
        expect do
          post "/users/create", params: {
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
    it "login success" do
      get "/login"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "can login exist user" do
      post "/login", params: {
          email: "aaa@test.com",
          password: "aaa"
      }
      expect(response.body).to include '間違っています'
    end

    it "can't login non-exist user" do
      post "/login", params: {
          email: "xxx@test.com",
          password: "rrr"
      }
      expect(response.body).to include '間違っています'
    end
  end
end