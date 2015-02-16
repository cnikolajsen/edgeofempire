class CreateVehicleWeapons < ActiveRecord::Migration
  def change
    create_table :vehicle_weapons do |t|
      t.string :name
      t.string :range
      t.integer :damage
      t.integer :critical
      t.integer :price
      t.integer :rarity
      t.integer :size_low
      t.integer :size_high
      t.string :slug

      t.timestamps
    end

    add_index "vehicle_weapons", ["slug"], name: "index_vehicle_weapons_on_slug", unique: true, using: :btree
  end
end
