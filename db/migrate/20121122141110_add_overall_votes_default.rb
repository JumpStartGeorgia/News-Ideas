class AddOverallVotesDefault < ActiveRecord::Migration
  def up
		change_column :ideas, :overall_votes, :integer, :default => 0

		# update all values that are null to 0
		Idea.where(:overall_votes => nil).update_all(:overall_votes => 0)
  end

  def down
		change_column :ideas, :overall_votes, :integer
  end
end
