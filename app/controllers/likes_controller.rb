# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticated_user
  before_action :set_variables

  def like
    current_user.like!(@post.id)
  end

  def unlike
    current_user.unlike!(@post.id)
  end

  private

    def set_variables
      @post = Post.find(params[:post_id])
    end

end
