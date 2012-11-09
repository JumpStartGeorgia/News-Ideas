class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.integer :user_id
      t.text :explaination
      t.string :individual_votes
      t.integer :overall_votes
      t.boolean :is_inappropriate, :default => false
      t.boolean :is_duplicate, :default => false

      t.timestamps
    end

		add_index :ideas, :user_id
		add_index :ideas, :overall_votes
		add_index :ideas, [:is_inappropriate, :is_duplicate], :name => 'idea_must_hide'
  end
end
