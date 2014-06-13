class CreateCharacterCustomGears < ActiveRecord::Migration
  def change
    create_table :character_custom_gears do |t|
      t.integer :character_id
      t.string :description
      t.integer :encumbrance
      t.integer :qty
      t.boolean :carried

      t.timestamps
    end
  end
end
