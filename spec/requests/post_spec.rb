# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts", type: :request do
  describe "#create" do
    context "未ログインの場合" do
      it "画像とメッセージのとうこうができないこと" do
      end
    end

    context "未ログインの場合" do
      it "画像とメッセージが保存されること" do
      end

      it "画像とメッセージ投稿後flashが表示されること" do
      end

      it "画像とメッセージが投稿できること" do
      end
    end
  end
end
