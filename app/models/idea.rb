class Idea < ActiveRecord::Base
	require 'utf8_converter'

	has_many :idea_categories, :dependent => :destroy
	has_many :idea_progresses, :dependent => :destroy
	has_many :user_favorites, :dependent => :destroy
	has_many :idea_inappropriate_reports, :dependent => :destroy
	belongs_to :user

  accepts_nested_attributes_for :idea_categories

	attr_accessible :user_id,
      :explaination,
      :individual_votes,
      :overall_votes,
      :is_inappropriate,
      :is_duplicate,
			:idea_categories_attributes
	attr_accessor :is_create

  validates :user_id, :explaination, :presence => true

  require 'split_votes'
  include SplitVotes

	self.per_page = 10

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

	# only get appropriate ideas
	def self.appropriate
		where(:is_inappropriate => false)
	end

	# get the top ideas based off of overall votes
	def self.top_ideas
		order("overall_votes desc, created_at desc")
	end

	# get the new ideas based off of the date the record was created
	def self.new_ideas
		order("created_at desc")
	end

	# get ideas that have been claimed and have not been completed
	# - if > 1 or has claimed idea and one is not finished, still show idea
	def self.in_progress_ideas
		completed_ideas = IdeaProgress.select("distinct idea_id, organization_id").where(:is_completed => true)
		if completed_ideas.nil? || completed_ideas.empty?
			select("distinct ideas.*")
			.joins(:idea_progresses)
			.order("idea_progresses.progress_date desc, ideas.created_at desc")
		else
			select("distinct ideas.*")
			.joins(:idea_progresses)
			.where("idea_progresses.idea_id not in (?) or idea_progresses.organization_id not in (?)",
				completed_ideas.map{|x| x.idea_id}, completed_ideas.map{|x| x.organization_id})
			.order("idea_progresses.progress_date desc, ideas.created_at desc")
		end
	end

	# get ideas that have only been completed
	# - if > 1 or has claimed idea and one is not finished, still show idea
	def self.realized_ideas
		completed_ideas = IdeaProgress.select("distinct idea_id").where(:is_completed => true)

		if completed_ideas && !completed_ideas.empty?
			select("distinct ideas.*")
			.joins(:idea_progresses)
			.where("ideas.id in (?)",
				completed_ideas.map{|x| x.idea_id})
			.order("idea_progresses.progress_date desc, ideas.created_at desc")
		end
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

	def claimed_by_organizations
		x = self.idea_progresses.map{|x| x.organization_id}.uniq
		return Organization.where(:id => x)
	end

	def organization_progress(organization_id)
		if organization_id
			self.idea_progresses.select{|x| x.organization_id == organization_id}.sort{|a,b| b.progress_date <=> a.progress_date}
		end
	end

	def organization_claimed_idea?(organization_id)
		if organization_id && !self.claimed_by_organizations.index{|x| x.id == organization_id}.nil?
			return true
		end
		return false
	end

	def organization_realized_idea?(organization_id)
		if organization_id && !self.idea_progresses.index{|x| x.organization_id == organization_id && x.is_completed}.nil?
			return true
		end
		return false
	end
end
