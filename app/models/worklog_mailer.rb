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

  def send_reminder(day)
    @day = day || Date.today.to_s
    get_all_debtors
    recipients = @all_need_worklogs_users.collect(&:mail)
    mail :to => recipients,
         :subject => 'Worklogs reminder'
  end

  def send_all_worklogs(day)
    @day = day || Date.today.to_s
    @worklogs = Worklog.where('DATE(created_at) = ?', @day).order('created_at desc, id desc')
    mail :to => Setting.plugin_worklogs['WORKLOGS_MAIL_GLOBAL'],
         :cc => Setting.plugin_worklogs['WORKLOGS_MAIL_CC'],
         :subject => 'Day worklogs'
  end

  def send_estimate_pm
    # constants
    closed_issue_id = 5
    rejected_issue_id = 6
    anjep_group_id = 3
    active_user_status_id = '1'
    # custom fields
    @estimate_pm = CustomField.find_by_name('Estimate PM')
    @estimate_dev = CustomField.find_by_name('Estimate DEV')
    # Anjep group
    @group = Group.find(anjep_group_id)
    # Active users in group
    @users = @group.users.status(active_user_status_id)
    # Issues assignet to selected users with status not[closed, rejected]
    @issues = Issue.where(assigned_to: @users).where.not(status_id: [closed_issue_id, rejected_issue_id])
    mail :to => Setting.plugin_worklogs['WORKLOGS_MAIL_GLOBAL'],
         :cc => Setting.plugin_worklogs['WORKLOGS_MAIL_CC'],
         :subject => 'Estimate PM report'
  end

  def send_estimate_dev
    # constants
    closed_issue_id = 5
    rejected_issue_id = 6
    anjep_group_id = 3
    active_user_status_id = '1'
    # custom fields
    @estimate_pm = CustomField.find_by_name('Estimate PM')
    @estimate_dev = CustomField.find_by_name('Estimate DEV')
    # Anjep group
    @group = Group.find(anjep_group_id)
    # Active users in group
    @users = @group.users.status(active_user_status_id)
    # Issues assignet to selected users with status not[closed, rejected]
    @issues = Issue.where(assigned_to: @users).where.not(status_id: [closed_issue_id, rejected_issue_id])
    mail :to => Setting.plugin_worklogs['WORKLOGS_MAIL_GLOBAL'],
         :cc => Setting.plugin_worklogs['WORKLOGS_MAIL_CC'],
         :subject => 'Estimate DEV report'
  end

  def send_estimate_dev_p(user)
    # constants
    closed_issue_id = 5
    rejected_issue_id = 6
    @issues = Issue.where(assigned_to: user).where.not(status_id: [closed_issue_id, rejected_issue_id])
    mail :to => 'mi.aleksio@gmail.com',
         :subject => 'Personal Estimate DEV report'
  end
end
