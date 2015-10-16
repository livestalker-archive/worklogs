class ChangeNullWorklogs < ActiveRecord::Migration
  def up
    change_column :worklogs, :today, :text, :null => true
    change_column :worklogs, :tomorrow, :text, :null => true
    change_column :worklogs, :closed, :text, :null => true
  end
end