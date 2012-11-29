class IdeaInappropriateReport < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	after_save :mark_idea_as_inappropriate

	# if the idea has been reported > 2 times,
	# mark idea as inappropriate
	def mark_idea_as_inappropriate
		reports = IdeaInappropriateReport.where(:idea_id => self.idea_id)
		if reports && reports.length > 2
			idea = Idea.find_by_id(self.idea_id)
				if idea
					idea.is_inappropriate = true
					idea.save
				end
		end
	end
end
