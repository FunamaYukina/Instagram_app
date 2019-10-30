# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :post
  mount_uploader :image_file, ImagesUploader
  validates :image_file, presence: true
  validate :validate_image_file_size

  private

  def validate_image_file_size
    if image_file.size > 4.megabytes
      errors.add(:image_file, "は4MB以下のものをアップロードしてください")
    end
  end
end
