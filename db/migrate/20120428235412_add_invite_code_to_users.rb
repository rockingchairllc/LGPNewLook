class AddInviteCodeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :invite_code_id, :integer
  end
  def down
    remove_column :users, :invite_code_id
  end
end
