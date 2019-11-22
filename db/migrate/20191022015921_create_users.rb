# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name, null: false, unique: true
      t.string :full_name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
    end
    add_index :users, :email
    add_index :users, :user_name
  end
end
