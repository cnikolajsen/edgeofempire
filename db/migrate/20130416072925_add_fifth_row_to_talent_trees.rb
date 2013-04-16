class AddFifthRowToTalentTrees < ActiveRecord::Migration
  def change
    add_column :talent_trees, :talent_5_1, :integer
    add_column :talent_trees, :talent_5_1_require_4_1, :integer
    add_column :talent_trees, :talent_5_1_require_5_2, :integer
    add_column :talent_trees, :talent_5_2, :integer
    add_column :talent_trees, :talent_5_2_require_4_2, :integer
    add_column :talent_trees, :talent_5_2_require_5_3, :integer
    add_column :talent_trees, :talent_5_3, :integer
    add_column :talent_trees, :talent_5_3_require_4_3, :integer
    add_column :talent_trees, :talent_5_3_require_5_4, :integer
    add_column :talent_trees, :talent_5_4, :integer
    add_column :talent_trees, :talent_5_4_require_4_4, :integer
    
    add_column :character_talents, :talent_5_1, :integer
    add_column :character_talents, :talent_5_2, :integer
    add_column :character_talents, :talent_5_3, :integer
    add_column :character_talents, :talent_5_4, :integer

  end
end
