require 'rails_helper'

RSpec.describe "Session", type: :request do
  describe "POST login" do
    before do
      User.create(
          email: "rrr@test.com",
          user_name: "rrr",
          full_name: "rrrrr",
          password: "rrrrrr")
    end

    it "ログインページでレスポンス200が返ってくること" do
      get login_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

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
          password: "rrrrrr"
      }
      expect(response.body).to include '間違っています'
    end
  end
end