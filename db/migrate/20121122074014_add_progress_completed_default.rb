class AddProgressCompletedDefault < ActiveRecord::Migration
  def up
		change_column :idea_progresses, :is_completed, :boolean, :default => false
  end

  def down
		change_column :idea_progresses, :is_completed, :boolean
  end
end
