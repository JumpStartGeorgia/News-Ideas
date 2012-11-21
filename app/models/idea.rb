class Idea < ActiveRecord::Base
	has_many :idea_categories, :dependent => :destroy
	has_many :idea_progresses, :dependent => :destroy
	has_many :user_favorites, :dependent => :destroy
	belongs_to :user

  accepts_nested_attributes_for :idea_categories

	attr_accessible :user_id,
      :explaination,
      :individual_votes,
      :overall_votes,
      :is_inappropriate,
      :is_duplicate,
			:idea_categories_attributes

  require 'split_votes'
  include SplitVotes

	def self.explore(type)
		if type
			case type.downcase
			when 'top'
				top_ideas
			when 'new'
				new_ideas
			when 'in_progress'
				in_progress_ideas
			when 'realized'
				realized_ideas
			end
		end
	end

	def self.top_ideas
		order("overall_votes desc, created_at desc")
	end

	def self.new_ideas
		order("created_at desc")
	end

	def self.in_progress_ideas
		joins(:idea_progresses).where(:idea_progresses => {:is_completed => false}).order("idea_progresses.progress_date desc, ideas.created_at desc")
	end

	def self.realized_ideas
		joins(:idea_progresses).where(:idea_progresses => {:is_completed => true}).order("idea_progresses.progress_date desc, ideas.created_at desc")
	end

	def self.categorized_ideas(category_id)
		if category_id
			joins(:idea_categories).where(:idea_categories => {:category_id => category_id})
		end
	end

	def self.search_by(query)
		if query
			where("ideas.explaination like ?", "%#{query}%")
		end
	end

	def self.user_ideas(user_id)
		if user_id
			where(:user_id => user_id)
		end
	end

	def self.user_favorite_ideas(user_id)
		if user_id
			joins(:user_favories).where(:user_favorites => {:user_id => user_id})
		end
	end

	def self.organization_ideas(organization_id)
		if organization_id
			joins(:idea_progresses).where(:idea_progresses => {:organization_id => organization_id})
		end
	end
end
