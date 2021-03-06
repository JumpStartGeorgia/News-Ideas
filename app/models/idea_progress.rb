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
			:is_private,
			:idea_status_id
	attr_accessor :is_create

  validates :idea_id, :organization_id, :idea_status_id, :progress_date, :presence => true

  scope :public_only, where("idea_progresses.is_private = '0'")
  before_save :set_is_completed

  def set_is_completed
Rails.logger.debug "------- is completed was #{self.is_completed}"
    self.is_completed = self.idea_status.is_published
Rails.logger.debug "------- is completed is now #{self.is_completed}"
  end

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

	def self.with_private(user=nil)
	  if user && !user.organizations.empty?
      # only get private progress if user is from the org that submitted the ideas
      where("idea_progresses.is_private = 0 or (idea_progresses.is_private = 1 and organization_id in (?))", user.organization_users.map{|x| x.organization_id})
	  else
	    public_only
	  end
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

	def organization_wrote_progress?(user=nil)
		wrote = false
		# continue if user is assigned to org
		if user && user.organization_ids
			if !user.organization_ids.index(self.organization_id).nil?
				# found match
				wrote = true
			end
		end
		return wrote
	end


end
