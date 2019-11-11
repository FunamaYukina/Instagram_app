# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  validates :message, length: { maximum: 150 }
  validates :images, presence: true
  validate :images_count

  private

    def images_count
      errors.add(:images, "は1つまでです") if images.size > 1
    end
end
