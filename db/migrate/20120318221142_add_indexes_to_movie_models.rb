class AddIndexesToMovieModels < ActiveRecord::Migration
  def change
    add_index :movies, :TMSId
    add_index :theaters, :theatreId
    add_index :schedules, :theater_id
    add_index :schedules, :movie_id
  end
end
