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
      it "新規登録ページにアクセスできること" do
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
      it "新規ユーザーが保存されること" do
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

    context "新規ユーザーの保存に失敗する場合" do
      it "メールアドレスがない場合登録に失敗すること" do
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
end
