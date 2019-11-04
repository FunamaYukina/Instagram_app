# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, class_name: User, foreign_key: :user_id
  has_many :images
  accepts_nested_attributes_for :images
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  validates :message, length: { maximum: 150 }
end
