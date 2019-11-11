# frozen_string_literal: true

class User < ApplicationRecord
  include Exceptions
  has_secure_password
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, update_only: true
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

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

  private

    def create_profile
      self.build_profile
    end
end
