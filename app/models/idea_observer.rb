class IdeaObserver < ActiveRecord::Observer

	# after an idea has been created, notify subscribers
	def after_create(idea)
		category_ids = idea.idea_categories.map{|x| x.category_id}
		if category_ids && !category_ids.empty?
			message = Message.new
			message.bcc = Notification.new_idea_users(category_ids)
			if message.bcc && !message.bcc.empty?
				# if the owner is a subscriber, remove from list
				index = message.bcc.index(idea.user.email)
				message.bcc.delete_at(index) if index
				# only continue if owner was not only subscriber
				if message.bcc.length > 0
					message.subject = I18n.t("mailer.subscriber.new_idea.subject")
					message.message = I18n.t("mailer.subscriber.new_idea.message")
					message.org_message = idea.explaination
					message.url_id = idea.id
					NotificationSubscriberMailer.new_idea(message).deliver
				end
			end
		end
	end
end
