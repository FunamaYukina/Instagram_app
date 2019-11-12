# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login, only: [:create]

  def create
    post = current_user.posts.build(post_params)
# binding.pry
    if post.save
      flash[:success] = "投稿に成功しました"
    else
      flash[:danger] = "投稿に失敗しました"
      flash[:posting_errors] = post.errors.full_messages
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
