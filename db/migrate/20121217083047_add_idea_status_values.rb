class AddIdeaStatusValues < ActiveRecord::Migration
  def up
		Idea.all.each do |idea|
			# if idea has progress report,
			# update idea status with chosen or published
			status_id_chosen = 1
			status_id_published = 7
			if !idea.idea_progresses.empty?
				last_report = idea.last_progress_report
				if last_report.is_completed
					idea.current_status_id = status_id_published
					last_report.idea_status_id = status_id_published
				else
					idea.current_status_id = status_id_chosen
					last_report.idea_status_id = status_id_chosen
				end
				idea.save
				last_report.save
			end
		end
  end

  def down
		Idea.update_all(:current_status_id => nil)
  end
end
