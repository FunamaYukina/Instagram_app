# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe "validation" do
    context "新規ユーザーの登録に成功する場合" do
      it "メール、フルネーム、ユーザーネーム、パスワードがあれば有効な状態であること" do
        user = User.new(email: "example@test.com",
                        user_name: "test_user_name",
                        full_name: "test_full_name",
                        password: "test_password",
                        password_confirmation: "test_password")
        expect(user).to be_valid
      end
    end

    context "新規ユーザー登録に失敗する場合" do
      it "emailが重複した場合、ユーザー登録に失敗すること" do
        FactoryBot.create(:user)
        user = FactoryBot.build(:another_user, email: "example@test.com")
        user.valid?
        expect(user.errors.full_messages).to include "メールアドレスはすでに存在します"
      end

      it "名前がない場合ユーザー登録に失敗すること" do
        user.user_name = ""
        user.valid?
        expect(user.errors.full_messages).to include "ユーザーネームを入力してください"
      end

      it "フルネームがない場合ユーザー登録に失敗すること" do
        user.full_name = ""
        user.valid?
        expect(user.errors.full_messages).to include "フルネームを入力してください"
      end

      it "メールアドレスがない場合ユーザー登録に失敗すること" do
        user.email = ""
        user.valid?
        expect(user.errors.full_messages).to include "メールアドレスを入力してください"
      end

      it "パスワードがない場合ユーザー登録に失敗すること" do
        test_user = described_class.new(user_name: "test", full_name: "test", email: "example@test.com")
        test_user.valid?
        expect(test_user.errors.full_messages).to include "パスワードを入力してください"
      end

      it "メールアドレスのフォーマットが正しくない場合にユーザー登録に失敗すること" do
        user.email = "exampletestcom"
        user.valid?
        expect(user.errors.full_messages).to include "メールアドレスは不正な値です"
      end

      it "パスワードが６文字未満の場合ユーザー登録に失敗すること" do
        user.password = "pass"
        user.valid?
        expect(user.errors.full_messages).to include "パスワードは6文字以上で入力してください"
      end

      it "パスワードと確認用パスワードが一致しない場合ユーザー登録に失敗すること" do
        user.password = "password"
        user.password_confirmation = "pass"
        user.valid?
        expect(user.errors.full_messages).to include "再入力パスワードとパスワードの入力が一致しません"
      end
    end
  end
end
