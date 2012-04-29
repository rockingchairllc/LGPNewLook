class AddActiveToInviteCode < ActiveRecord::Migration
  def up
    add_column :invite_codes, :active, :boolean
  end
  def down
    remove_column :invite_codes, :active
  end
end
