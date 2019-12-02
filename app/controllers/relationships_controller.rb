# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticated_user
  before_action :set_user

  def follow
    current_user.follow!(@user.id)
  end

  def unfollow
    current_user.unfollow!(@user.id)
  end
end
