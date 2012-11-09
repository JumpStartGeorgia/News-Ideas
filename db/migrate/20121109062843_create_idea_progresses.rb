class CreateIdeaProgresses < ActiveRecord::Migration
  def change
    create_table :idea_progresses do |t|
      t.integer :idea_id
      t.integer :organization_id
      t.date :progress_date
      t.text :explaination
      t.boolean :is_completed
			t.string :url

      t.timestamps
    end

		add_index :idea_progresses, [:idea_id, :organization_id], :name => 'idea_prog_idea_org'
		add_index :idea_progresses, :progress_date
		add_index :idea_progresses, :is_completed
  end
end
