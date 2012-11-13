class Idea < ActiveRecord::Base
	has_many :idea_categories, :dependent => :destroy
	has_many :idea_progresses, :dependent => :destroy
	has_many :user_favorites, :dependent => :destroy
	belongs_to :user

	attr_accessible :user_id,
      :explaination,
      :individual_votes,
      :overall_votes,
      :is_inappropriate,
      :is_duplicate

	def self.top
		order("overall_votes desc")
	end

	def self.new
		order("created_at desc")
	end

	def self.in_progress
		joins(:idea_progresses).where(:idea_progresses => {:is_completed => false}).order("idea_progresses.progress_date desc, ideas.created_at desc")
	end

	def self.realized
		joins(:idea_progresses).where(:idea_progresses => {:is_completed => true}).order("idea_progresses.progress_date desc, ideas.created_at desc")
	end

	def self.category(category_id)
		if category_id
			joins(:idea_categories).where(:idea_categories => {:category_id => category_id})
		end
	end

	def self.user(user_id)
		if user_id
			joins(:user_favories).where(:user_favorites => {:user_id => user_id})
		end
	end

	def self.organization(organization_id)
		if organization_id
			joins(:idea_progresses).where(:idea_progresses => {:organization_id => organization_id})
		end
	end
end
