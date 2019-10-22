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
        user_param = FactoryBot.attributes_for(:user)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.email).to eq user_param[:email]
        expect(response).to redirect_to(root_path)
      end

      it "メールアドレスは小文字で登録されること" do
        user_param = FactoryBot.attributes_for(:user, email: "RRR@TEST.com")
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(302)
        expect(User.last.email).to eq "rrr@test.com"
        expect(response).to redirect_to(root_path)
      end
    end

    context "新規ユーザー登録に失敗する場合" do

      it "名前がない場合ユーザー登録に失敗すること" do
        user_param = FactoryBot.attributes_for(:user, user_name: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include 'ユーザーネームを入力してください'
      end

      it "フルネームがない場合ユーザー登録に失敗すること" do
        user_param = FactoryBot.attributes_for(:user, full_name: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include 'フルネームを入力してください'
      end

      it "メールアドレスがない場合ユーザー登録に失敗すること" do
        user_param = FactoryBot.attributes_for(:user, email: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include 'メールアドレスを入力してください'
      end

      it "パスワードがない場合ユーザー登録に失敗すること" do
        user_param = FactoryBot.attributes_for(:user, password: nil)
        post signup_path, params: {user: user_param}
        expect(response.status).to eq(200)
        expect(response.body).to include 'パスワードを入力してください'
      end

      it "メールアドレスのフォーマットが正しくない場合にユーザー登録に失敗すること" do
        user = User.new(
            email: "rrrtestcom",
            user_name: "sss",
            full_name: "sssss",
            password: "ssssss")
        user.valid?
        expect(user.errors[:email]).to include 'は不正な値です'
      end

      it "パスワードが６文字未満の場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "rrrtestcom",
            user_name: "sss",
            full_name: "sssss",
            password: "sss")
        user.valid?
        expect(user.errors[:password]).to include 'は6文字以上で入力してください'
      end
    end
  end

end