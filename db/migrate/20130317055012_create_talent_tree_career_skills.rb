class CreateTalentTreeCareerSkills < ActiveRecord::Migration
  def change
    create_table :talent_tree_career_skills do |t|
      t.integer :talent_tree_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
