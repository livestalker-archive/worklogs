#encoding: utf-8
class WorklogMailer < Mailer

  def get_all_debtors
    @all_users = User.status('1').all
    users_need_worklogs = Array.new
    @all_users.each do |user|
      worklog = Worklog.where(:user_id => user.id)
      if worklog.empty?
        users_need_worklogs.push user.id
      end
    end
    @all_need_worklogs_users = User.where(id: users_need_worklogs)
  end

  def check_worklogs(day)
    #@url = url_for(:controller => 'worklogs', :action => 'index', :day => day)
    @day = day || Date.today.to_s
    get_all_debtors
    recipients = @all_need_worklogs_users.collect(&:mail)
    recipient_manager = 'alexey@livestalker.net'
    mail :to => recipient_manager,
         :subject => 'Test worklogs'
  end

end