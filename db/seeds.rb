########### Organization ####################
Organization.delete_all
OrganizationTranslation.delete_all
org = Organization.create(:id => 1, :url => "http://jumpstart.ge",
	:logo_file_name => "jumpstart-logo.png", :logo_content_type => "image/png",
	:logo_file_size => 3538, :logo_updated_at => Time.now)
org.organization_translations.create(:locale => 'ka', :name => 'JumpStart Georgia')
org.organization_translations.create(:locale => 'en', :name => 'JumpStart Georgia')


########### Category ####################
Category.delete_all
CategoryTranslation.delete_all

cat = Category.create(:id => 1)
cat.category_translations.create(:locale => 'ka', :name => 'Category 1 ka')
cat.category_translations.create(:locale => 'en', :name => 'Category 1 en')
cat = Category.create(:id => 2)
cat.category_translations.create(:locale => 'ka', :name => 'Category 2 ka')
cat.category_translations.create(:locale => 'en', :name => 'Category 2 en')
cat = Category.create(:id => 3)
cat.category_translations.create(:locale => 'ka', :name => 'Category 3 ka')
cat.category_translations.create(:locale => 'en', :name => 'Category 3 en')
cat = Category.create(:id => 4)
cat.category_translations.create(:locale => 'ka', :name => 'Category 4 ka')
cat.category_translations.create(:locale => 'en', :name => 'Category 4 en')
