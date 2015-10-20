namespace :worklogs do

  desc '10:00 GMT+1, where it\'s expected that the user have started a worklog.'
  task :check_worklogs => :environment do
    day = ENV['day'] || Date.today.to_s
    puts 'Check that all worklogs created.'
    unless Setting.plugin_worklogs['WORKLOGS_TURNOFF_GLOBAL'] == '1'
      Mailer.with_synched_deliveries do
        WorklogMailer.check_worklogs(day).deliver
      end
    end
  end

  desc '19:00 GMT+1, send the worklog.'
  task :send_worklogs => :environment do
    day = ENV['day'] || Date.today.to_s
    puts 'Send all worklogs.'
    unless Setting.plugin_worklogs['WORKLOGS_TURNOFF_GLOBAL'] == '1'
      Mailer.with_synched_deliveries do
        WorklogMailer.send_all_worklogs(day).deliver
      end
    end
  end

end