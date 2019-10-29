# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @post = Post.new
  end

  def new
    @post = Post.new
    @post.images.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to root_path
    else
      render("home/top")
    end
  end

  private

    def post_params
      params.require(:post).permit(:message, [images_attributes: %i[image_file post_id]])
    end

    def require_login
      redirect_to login_path and return unless logged_in?
    end
end
