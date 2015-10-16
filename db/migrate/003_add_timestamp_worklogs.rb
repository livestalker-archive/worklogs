class AddTimestampWorklogs < ActiveRecord::Migration
  def up
    add_column :worklogs, :created_at, :timestamp
  end

  def down
    remove_column :worklogs, :created_at
  end
end