# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  mount_uploader :image_file, ImagesUploader
  validates :introduction, length: { maximum: 150 }, on: :create
  validates :introduction, length: { maximum: 150 }, on: :update, allow_blank: true

  validate :validate_image_file_size

  private

    def validate_image_file_size
      return unless image_file.size > 4.megabytes

      errors.add(:image_file, "は4MB以下のものをアップロードしてください")
    end
end
