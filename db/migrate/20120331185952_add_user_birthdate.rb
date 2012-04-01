class AddUserBirthdate < ActiveRecord::Migration
  def up
    add_column :users, :birthdate, :datetime 
 
  end

  def down
    remove_column :users, :birthdate 
  end
end
