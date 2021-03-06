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

  desc '10:00 GMT+1 send reminder users with missings worklogs'
  task :send_reminder => :environment do
    day = ENV['day'] || Date.today.to_s
    puts 'Send reminders'
    unless Setting.plugin_worklogs['WORKLOGS_TURNOFF_GLOBAL'] == '1'
      Mailer.with_synched_deliveries do
        WorklogMailer.send_reminder(day).deliver
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

  desc '12:00 GMT+1 (noon), send estimate pm.'
  task :send_estimate_pm => :environment do
    puts 'Send estimate pm.'
    Mailer.with_synched_deliveries do
      WorklogMailer.send_estimate_pm.deliver
    end
  end

  desc '12:00 GMT+1 (noon), send estimate dev.'
  task :send_estimate_dev => :environment do
    puts 'Send estimate dev.'
    Mailer.with_synched_deliveries do
      WorklogMailer.send_estimate_dev.deliver
    end
  end

  desc '12:00 GMT+1 (noon), send personal DEV reports'
  task :send_estimate_dev_p => :environment do
    puts 'Send personal estimate dev'
    # constants
    anjep_group_id = 3
    active_user_status_id = '1'
    # Anjep group
    @group = Group.find(anjep_group_id)
    # Active users in group
    @users = @group.users.status(active_user_status_id)
    @users.each do |user|
      Mailer.with_synched_deliveries do
        WorklogMailer.send_estimate_dev_p(user).deliver
      end
    end
  end
end