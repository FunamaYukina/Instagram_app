class PostsController < ApplicationController
  def index
    @post = Post.new
  end

  # def new
  #   @post = Post.new
  # end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to home_path
    else
      render("posts/new")
    end
  end


  private

  def post_params
    params.require(:post).permit(:message)
  end
end
