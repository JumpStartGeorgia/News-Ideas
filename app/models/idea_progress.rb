class IdeaProgress < ActiveRecord::Base
	belongs_to :idea
	belongs_to :organization
end
