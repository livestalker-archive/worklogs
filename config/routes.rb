# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'worklogs', :to => 'worklogs#index'
get 'worklogs/my', :to => 'worklogs#my'
patch 'worklogs', :to => 'worklogs#update'
get 'worklogs/test', :to => 'worklogs#wtest'

resources :worklogs
