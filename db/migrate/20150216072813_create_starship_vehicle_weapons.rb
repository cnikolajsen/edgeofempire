class CreateStarshipVehicleWeapons < ActiveRecord::Migration
  def change
    create_table :starship_vehicle_weapons do |t|
      t.references :starship, index: true
      t.references :vehicle_weapon, index: true
      t.string :mounting
      t.string :grouping
      t.boolean :turret
      t.boolean :retractable

      t.timestamps
    end
  end
end
