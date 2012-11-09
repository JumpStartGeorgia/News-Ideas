class CreateIdeaCategories < ActiveRecord::Migration
  def change
    create_table :idea_categories do |t|
      t.integer :idea_id
      t.integer :category_id

      t.timestamps
    end

		add_index :idea_categories, :idea_id
		add_index :idea_categories, :category_id
  end
end
