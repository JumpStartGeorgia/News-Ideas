class AddProgressPrivateFlag < ActiveRecord::Migration
  def change
    add_column :idea_progresses, :is_private, :boolean, :default => false
    add_index :idea_progresses, :is_private
  end
end
