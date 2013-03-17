class RemoveTypeFromSkills < ActiveRecord::Migration
  def up
    remove_column :skills, :type
  end
end
