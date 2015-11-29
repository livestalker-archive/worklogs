class WorklogsController < ApplicationController
  unloadable

  def load_worklogs
    query = Worklog
    if @user_id && @user_id.to_i > 0
      query = query.where(:user_id => @user_id)
    end
    query = query.order('created_at desc, id desc')
    @limit = 5
    @count = query.count
    @pages = Paginator.new @count, @limit, params['page']
    @offset ||= @pages.offset
    @worklogs = query.limit(@limit).offset(@offset).all
  end

  def my
    @user_id = session[:user_id]
    @show_filters = false
    load_worklogs
    render :action => :index
  end

  def index
    if User.current.admin?
      @show_filters = true
      @users = User.status('1').all
      @user_id = params[:user_id]
      load_worklogs
    else
      @show_filters = false
      redirect_to worklogs_my_path
    end
  end

  def edit
    @worklog = Worklog.find(params[:id])
    @day = @worklog.created_at.to_date
  end

  def new
    @day = Date.today
    @worklog = Worklog.new()
  end

  def create
    logger.info('Create worklog')
    @worklog = Worklog.new(worklog_params)
    @worklog.author = User.current
    if @worklog.save
      flash[:notice] = 'Worklog successfully created.'
      @user_id = session[:user_id]
      redirect_to worklogs_path()
    end
  end

  def update
    logger.info('Update worklog')
    @worklog = Worklog.find(params[:id])
    @worklog.update_attributes(worklog_params)
    if request.patch? and @worklog.save
      flash[:notice] = 'Worklog successfully updated.'
      redirect_to worklogs_path()
    else
      render :action => 'edit', :id => @worklog.id
    end
  end

  def wtest
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
    @issues = Issue.where(assigned_to: @users).where.not(status_id: [closed_issue_id, rejected_issue_id])
    test1 = @issues[0].custom_field_value(@estimate_pm)
    puts(test1)
  end

  private

  def worklog_params
    params.require(:worklog).permit(:today, :tomorrow, :closed)
  end

end
