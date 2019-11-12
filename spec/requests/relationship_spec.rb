
require "rails_helper"
require "support/utilities"

RSpec.describe "relationships", type: :request do
  describe "#follow_and_#unfollow" do
    context "未ログインの場合" do
      it "フォローするボタンが表示されないこと"
      it "フォローができないこと"
    end

    context "ログイン済みの場合" do
      it "フォローするボタンが表示されること"
      it "フォローできること"
      it "フォローしていた場合、アンフォローできること"
    end
  end
end