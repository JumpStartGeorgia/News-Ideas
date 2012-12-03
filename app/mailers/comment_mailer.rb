class CommentMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']

  def new_comment(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

end
