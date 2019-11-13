# frozen_string_literal: true

class User < ApplicationRecord
  include Exceptions
  include SessionHelper

  has_secure_password
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, update_only: true
  has_many :likes, dependent: :destroy

  before_save { self.email = email.downcase }
  validates :user_name, presence: true, uniqueness: true
  validates :full_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
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

  private

    def create_profile
      self.build_profile
    end
end
