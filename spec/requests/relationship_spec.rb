# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "relationships", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  describe "#follow_and_#unfollow" do
    context "未ログインの場合" do
      it "フォローするボタンが表示されないこと" do
        get user_path(user.user_name)
        expect(response.body).not_to include ".follow_button"
      end

      it "フォローができないこと" do
        expect do
          post follow_path(username: user.user_name), params: { username: user.user_name }
        end.not_to change(Relationship, :count)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      it "フォローできること" do
        expect do
          post follow_path(username: another_user.user_name), params: { username: user.user_name }
        end.to change(Relationship, :count)
      end

      it "フォローボタンが表示されていること" do
      end

      it "フォローしていた場合、アンフォローできること"
    end
  end
end
