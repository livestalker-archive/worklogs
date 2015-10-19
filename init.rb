Redmine::Plugin.register :worklogs do
  name 'Worklogs plugin'
  author 'Alexey V. Grebenshchikov'
  description ''
  version '0.1.0'
  url ''
  author_url ''

  permission :worklogs, {:worklogs => 'index', :worklogs => 'my'}

  settings :default => {'empty' => true}, :partial => 'settings/worklogs_settings'

  menu :top_menu,
       :worklogs,
       {:controller => 'worklogs', :action => 'my'},
       :caption => 'Worklogs',
       :after => :my_account,
       :param => :project_id
end
