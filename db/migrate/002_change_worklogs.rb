class ChangeWorklogs < ActiveRecord::Migration
 def up
   change_column :worklogs, :today, :string, :default => '', :null => false
   change_column :worklogs, :tomorrow, :string, :default => '', :null => false
   change_column :worklogs, :closed, :string, :default => '', :null => false
 end
end