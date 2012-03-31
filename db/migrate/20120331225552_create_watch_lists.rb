class CreateWatchLists < ActiveRecord::Migration
  def change
    create_table :watch_lists do |t|
      t.integer :user_id
      t.integer :movie_id
      t.text :note

      t.timestamps
    end
  end
end
