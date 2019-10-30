# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, class_name: User, foreign_key: :user_id
  has_many :images
  accepts_nested_attributes_for :images
  validates :message, length: { maximum: 150 }

end
