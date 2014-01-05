class CreateWeaponModels < ActiveRecord::Migration
  def change
    create_table :weapon_models do |t|
      t.integer :weapon_id
      t.string :name

      t.timestamps
    end
  end
end
