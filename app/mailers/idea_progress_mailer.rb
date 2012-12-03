class IdeaProgressMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']

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
