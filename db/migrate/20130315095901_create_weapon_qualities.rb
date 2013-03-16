class CreateWeaponQualities < ActiveRecord::Migration
  def change
    create_table :weapon_qualities do |t|
      t.string :name
      t.string :type
      t.text :description

      t.timestamps
    end
  end
end
