class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.text :description
      t.integer :wound_threshold
      t.integer :strain_threshold
      t.integer :starting_experience
      t.text :special_ability
      t.integer :brawn
      t.integer :cunning
      t.integer :presence
      t.integer :agility
      t.integer :intellect
      t.integer :willpower

      t.timestamps
    end
  end
end
