# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login, only: [:create]

  def create
    post = current_user.posts.build(post_params)
    if post.save
      flash[:notice] = "投稿を作成しました"
    else
      flash[:danger] = "画像の形式が間違っております。"
    end

    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:message, [images_attributes: %i[image_file post_id]])
    end

    def require_login
      redirect_to login_path and return unless logged_in?
    end
end
