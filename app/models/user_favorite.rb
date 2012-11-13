class UserFavorite < ActiveRecord::Base
	belongs_to :users
	belongs_to :idea

	attr_accessible :user_id, :idea_id
end
