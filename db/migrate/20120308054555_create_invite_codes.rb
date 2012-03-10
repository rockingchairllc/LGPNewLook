class CreateInviteCodes < ActiveRecord::Migration
  def change
    create_table :invite_codes do |t|
      t.string :code
      t.string :audience
      t.text :comment

      t.timestamps
    end
  end
end
