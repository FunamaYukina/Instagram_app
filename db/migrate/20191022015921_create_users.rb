class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name, null: false, unique: true
      t.string :full_name, null: false
      t.string :email, null: false, unique: true
      t.string :password, null: false
    end
  end
end
