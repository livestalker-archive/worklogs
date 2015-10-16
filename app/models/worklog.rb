class Worklog < ActiveRecord::Base
  unloadable
  attr_accessible :today, :tomorrow, :closed
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
end
