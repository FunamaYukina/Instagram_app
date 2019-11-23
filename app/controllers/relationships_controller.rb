# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticated_user
  before_action :set_variables

  def follow
    current_user.follow(@user.id)
  end

  def unfollow
    current_user.unfollow(@user.id)
  end

  private

  def set_variables
    @user = User.find(params[:user_id])
  end
end
