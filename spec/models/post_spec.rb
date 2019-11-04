# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe Post, type: :model do
  describe "validation" do
    context "新規投稿に成功する場合" do
      it "メッセージがある場合、投稿に成功すること" do
        post = build(:post)
        expect(post).to be_valid
      end

      it "メッセージがない場合でも投稿に成功すること" do
        post = build(:post, message: "")
        expect(post).to be_valid
      end
    end

    context "新規投稿に失敗する場合" do
      it "メッセージが150文字を超える場合、投稿に失敗すること" do
        post = build(:post, message: "a" * 151)
        expect(post).not_to be_valid
        expect(post.errors.full_messages).to include "メッセージは150文字以内で入力してください"
      end
    end
  end
end
