class Category < ActiveRecord::Base
	translates :name

	has_many :idea_categories, :dependent => :destroy
	has_many :category_translations, :dependent => :destroy
	has_attached_file :picture,
    :url => "/system/category/:attachment/:id/:filename",
    :path => ":rails_root/public/system/category/:attachment/:id/:filename"
	has_attached_file :icon,
    :url => "/system/category/:attachment/:id/:filename",
    :path => ":rails_root/public/system/category/:attachment/:id/:filename"

  accepts_nested_attributes_for :category_translations
  attr_accessible :id, :picture, :icon, :category_translations_attributes

	scope :sorted_by_name, order("category_translations.name asc")

end
