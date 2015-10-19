#encoding: utf-8
class WorklogMailer < Mailer

  def check_worklogs(day)
    #@url = url_for(:controller => 'worklogs', :action => 'index', :day => day)

    #recipients
    mail :to =>  '' ,
         :subject => 'Test worklogs'
  end
  
end