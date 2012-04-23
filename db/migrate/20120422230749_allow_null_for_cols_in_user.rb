class AllowNullForColsInUser < ActiveRecord::Migration
  def up
    remove_column :users, :zipcode
    add_column :users, :zipcode, :string

    remove_column :users, :orientation
    add_column :users, :orientation, :string

  end

  def down
    remove_column :users, :zipcode
    add_column :users, :zipcode, :integer, :null => false

    remove_column :users, :orientation
    add_column :users, :orientation, :string, :null => false

  end
end
