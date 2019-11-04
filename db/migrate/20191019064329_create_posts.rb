# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :message
      t.references :user, foreign_key: true
      t.integer :likes_count
      t.timestamps
    end
  end
end
