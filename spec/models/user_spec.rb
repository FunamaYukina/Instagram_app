require 'rails_helper'

RSpec.describe User, type: :model do

  it "emailが重複した場合、ユーザー登録に失敗すること" do
    User.create(
        email: "rrr@test.com",
        user_name: "rrr",
        full_name: "rrrrr",
        password: "rrrrrr",
        password_confirmation: "rrrrrr")
    user = User.new(
        email: "rrr@test.com",
        user_name: "sss",
        full_name: "sssss",
        password: "rrrrrr",
        password_confirmation: "rrrrrr")
    user.valid?
    expect(user.errors.full_messages).to include 'メールアドレスはすでに存在します'
  end
  describe "#signup" do
    context "新規ユーザー登録に失敗する場合" do

      it "名前がない場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "rrr@test.com",
            user_name: "",
            full_name: "sssss",
            password: "rrrrrr",
            password_confirmation: "rrrrrr")
        user.valid?
        expect(user.errors.full_messages).to include("ユーザーネームを入力してください")
      end

      it "フルネームがない場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "rrr@test.com",
            user_name: "rrr",
            full_name: "",
            password: "rrrrrr",
            password_confirmation: "rrrrrr")
        user.valid?
        # binding.pry
        expect(user.errors.full_messages).to include("フルネームを入力してください")

      end

      it "メールアドレスがない場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "",
            user_name: "rrr",
            full_name: "rrrrr",
            password: "rrrrrr",
            password_confirmation: "rrrrrr")
        user.valid?
        expect(user.errors.full_messages).to include 'メールアドレスを入力してください'
      end

      it "パスワードがない場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "rrr@test.com",
            user_name: "rrr",
            full_name: "rrrrr",
            password: "",
            password_confirmation: "rrrrrr")
        user.valid?
        expect(user.errors.full_messages).to include 'パスワードを入力してください'
      end

      it "メールアドレスのフォーマットが正しくない場合にユーザー登録に失敗すること" do
        user = User.new(
            email: "rrrtestcom",
            user_name: "sss",
            full_name: "sssss",
            password: "rrrrrr",
            password_confirmation: "rrrrrr")
        user.valid?
        expect(user.errors.full_messages).to include 'メールアドレスは不正な値です'
      end

      it "パスワードが６文字未満の場合ユーザー登録に失敗すること" do
        user = User.new(
            email: "rrr@test.com",
            user_name: "sss",
            full_name: "sssss",
            password: "sss")
        user.valid?
        expect(user.errors.full_messages).to include 'パスワードは6文字以上で入力してください'
      end
    end
  end
end