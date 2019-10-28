# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe Post, type: :model do
  describe "validation" do
    context "新規投稿に成功する場合" do
      it "メッセージがある場合投稿に成功すること" do
        post = FactoryBot.build(:post)
        expect(post).to be_valid
      end

      it "メッセージがない場合でも投稿に成功すること" do
        post = FactoryBot.build(:post, message: "")
        expect(post).to be_valid
      end
    end
  end
end
