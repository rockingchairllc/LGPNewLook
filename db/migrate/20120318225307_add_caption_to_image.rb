class AddCaptionToImage < ActiveRecord::Migration
  def change
    add_column :user_images, :caption, :text
    add_column :user_images, :is_profile_pic, :boolean
  end
end
