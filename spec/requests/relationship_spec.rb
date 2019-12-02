# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "relationships", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  describe "#follow" do
    context "未ログインの場合" do
      it "フォローするボタンが表示されないこと" do
        get user_path(user.user_name)
        expect(response.body).not_to include ".follow_button"
      end

      it "フォローができないこと" do
        expect do
          post follow_path(username: user.user_name), xhr: true
        end.not_to change(Relationship, :count)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      it "フォローできること" do
        expect do
          post follow_path(username: another_user.user_name), xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it "フォローボタンを２回押した場合、フォローが１回できること" do
        expect do
          post follow_path(username: another_user.user_name), xhr: true
          post follow_path(username: another_user.user_name), xhr: true
        end.to raise_error(ActiveRecord::RecordInvalid).and change(Relationship, :count).by(1)
      end

      it "自分自身をフォローできないこと" do
        expect do
          post follow_path(username: user.user_name), xhr: true
        end.not_to change(Relationship, :count)
      end
    end
  end

  describe "#unfollow" do
    context "未ログインの場合" do
      it "フォロー解除するボタンが表示されないこと" do
        get user_path(user.user_name)
        expect(response.body).not_to include ".unfollow_button"
      end

      it "フォロー解除ができないこと" do
        post follow_path(username: another_user.user_name), xhr: true
        expect do
          delete unfollow_path(username: another_user.user_name), xhr: true
        end.not_to change(Relationship, :count)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
        post follow_path(username: another_user.user_name), xhr: true
      end

      it "フォロー解除できること" do
        expect do
          delete unfollow_path(username: another_user.user_name), xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it "フォロー解除ボタンを２回押した場合、フォロー解除が１回できること" do
        expect do
          delete unfollow_path(username: another_user.user_name), xhr: true
          delete unfollow_path(username: another_user.user_name), xhr: true
        end.to raise_error(ActiveRecord::RecordNotFound).and change(Relationship, :count).by(-1)
      end
    end
  end
end
