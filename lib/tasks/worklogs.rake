namespace :worklogs do

  desc '10:00 GMT+1, where it\'s expected that the user have started a worklog.'
  task :check_worklogs => :environment do
    puts 'Check that all worklogs created.'
  end

  desc '19:00 GMT+1, send the worklog.'
  task :send_worklogs => :environment do
    puts 'Send all worklogs.'
  end

end