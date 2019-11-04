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
        post_param = attributes_for(:post, :with_picture)
        post posts_path(id: 0), params: {
          post: post_param
        }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before do
        user = create(:user)
        log_in(user)
      end

      it "投稿フォームが表示されること" do
        get root_path
        expect(response.body).to include "新規投稿"
      end

      # it "画像とメッセージの投稿に成功すること" do
      #   get root_path
      #   post_param = FactoryBot.attributes_for(:post, :with_picture)
      #   post posts_path(id: User.last.id), params: {
      #       post: post_param
      #   }
      #   expect(response.status).to eq(302)
      #   expect(Post.last.message).to eq post_param[:message]
      #   binding.pry
      #   expect(Post.last.images.image_file).to eq "#{Rails.root}/spec/fixtures/test.jpg"
      #   expect(response).to redirect_to root_path
      # end
      #   it "画像の形式が正しくない場合、投稿に失敗すること" do
      #     get root_path
      #     post_param = FactoryBot.attributes_for(:post, :with_incorrect_file)
      #     post posts_path(id: User.last.id), params: {
      #         post: post_param
      #     }
      #     expect(response.status).to eq(302)
      #     expect(Post.last.message).not_to eq post_param[:message]
      #     expect(response).to redirect_to root_path
      #   end
    end
  end
end
