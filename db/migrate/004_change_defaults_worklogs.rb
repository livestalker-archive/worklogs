class ChangeDefaultsWorklogs < ActiveRecord::Migration
  def up
    change_column_default :worklogs, :today,  nil
    change_column_default :worklogs, :tomorrow,  nil
    change_column_default :worklogs, :closed,  nil
  end
end
