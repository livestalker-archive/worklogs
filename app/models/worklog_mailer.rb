#encoding: utf-8
class WorklogMailer < Mailer

  def get_all_debtors
    @all_users = User.status('1').all
    users_need_worklogs = Array.new
    @all_users.each do |user|
      worklog = Worklog.where(:user_id => user.id).where('DATE(created_at) = ?', @day)
      if worklog.empty?
        users_need_worklogs.push user.id
      end
    end
    @all_need_worklogs_users = User.where(id: users_need_worklogs)
  end

  def check_worklogs(day)
    @day = day || Date.today.to_s
    get_all_debtors
    recipients = @all_need_worklogs_users.collect(&:mail)
    mail :to => Setting.plugin_worklogs['WORKLOGS_MAIL_GLOBAL'],
         :cc => Setting.plugin_worklogs['WORKLOGS_MAIL_CC'],
         :subject => 'Missing worklogs'
  end

  def send_all_worklogs(day)
    @day = day || Date.today.to_s
    @worklogs = Worklog.where('DATE(created_at) = ?', @day).order('created_at desc, id desc')
    mail :to => Setting.plugin_worklogs['WORKLOGS_MAIL_GLOBAL'],
         :cc => Setting.plugin_worklogs['WORKLOGS_MAIL_CC'],
         :subject => 'Day worklogs'
  end
end
