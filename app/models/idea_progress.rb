class IdeaProgress < ActiveRecord::Base
	belongs_to :idea
	belongs_to :organization

	attr_accessible :idea_id,
      :organization_id,
      :progress_date,
      :explaination,
      :is_completed,
			:url

  validates :idea_id, :organization_id, :progress_date, :explaination, :presence => true

end
