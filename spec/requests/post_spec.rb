# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "posts", type: :request do
  describe "#create" do
    context "未ログインの場合" do
      it "投稿フォームが表示されないこと" do
        get root_path
        expect(response.body).not_to include "新規投稿"
      end

      it "画像とメッセージの投稿に失敗すること" do
        post_param = FactoryBot.attributes_for(:post, :with_picture)
        post post_path, params: {
            post: post_param
        }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before do
        FactoryBot.create(:user)
        log_in
      end

      it "投稿フォームが表示されること" do
        get root_path
        expect(response.body).to include "新規投稿"
      end

      it "画像とメッセージの投稿に成功すること" do
        post_param = FactoryBot.attributes_for(:post, :with_picture)
        post post_path, params: {
            post: post_param
        }
        expect(response.status).to eq(302)
        expect(Post.last.message).to eq post_param[:message]
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
