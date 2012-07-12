class AddLatAndLongToUsers < ActiveRecord::Migration
  def up
    add_column :users, :zipcode_longitude, :float
    add_column :users, :zipcode_latitude, :float
  end
  def down
    remove_column :users, :zipcode_latitude
    remove_column :users, :zipcode_longitude
  end
end
