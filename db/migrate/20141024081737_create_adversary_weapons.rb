class CreateAdversaryWeapons < ActiveRecord::Migration
  def change
    create_table :adversary_weapons do |t|
      t.integer :adversary_id
      t.integer :weapon_id
      t.text :description

      t.timestamps
    end
  end
end
