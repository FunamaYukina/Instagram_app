# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user, class_name: User, foreign_key: :user_id
  validates :introduction, length: { maximum: 150 }
end
