# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: :user_id
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images
  validates :message, length: {maximum: 150}
  validates :images, presence: true
  validate :image_number

  private

  def image_number
    errors.add(:images, "は1つまでです") if images.size > 2
  end
end
