class CreateWorklogs < ActiveRecord::Migration
  def change
    create_table :worklogs do |t|
      t.integer :user_id
      t.string :today
      t.string :tomorrow
      t.string :closed
    end
  end
end
