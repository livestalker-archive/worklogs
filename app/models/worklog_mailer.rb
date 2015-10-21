#encoding: utf-8
class WorklogMailer < Mailer
  add_template_helper(WorklogsHelper)

  def is_vacation?(start_date, end_date)
    if start_date.nil? || end_date.nil?
      return false
    end
    if @day >= start_date && @day <=end_date
      return true
    else
      return false
    end
  end

  def get_all_debtors
    @all_users = User.status('1').all
    users_need_worklogs = Array.new
    field_worklogs_turnoff = CustomField.find_by_name('Worklogs turnoff')
    field_worklogs_start_date = CustomField.find_by_name('Worklogs turnoff start')
    field_worklogs_end_date = CustomField.find_by_name('Worklogs turnoff end')
    @all_users.each do |user|
      worklogs_turnoff = user.custom_field_value(field_worklogs_turnoff).to_i
      worklog = Worklog.where(:user_id => user.id).where('DATE(created_at) = ?', @day)
      if worklog.empty? && worklogs_turnoff == 0
        start_date = user.custom_field_value(field_worklogs_start_date)
        end_date = user.custom_field_value(field_worklogs_end_date)
        unless is_vacation?(start_date, end_date)
          users_need_worklogs.push user.id
        end
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
