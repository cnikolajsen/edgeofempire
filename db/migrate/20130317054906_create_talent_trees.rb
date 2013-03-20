class CreateTalentTrees < ActiveRecord::Migration
  def change
    create_table :talent_trees do |t|
      t.string :name
      t.text :description
      t.integer :talent_1_1
      t.integer :talent_1_2
      t.integer :talent_1_3
      t.integer :talent_1_4
      t.integer :talent_2_1
      t.integer :talent_2_2
      t.integer :talent_3_3
      t.integer :talent_4_4
      t.integer :talent_3_1
      t.integer :talent_3_2
      t.integer :talent_3_3
      t.integer :talent_3_4
      t.integer :talent_4_1
      t.integer :talent_4_2
      t.integer :talent_4_3
      t.integer :talent_4_4

      t.timestamps
    end
  end
end
