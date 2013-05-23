class CreateCareerSkills < ActiveRecord::Migration
  def change
    create_table :career_skills do |t|
      t.integer :career_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
