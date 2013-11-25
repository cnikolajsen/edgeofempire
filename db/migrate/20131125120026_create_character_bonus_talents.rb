class CreateCharacterBonusTalents < ActiveRecord::Migration
  def change
    create_table :character_bonus_talents do |t|
      t.integer :character_id
      t.integer :talent_id
      t.string :bonus_type

      t.timestamps
    end
  end
end
