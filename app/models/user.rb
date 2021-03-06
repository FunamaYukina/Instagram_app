# frozen_string_literal: true

class User < ApplicationRecord
  include Exceptions

  has_secure_password
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, update_only: true
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }
  validates :user_name, presence: true, uniqueness: true
  validates :full_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX, allow_blank: true },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_create :create_profile

  def update_password(current_password, new_password, new_password_confirmation)
    raise NoCurrentPasswordError, "現在のパスワードが違います" unless !!authenticate(current_password)

    self.update!(password: new_password, password_confirmation: new_password_confirmation)
  end

  def liked?(post_id)
    # ここはcurrent_userの持つpost.likeの１つ１つの情報を毎回SQLでとってくるようなコードになっていたので、
    # はじめにcurrent_userのlikesからpost_idだけを抜き出して配列に置き換え、その中に今回選択したpost_idが
    # 入っているかどうか？をチェックすることにしました。（フナマ）
    @post_ids ||= self.likes.all.map { |i| i[:post_id] }
    @post_ids.include?(post_id)
  end

  def like!(post_id)
    likes.create(post_id: post_id)
  end

  def unlike!(post_id)
    like = likes.find_by!(post_id: post_id)
    like.destroy
  end

  def followed?(user)
    self.following.include?(user)
  end

  def follow!(user_id)
    unless self.id == user_id
      self.active_relationships.create!(followed_id: user_id)
    end
  end

  def unfollow!(user_id)
    active_relationships.find_by!(followed_id: user_id).destroy
  end

  private

    def create_profile
      self.build_profile
    end
end
