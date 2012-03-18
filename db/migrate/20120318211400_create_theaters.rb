class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|
      t.string :theatreId
      t.string :name
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.integer :address_zip
      t.string :address_country
      t.string :telephone
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
