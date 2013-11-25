class CreateRaceSkills < ActiveRecord::Migration
  def change
    create_table :race_skills do |t|
      t.integer :race_id
      t.integer :skill_id
      t.integer :ranks

      t.timestamps
    end
  end
end
