class Idea < ActiveRecord::Base
	has_many :idea_categories, :dependent => :destroy
	has_many :idea_progresses, :dependent => :destroy
	has_many :user_favorites, :dependent => :destroy
	belongs_to :user



end
