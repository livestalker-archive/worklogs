module WorklogsHelper
  def is_editable(worklog)
    if (worklog.created_at.to_date == Date.today) && (worklog.user_id == session[:user_id])
      return true
    end
    return false
  end
end
