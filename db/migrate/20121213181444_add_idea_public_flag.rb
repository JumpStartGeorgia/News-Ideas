class AddIdeaPublicFlag < ActiveRecord::Migration
  def change
    add_column :ideas, :is_private, :boolean, :default => false
    add_index :ideas, :is_private
  end

end
