class CreateIdeaStatuses < ActiveRecord::Migration
  def self.up
    create_table :idea_statuses do |t|
      t.integer :sort, :default => 1
      t.timestamps
    end

		IdeaStatus.create_translation_table! :name => :string

		add_column :ideas, :current_status_id, :integer
		add_column :idea_progresses, :idea_status_id, :integer
  end

	def self.down
		remove_column :ideas, :current_status_id
		remove_column :idea_progresses, :idea_status_id
		IdeaStatus.drop_translation_table!
		drop_table :idea_statuses
	end
end
