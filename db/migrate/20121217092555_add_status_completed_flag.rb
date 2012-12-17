class AddStatusCompletedFlag < ActiveRecord::Migration
  def up
		add_column :idea_statuses, :is_published, :boolean, :default => false
  end

  def down
		remove_column :idea_statuses, :is_published
  end
end
