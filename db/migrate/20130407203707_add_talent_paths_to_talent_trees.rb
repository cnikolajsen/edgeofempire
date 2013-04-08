class AddTalentPathsToTalentTrees < ActiveRecord::Migration
  def change
    add_column :talent_trees, :talent_2_1_require_1_1, :integer
    add_column :talent_trees, :talent_2_1_require_2_2, :integer
    add_column :talent_trees, :talent_2_2_require_1_2, :integer
    add_column :talent_trees, :talent_2_2_require_2_3, :integer
    add_column :talent_trees, :talent_2_3_require_1_3, :integer
    add_column :talent_trees, :talent_2_3_require_2_4, :integer
    add_column :talent_trees, :talent_2_4_require_1_4, :integer

    add_column :talent_trees, :talent_3_1_require_2_1, :integer
    add_column :talent_trees, :talent_3_1_require_3_2, :integer
    add_column :talent_trees, :talent_3_2_require_2_2, :integer
    add_column :talent_trees, :talent_3_2_require_3_3, :integer
    add_column :talent_trees, :talent_3_3_require_2_3, :integer
    add_column :talent_trees, :talent_3_3_require_3_4, :integer
    add_column :talent_trees, :talent_3_4_require_2_4, :integer

    add_column :talent_trees, :talent_4_1_require_3_1, :integer
    add_column :talent_trees, :talent_4_1_require_4_2, :integer
    add_column :talent_trees, :talent_4_2_require_3_2, :integer
    add_column :talent_trees, :talent_4_2_require_4_3, :integer
    add_column :talent_trees, :talent_4_3_require_3_3, :integer
    add_column :talent_trees, :talent_4_3_require_4_4, :integer
    add_column :talent_trees, :talent_4_4_require_3_4, :integer

  end
end
