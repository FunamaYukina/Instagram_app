# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :image_file
      t.boolean :gender
      t.text :introduction
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
