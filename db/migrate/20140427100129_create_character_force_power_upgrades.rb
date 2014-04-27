class CreateCharacterForcePowerUpgrades < ActiveRecord::Migration
  def change
    create_table :character_force_power_upgrades do |t|
      t.integer :character_id
      t.integer :force_power_id
      t.integer :force_power_upgrade_id

      t.timestamps
    end
  end
end
