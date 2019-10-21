class AddNullToUsers < ActiveRecord::Migration[5.1]
  def up
    change_column_null :users, :name, false, 0
    change_column_null :users, :full_name, false, 0
    change_column_null :users, :email, false, 0
    change_column_null :users, :password, false, 0
    change_column :users, :name, :integer, default: 0
    change_column :users, :full_name, :integer, default: 0
    change_column :users, :email, :integer, default: 0
    change_column :users, :password, :integer, default: 0
  end

  def down
    change_column_null :users, :name, true, nil
    change_column_null :users, :full_name, true, nil
    change_column_null :users, :email,  true, nil
    change_column_null :users, :password,  true, nil
    change_column :users, :name, :integer, default: nil
    change_column :users, :full_name, :integer, default: nil
    change_column :users, :email, :integer, default: nil
    change_column :users, :password, :integer, default: nil
  end
end
