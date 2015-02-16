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

    add_index 'vehicle_weapons', ['slug'], name: 'index_vehicle_weapons_on_slug', unique: true, using: :btree

    VehicleWeapon.create(name: 'Auto-Blaster', range: 'Close', damage: 3, critical: 5, price: 3000, rarity: 3, size_low: 2, size_high: 10)
    VehicleWeapon.create(name: 'Blaster Cannon (Light)', range: 'Close', damage: 4, critical: 4, price: 4000, rarity: 2, size_low: 2, size_high: 10)
    VehicleWeapon.create(name: 'Blaster Cannon (Heavy)', range: 'Close', damage: 5, critical: 4, price: 5000, rarity: 3, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Concussion Missile Launcher', range: 'Short', damage: 6, critical: 3, price: 7500, rarity: 5, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Ion Cannon (Light)', range: 'Close', damage: 5, critical: 4, price: 5000, rarity: 5, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Ion Cannon (Medium)', range: 'Short', damage: 6, critical: 4, price: 6000, rarity: 6, size_low: 5, size_high: 10)
    VehicleWeapon.create(name: 'Ion Cannon (Heavy)', range: 'Medium', damage: 7, critical: 4, price: 7500, rarity: 7, size_low: 6, size_high: 10)
    VehicleWeapon.create(name: 'Laser Cannon (Light)', range: 'Close', damage: 5, critical: 3, price: 5500, rarity: 4, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Laser Cannon (Medium)', range: 'Close', damage: 6, critical: 3, price: 7000, rarity: 4, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Laser Cannon (Heavy)', range: 'Short', damage: 6, critical: 3, price: 7500, rarity: 5, size_low: 4, size_high: 10)
    VehicleWeapon.create(name: 'Proton Torpedo Launcher', range: 'Short', damage: 8, critical: 2, price: 9000, rarity: 7, size_low: 3, size_high: 10)
    VehicleWeapon.create(name: 'Quad Laser Cannon', range: 'Close', damage: 5, critical: 3, price: 8000, rarity: 6, size_low: 4, size_high: 10)
    VehicleWeapon.create(name: 'Tractor Beam (Light)', range: 'Close', damage: nil, critical: nil, price: 6000, rarity: 4, size_low: 4, size_high: 10)
    VehicleWeapon.create(name: 'Tractor Beam (Medium)', range: 'Short', damage: nil, critical: nil, price: 8000, rarity: 5, size_low: 5, size_high: 10)
    VehicleWeapon.create(name: 'Tractor Beam (Heavy)', range: 'Short', damage: nil, critical: nil, price: 10_000, rarity: 6, size_low: 5, size_high: 10)
    VehicleWeapon.create(name: 'Turbolaser (Light)', range: 'Medium', damage: 9, critical: 3, price: 12_000, rarity: 7, size_low: 5, size_high: 10)
    VehicleWeapon.create(name: 'Turbolaser (Medium)', range: 'Long', damage: 10, critical: 3, price: 15_000, rarity: 7, size_low: 6, size_high: 10)
    VehicleWeapon.create(name: 'Turbolaser (Heavy)', range: 'Long', damage: 11, critical: 3, price: 20_000, rarity: 8, size_low: 6, size_high: 10)
  end
end
