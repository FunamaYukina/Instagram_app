class RelationshipsController < ApplicationController
  before_action :authenticated_user

  def follow
    user = User.find_by(user_name: params[:username])
    current_user.follow(user)
  end

  def unfollow
    user =Relationship.find_by(user_name: params[:username]).followed
    current_user.unfollow(user)
  end
end
