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
