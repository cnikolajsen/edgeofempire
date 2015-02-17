class CreateVehicleWeaponQualityRanks < ActiveRecord::Migration
  def change
    create_table :vehicle_weapon_quality_ranks do |t|
      t.references :vehicle_weapon, index: true
      t.references :weapon_quality, index: true
      t.integer :ranks

      t.timestamps
    end
  end
end
