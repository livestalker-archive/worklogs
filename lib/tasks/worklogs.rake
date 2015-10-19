namespace :worklogs do

  desc '10:00 GMT+1, where it\'s expected that the user have started a worklog.'
  task :check_worklogs => :environment do
    day = ENV['day'] || Date.today.to_s
    puts 'Check that all worklogs created.'
    Mailer.with_synched_deliveries do
      WorklogMailer.check_worklogs(day).deliver
    end
  end

  desc '19:00 GMT+1, send the worklog.'
  task :send_worklogs => :environment do
    puts 'Send all worklogs.'
  end

end