class CreateCareerTalentTrees < ActiveRecord::Migration
  def up
    create_table :career_talent_trees do |t|
      t.integer :career_id
      t.integer :talent_tree_id

      t.timestamps
    end

    remove_column :talent_trees, :career_id
  end

  def down
    drop_table :career_talent_trees
    add_column :talent_trees, :career_id, :integer
  end
end
