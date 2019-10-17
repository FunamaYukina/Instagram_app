class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :full_name
      t.integer :phone_number
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
