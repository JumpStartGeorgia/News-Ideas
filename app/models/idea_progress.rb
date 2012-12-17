class IdeaProgress < ActiveRecord::Base
	belongs_to :idea
	belongs_to :organization
	belongs_to :idea_status

	attr_accessible :idea_id,
      :organization_id,
      :progress_date,
      :explaination,
      :is_completed,
			:url,
			:idea_status_id
	attr_accessor :is_create

  validates :idea_id, :organization_id, :idea_status_id, :progress_date, :explaination, :presence => true

	# determine if the explaination is written in the locale
	def in_locale?(locale)
		in_locale = false
		if locale == :ka && Utf8Converter.is_geo?(self.explaination)
			in_locale = true
		elsif locale != :ka && !Utf8Converter.is_geo?(self.explaination)
			in_locale = true
		end
		return in_locale
	end


	def self.latest_organization_idea_progress(organization_id)
		ids = []
		if organization_id
			sql = "select p1.idea_id, p1.idea_status_id from idea_progresses as p1 left join idea_progresses as p2 "
			sql << "on p2.idea_id = p1.idea_id and p2.organization_id = p1.organization_id and "
			sql << "p1.progress_date < p2.progress_date and p1.updated_at < p2.updated_at "
			sql << "where p1.organization_id = ? and p2.id is null "
			ids = find_by_sql([sql, organization_id])
		end
		return ids
	end
end
