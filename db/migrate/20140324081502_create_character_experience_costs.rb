class CreateCharacterExperienceCosts < ActiveRecord::Migration
  def change
    create_table :character_experience_costs do |t|
      t.integer :character_id
      t.string :resource_type
      t.integer :resource_id
      t.integer :cost
      t.string :granted_by
      t.integer :rank

      t.timestamps
    end
  end
end