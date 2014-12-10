class CreateAdversaryArmors < ActiveRecord::Migration
  def change
    create_table :adversary_armors do |t|
      t.integer :adversary_id
      t.integer :armor_id
      t.text :description

      t.timestamps
    end
  end
end
