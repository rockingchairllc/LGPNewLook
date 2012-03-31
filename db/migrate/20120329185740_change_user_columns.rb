class ChangeUserColumns < ActiveRecord::Migration
  def change
      rename_column :users, :username, :firstname
      rename_column :users, :desired, :orientation
    end
  end
