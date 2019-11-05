# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :posts
  before_save { self.email = email.downcase }
  validates :user_name, presence: true, uniqueness: true
  validates :full_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
end
