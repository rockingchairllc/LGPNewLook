class CreateZipLocs < ActiveRecord::Migration
  def change
    create_table :zip_locs do |t|
      t.integer :zip
      t.decimal :lat
      t.decimal :lng

      t.timestamps
    end
  end
end
