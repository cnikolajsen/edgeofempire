class CreateForcePowerUpgrades < ActiveRecord::Migration
  def change
    create_table :force_power_upgrades do |t|
      t.string :name
      t.text :description
      t.boolean :ranked
      t.integer :cost
      t.integer :row
      t.integer :column
      t.integer :colspan
      t.integer :parent_1
      t.integer :parent_2
      t.integer :force_power_id

      t.timestamps
    end
  end
end
