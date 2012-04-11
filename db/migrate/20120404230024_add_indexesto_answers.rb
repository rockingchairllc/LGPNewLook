class AddIndexestoAnswers < ActiveRecord::Migration
  def up
    add_index :answers, :user_id
    add_index :answers, :question_id
  end

  def down
    remove_index :answers, :column => :user_id
    remove_index :answers, :column => :question_id
  end
end
