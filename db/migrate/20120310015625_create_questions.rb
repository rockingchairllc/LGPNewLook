class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.boolean :active

      t.timestamps
    end
  end
end
