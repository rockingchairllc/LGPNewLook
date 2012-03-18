class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :movie_id
      t.integer :theater_id
      t.datetime :showing_dt

      t.timestamps
    end
  end
end
