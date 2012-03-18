class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :TMSId
      t.string :title
      t.text :desc_long
      t.text :genre
      t.string :rating
      t.date :release_dt
      t.string :trailer_url
      
      t.timestamps
    end
  end
end
