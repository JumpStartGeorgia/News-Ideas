class UserMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']
	layout 'mailer'

  def new_user(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

end
