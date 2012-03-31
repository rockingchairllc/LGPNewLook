class CreateWatchListPreferredTheaters < ActiveRecord::Migration
  def change
    create_table :watch_list_preferred_theaters do |t|
      t.integer :watch_list_id
      t.integer :theater_id

      t.timestamps
    end
  end
end
