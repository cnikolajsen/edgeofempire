class CreateStarships < ActiveRecord::Migration
  def change
    create_table :starships do |t|
      t.string :name
      t.text :description
      t.integer :silhouette
      t.integer :speed
      t.integer :handling
      t.integer :defense_fore
      t.integer :defense_port
      t.integer :defense_starboard
      t.integer :defense_aft
      t.integer :armor
      t.integer :hull_trauma_threshold
      t.integer :system_strain_threshold
      t.integer :hard_points
      t.string :hull_type
      t.string :manufacturer
      t.integer :hyperdrive_class_primary
      t.integer :hyperdrive_class_secondary
      t.string :navicomputer
      t.string :sensor_range
      t.integer :encumbrance_capacity
      t.integer :passenger_capacity
      t.string :consumables
      t.integer :cost
      t.integer :rarity
      t.integer :book_id
      t.integer :starship_category_id
      t.string :slug

      t.timestamps
    end

    add_index "starships", ["slug"], name: "index_starships_on_slug", unique: true, using: :btree
  end
end
