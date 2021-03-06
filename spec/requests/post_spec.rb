# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "posts", type: :request do
  describe "#create" do
    let(:user) { create(:user) }

    context "未ログインの場合" do
      it "投稿フォームが表示されないこと" do
        get root_path
        expect(response.body).not_to include "新規投稿"
      end

      it "画像とメッセージの投稿に失敗すること" do
        post_param = attributes_for(:post, :with_picture)
        post posts_path(username: user.user_name), params: {
          post: post_param
        }
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      it "投稿フォームが表示されること" do
        get root_path
        expect(response.body).to include "新規投稿"
      end

      context "投稿に成功する場合" do
        it "画像とメッセージの投稿に成功すること" do
          get root_path
          post_params = attributes_for(:no_images_post)
          expect do
            post posts_path(username: user.user_name), params: {
              post: {
                message: post_params[:message],
                images_attributes: {
                  "0": FactoryBot.attributes_for(:image)
                }
              }
            }
          end.to change(Post, :count).by(1).and change(Image, :count).by(1)
          expect(response.status).to eq(302)
          expect(Post.last.message).to eq post_params[:message]
          expect(response).to redirect_to root_path
        end
      end

      context "投稿に失敗する場合" do
        it "画像の形式が正しくない場合、投稿に失敗すること" do
          get root_path
          post_params = FactoryBot.attributes_for(:no_images_post)
          expect do
            post posts_path(username: user.user_name), params: {
              post: {
                message: post_params[:message],
                images_attributes: {
                  "0": FactoryBot.attributes_for(:image, :with_incorrect_file_type)
                }
              }
            }
          end.to change(Post, :count).by(0).and change(Image, :count).by(0)
          expect(flash[:posting_errors]).to include "画像の形式が違います"
          expect(response).to redirect_to root_path
        end

        it "複数の画像を一度に追加した場合、投稿に失敗すること" do
          get root_path
          post_params = FactoryBot.attributes_for(:no_images_post)
          expect do
            post posts_path(username: user.user_name), params: {
              post: {
                message: post_params[:message],
                images_attributes: {
                  "0": FactoryBot.attributes_for(:image, :with_picture),
                  "1": FactoryBot.attributes_for(:image, :with_picture)
                }
              }
            }
          end.to change(Post, :count).by(0).and change(Image, :count).by(0)
          expect(flash[:posting_errors]).to include "画像は1つまでです"
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
