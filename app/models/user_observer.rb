class UserObserver < ActiveRecord::Observer

	def after_create(user)
		user.is_create = true
	end

	# after user has been created, send welcome message
	def after_commit(user)
		# only process if a create just occurred
		if user.is_create
			message = Message.new
			message.subject = I18n.t("mailer.user.new_user.subject")
			message.message = I18n.t("mailer.user.new_user.message")
			UserMailer.new_user(message).deliver
			user.is_create = false # make sure duplicate messages are not sent
		end
	end
end
