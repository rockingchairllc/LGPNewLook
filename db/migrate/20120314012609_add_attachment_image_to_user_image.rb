class AddAttachmentImageToUserImage < ActiveRecord::Migration
  def change
     create_table :user_images do |t|
       t.integer :user_id
     end
  end
end
