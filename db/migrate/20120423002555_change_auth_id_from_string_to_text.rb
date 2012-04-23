class ChangeAuthIdFromStringToText < ActiveRecord::Migration
  def up
    remove_column :authentications, :provider_auth_id
    add_column :authentications, :provider_auth_id, :text
  end

  def down
    remove_column :authentications, :provider_auth_id
    add_column :authentications, :provider_auth_id, :string
  end
end
