class AddTalentsToTalentTree < ActiveRecord::Migration
  def change
    add_column :talent_trees, :talent_2_3, :integer
    add_column :talent_trees, :talent_2_4, :integer
  end
end
