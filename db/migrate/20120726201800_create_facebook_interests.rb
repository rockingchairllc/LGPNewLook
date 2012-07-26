class CreateFacebookInterests < ActiveRecord::Migration
  def change
    create_table :facebook_interests do |t|
      t.string :identifier, :unique=>true
      t.string :endpoint
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
