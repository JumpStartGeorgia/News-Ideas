class CreateIdeaInappropriateReports < ActiveRecord::Migration
  def change
    create_table :idea_inappropriate_reports do |t|
      t.integer :idea_id
      t.integer :user_id
      t.string :reason

      t.timestamps
    end

		add_index :idea_inappropriate_reports, :idea_id
		add_index :idea_inappropriate_reports, :user_id
  end
end
