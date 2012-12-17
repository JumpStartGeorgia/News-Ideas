# encoding: UTF-8
########### Organization ####################
puts "organizations"
Organization.delete_all
OrganizationTranslation.delete_all
org = Organization.create(:id => 1, :url => "http://jumpstart.ge",
	:logo_file_name => "jumpstart-logo.png", :logo_content_type => "image/png",
	:logo_file_size => 3538, :logo_updated_at => Time.now)
org.organization_translations.create(:locale => 'ka', :name => 'JumpStart Georgia')
org.organization_translations.create(:locale => 'en', :name => 'JumpStart Georgia')


########### Category ####################
puts "categories"
Category.delete_all
CategoryTranslation.delete_all
cat = Category.create(:id => 1)
cat.category_translations.create(:locale => 'ka', :name => 'გარემო')
cat.category_translations.create(:locale => 'en', :name => 'Environment')
cat = Category.create(:id => 2)
cat.category_translations.create(:locale => 'ka', :name => 'ეკონომიკა / ბიზნესი')
cat.category_translations.create(:locale => 'en', :name => 'Economy / Business')
cat = Category.create(:id => 3)
cat.category_translations.create(:locale => 'ka', :name => 'ჯანმრთელობა / საზოგადოებრივი უსაფრთხოება')
cat.category_translations.create(:locale => 'en', :name => 'Health / Public Safety')
cat = Category.create(:id => 4)
cat.category_translations.create(:locale => 'ka', :name => 'განათლება')
cat.category_translations.create(:locale => 'en', :name => 'Education')
cat = Category.create(:id => 5)
cat.category_translations.create(:locale => 'ka', :name => 'პოლიტიკა')
cat.category_translations.create(:locale => 'en', :name => 'Politics')
cat = Category.create(:id => 6)
cat.category_translations.create(:locale => 'ka', :name => 'ცხოვრების სტილი / კულტურა')
cat.category_translations.create(:locale => 'en', :name => 'Lifestyle / Culture')
cat = Category.create(:id => 7)
cat.category_translations.create(:locale => 'ka', :name => 'სპორტი')
cat.category_translations.create(:locale => 'en', :name => 'Sports')
cat = Category.create(:id => 8)
cat.category_translations.create(:locale => 'ka', :name => 'ტექნოლოგია / მეცნიერება')
cat.category_translations.create(:locale => 'en', :name => 'Technology / Science')
cat = Category.create(:id => 9)
cat.category_translations.create(:locale => 'ka', :name => 'მსოფლიო')
cat.category_translations.create(:locale => 'en', :name => 'World')
cat = Category.create(:id => 10)
cat.category_translations.create(:locale => 'ka', :name => 'სამხედრო თავდაცვა')
cat.category_translations.create(:locale => 'en', :name => 'Defence')
cat = Category.create(:id => 11)
cat.category_translations.create(:locale => 'ka', :name => 'სამართალი')
cat.category_translations.create(:locale => 'en', :name => 'Justice')
cat = Category.create(:id => 12)
cat.category_translations.create(:locale => 'ka', :name => 'საზოგადოება')
cat.category_translations.create(:locale => 'en', :name => 'Society')

########### Idea Statuses ####################
puts "idea statuses"
IdeaStatus.delete_all
IdeaStatusTranslation.delete_all
stat = IdeaStatus.create(:id => 1, :sort => 1)
stat.idea_status_translations.create(:locale => 'ka', :name => 'არჩეულია')
stat.idea_status_translations.create(:locale => 'en', :name => 'Chosen')
stat = IdeaStatus.create(:id => 2, :sort => 2)
stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემები მოვითხოვეთ')
stat.idea_status_translations.create(:locale => 'en', :name => 'Data Requested')
stat = IdeaStatus.create(:id => 3, :sort => 3)
stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემები მივიღეთ')
stat.idea_status_translations.create(:locale => 'en', :name => 'Data Received')
stat = IdeaStatus.create(:id => 4, :sort => 4)
stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემებს ვაანალიზებთ')
stat.idea_status_translations.create(:locale => 'en', :name => 'Analysing Data')
stat = IdeaStatus.create(:id => 5, :sort => 5)
stat.idea_status_translations.create(:locale => 'ka', :name => 'ვაკეთებთ დიზაინს')
stat.idea_status_translations.create(:locale => 'en', :name => 'Designing')
stat = IdeaStatus.create(:id => 6, :sort => 6)
stat.idea_status_translations.create(:locale => 'ka', :name => 'გამოსაქვეყნებელია')
stat.idea_status_translations.create(:locale => 'en', :name => 'Waiting for Pub')
stat = IdeaStatus.create(:id => 7, :sort => 7)
stat.idea_status_translations.create(:locale => 'ka', :name => 'გამოქვეყნებულია')
stat.idea_status_translations.create(:locale => 'en', :name => 'Published')
stat = IdeaStatus.create(:id => 8, :sort => 8)
stat.idea_status_translations.create(:locale => 'ka', :name => 'გაუქმებულია')
stat.idea_status_translations.create(:locale => 'en', :name => 'Cancelled')
