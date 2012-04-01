class AddUniqueIndexToWatchListAndPrefTheaters < ActiveRecord::Migration
  def up
    add_index :watch_lists, [:user_id, :movie_id], :unique=>true, :name=>'index_uniq_wl_user_movie'
    add_index :watch_list_preferred_theaters, [:watch_list_id, :theater_id], :unique=>true, :name=>'index_uniq_wlpt_wl_theater'
  end
  def down
    remove_index :watch_lists, :name=>'index_uniq_wl_user_movie'
    remove_index :watch_list_preferred_theaters, :name=>'index_uniq_wlpt_wl_theater'
  end
end
