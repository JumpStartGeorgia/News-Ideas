class UserFavorite < ActiveRecord::Base
	belongs_to :users
	belongs_to :idea

end
