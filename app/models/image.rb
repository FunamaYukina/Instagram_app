# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :post, optional: true
  mount_uploader :image_file, ImagesUploader
  validates :image_file, presence: true
end
