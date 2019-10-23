require 'rails_helper'

RSpec.describe "Session", type: :request do

  before(:each) do
    User.create(
        email: "rrr@test.com",
        user_name: "rrr",
        full_name: "rrrrr",
        password: "rrrrrr",
        password_confirmation: "rrrrrr")
  end

  describe "#login_form" do
    context "未ログインの場合" do

      it "ログインページでレスポンス200が返ってくること" do
        get login_path
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

    end
    context "ログイン済みの場合" do

      it "ログインページにアクセスしてもTOPへリダイレクトすること" do
        post login_path, params: {
            email: "rrr@test.com",
            password: "rrrrrr"
        }
        get login_path
        expect(response).to redirect_to root_path
      end

    end
  end
  describe "#login" do
    context "未ログインの場合" do

      it "ユーザーがデータベースにあった場合ログインに成功すること" do
        post login_path, params: {
            email: "rrr@test.com",
            password: "rrrrrr"
        }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end

      it "ユーザーがデータベースにない場合ログインに失敗すること" do
        post login_path, params: {
            email: "xxx@test.com",
        }
        expect(response.body).to include '間違っています'
      end
    end

    context "ログイン済みの場合" do
      it "ログアウトに成功すること" do
        post login_path, params: {
            email: "rrr@test.com",
            password: "rrrrrr"
        }
        post logout_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end