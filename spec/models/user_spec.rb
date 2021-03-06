# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

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

      it "User保存時にProfileも一緒に生成されること" do
        expect do
          create(:user)
        end.to change(User, :count).by(1).and change(Profile, :count).by(1)
      end
    end

    context "新規ユーザー登録に失敗する場合" do
      it "emailが重複した場合、ユーザー登録に失敗すること" do
        create(:user)
        existing_user = build(:another_user, email: "example@test.com")
        existing_user.valid?
        expect(existing_user.errors.full_messages).to include "メールアドレスはすでに存在します"
      end

      it "ユーザーネームが重複した場合、ユーザー登録に失敗すること" do
        create(:user)
        existing_user = build(:another_user, user_name: "test_user_name")
        existing_user.valid?
        expect(existing_user.errors.full_messages).to include "ユーザーネームはすでに存在します"
      end

      it "ユーザーネームがない場合、ユーザー登録に失敗すること" do
        user.user_name = ""
        user.valid?
        expect(user.errors.full_messages).to include "ユーザーネームを入力してください"
      end

      it "フルネームがない場合、ユーザー登録に失敗すること" do
        user.full_name = ""
        user.valid?
        expect(user.errors.full_messages).to include "フルネームを入力してください"
      end

      it "メールアドレスがない場合、ユーザー登録に失敗すること" do
        user.email = ""
        user.valid?
        expect(user.errors.full_messages).to include "メールアドレスを入力してください"
      end

      it "パスワードがない場合、ユーザー登録に失敗すること" do
        test_user = described_class.new(user_name: "test", full_name: "test", email: "example@test.com")
        test_user.valid?
        expect(test_user.errors.full_messages).to include "パスワードを入力してください"
      end

      it "メールアドレスのフォーマットが正しくない場合、ユーザー登録に失敗すること" do
        user.email = "exampletestcom"
        user.valid?
        expect(user.errors.full_messages).to include "メールアドレスは不正な値です"
      end

      it "パスワードが６文字未満の場合、ユーザー登録に失敗すること" do
        user.password = "pass"
        user.valid?
        expect(user.errors.full_messages).to include "パスワードは6文字以上で入力してください"
      end

      it "パスワードと確認用パスワードが一致しない場合、ユーザー登録に失敗すること" do
        user.password = "password"
        user.password_confirmation = "pass"
        user.valid?
        expect(user.errors.full_messages).to include "再入力パスワードとパスワードの入力が一致しません"
      end
    end
  end

  describe "#update_password" do
    let(:user) { create(:user) }
    let(:current_password) { user.password }

    context "現在のパスワードが正しい場合" do
      context "パスワードと確認用パスワードが一致している場合" do
        it "更新に成功すること" do
          new_password = "updated_password"
          user.update_password(current_password, new_password, new_password)

          expect(!!user.reload.authenticate(new_password)).to be true
        end
      end

      context "パスワードと確認用パスワードが一致していない場合" do
        it "Validationエラーが発生すること" do
          expect do
            user.update_password(current_password, "password", "buzzword")
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect(!!user.reload.authenticate("password")).to be false
          expect(user.errors.full_messages).to include "再入力パスワードとパスワードの入力が一致しません"
        end
      end
    end

    context "現在のパスワードが正しくない場合" do
      it "NoCurrentPasswordErrorが発生すること" do
        new_password = "updated_password"
        expect do
          user.update_password("buzzword", new_password, new_password)
        end.to raise_error(Exceptions::NoCurrentPasswordError)

        expect(!!user.reload.authenticate(new_password)).to be false
      end
    end
  end

  describe "#liked?" do
    it "いいねしている場合、trueが返ってくること" do
      user = create(:user, :with_post, :with_like)
      expect(user.liked?(Post.first.id)).to be true
    end

    it "いいねしていない場合、falseが返ってくること" do
      user = create(:user, :with_post)
      expect(user.liked?(Post.first.id)).to be false
    end
  end

  describe "#like!" do
    let(:user) { create(:user, :with_post) }

    it "投稿が存在する場合、いいねに成功すること" do
      expect do
        user.like!(Post.first.id)
      end.to change(Like, :count).by(1)
    end

    it "投稿が存在しない場合、いいねに失敗すること" do
      expect do
        user.like!(999)
      end.not_to change(Like, :count)
    end
  end

  describe "#unlike!" do
    let(:user) { create(:user, :with_post, :with_like) }

    it "投稿が存在する場合、いいねの解除に成功すること" do
      user
      expect do
        user.unlike!(Post.first.id)
      end.to change(Like, :count).by(-1)
    end

    it "投稿が存在しない場合、いいねの解除に失敗すること" do
      user
      expect do
        user.unlike!(999)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#follow" do
    let!(:user) { create(:user) }
    let(:another_user) { create(:another_user) }

    it "ユーザーが存在する場合、フォローに成功すること" do
      expect do
        user.follow!(another_user.id)
      end.to change(Relationship, :count).by(1)
    end

    it "ユーザーが存在しない場合、フォローに失敗すること" do
      not_exist_user = build(:another_user)
      not_exist_user.id = 999
      expect do
        user.follow!(not_exist_user.id)
      end.to raise_error(ActiveRecord::RecordInvalid).and change(Relationship, :count).by(0)
    end
  end

  describe "#unfollow" do
    let!(:user) { create(:user) }
    let(:another_user) { create(:another_user) }

    it "ユーザーが存在する場合、フォローの解除に成功すること" do
      user.follow!(another_user.id)
      expect do
        user.unfollow!(another_user.id)
      end.to change(Relationship, :count).by(-1)
    end

    it "ユーザーが存在しない場合、フォロー解除に失敗すること" do
      not_exist_user = build(:another_user)
      expect do
        user.unfollow!(not_exist_user.id)
      end.to raise_error(ActiveRecord::RecordNotFound).and change(Relationship, :count).by(0)
    end
  end
end
