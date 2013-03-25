class AddCareerToTalentTrees < ActiveRecord::Migration
  def change
    add_column :talent_trees, :career_id, :integer
  end
end
