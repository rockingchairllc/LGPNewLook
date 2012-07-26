class CreateFacebookInterestsUsers < ActiveRecord::Migration
  def change
    create_table :facebook_interests_users, :id=>false do |t|
      t.integer :facebook_interest_id
      t.integer :user_id

      t.timestamps
    end
  end
end
