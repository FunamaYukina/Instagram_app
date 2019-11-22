# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.eager_load([:posts, posts: %i[images likes]]).order("posts.created_at desc")
    @post = current_user.posts.build if logged_in?
  end
end
