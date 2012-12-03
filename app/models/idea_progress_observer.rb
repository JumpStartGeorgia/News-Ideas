class IdeaProgressObserver < ActiveRecord::Observer

	# after an idea progress has been saved, notify the owner
	def after_create(idea_progress)
		message = Message.new
		message.email = idea_progress.idea.user.email

		# determine if idea is realized
		if idea_progress.is_completed && idea_progress.url
			# idea realized
			message.subject = I18n.t("mailer.idea_reazlied.subject", :organization => idea_progress.organization.name)
			message.message = I18n.t("mailer.idea_reazlied.message",
													:organization => idea_progress.organization.name)
			message.org_message = idea_progress.explaination
			message.url = idea_progress.url

			IdeaProgressMailer.idea_realized(message).deliver
		else
			# see if this is the idea is being claimed by someone
			ideas = IdeaProgress.where(:idea_id => idea_progress.idea_id, :organization_id => idea_progress.organization_id)

			if ideas && !ideas.empty?
				# org is claiming idea
				message.subject = I18n.t("mailer.idea_claimed.subject", :organization => idea_progress.organization.name)
				message.message = I18n.t("mailer.idea_claimed.message",
														:organization => idea_progress.organization.name)
				message.org_message = idea_progress.explaination

				IdeaProgressMailer.idea_claimed(message).deliver
			else
				# org already claimed, just an update
				message.subject = I18n.t("mailer.idea_progress_update.subject", :organization => idea_progress.organization.name)
				message.message = I18n.t("mailer.idea_progress_update.message",
														:organization => idea_progress.organization.name)
				message.org_message = idea_progress.explaination

				IdeaProgressMailer.idea_progress_update(message).deliver
			end
		end

	end
end
