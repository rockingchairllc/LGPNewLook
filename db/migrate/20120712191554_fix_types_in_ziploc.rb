class FixTypesInZiploc < ActiveRecord::Migration
  def up
    remove_column :zip_locs, :zip
    remove_column :zip_locs, :lat
    remove_column :zip_locs, :lng
    add_column :zip_locs, :zip, :string
    add_column :zip_locs, :lat, :float
    add_column :zip_locs, :lng, :float
  end

  def down
    remove_column :zip_locs, :zip
    remove_column :zip_locs, :lat
    remove_column :zip_locs, :lng
    add_column :zip_locs, :zip, :integer
    add_column :zip_locs, :lat, :decimal
    add_column :zip_locs, :lng, :decimal
  end
end
