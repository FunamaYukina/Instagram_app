require 'rails_helper'

RSpec.describe User, type: :request do

  describe User do
    it "有効なファクトリを持つこと" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe "POST users#create" do

    context "新規登録ユーザー登録に成功すること" do
      it "レスポンス200が返ってくること" do
        get signup_path
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "新規ユーザーが保存されること" do
        user_param = {
            email: "rrr@test.com",
            user_name: "rrr",
            full_name: "rrrrr",
            password: "rrrrrr",
            password_confirmation: "rrrrrr"}
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.email).to eq user_param[:email]
        expect(response).to redirect_to(root_path)
      end

      it "メールアドレスは小文字で登録されること" do
        user_param = {
            email: "rrr@test.com",
            user_name: "rrr",
            full_name: "rrrrr",
            password: "rrrrrr",
            password_digest: "asdfa"}
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "rrr@test.com"
        expect(response).to redirect_to(root_path)
      end
    end
  end
end