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


end
