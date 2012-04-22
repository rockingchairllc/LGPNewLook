class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :provider_user_id
      t.string :provider_auth_id

      t.timestamps
    end
  end
end
