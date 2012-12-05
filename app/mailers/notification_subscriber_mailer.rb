class NotificationSubscriberMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']

  def new_idea(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def new_comment(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def idea_claimed(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_progress_update(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_realized(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end


end
