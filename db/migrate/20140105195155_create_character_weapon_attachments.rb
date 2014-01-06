class CreateCharacterWeaponAttachments < ActiveRecord::Migration
  def change
    create_table :character_weapon_attachments do |t|
      t.integer :character_weapon_id
      t.integer :weapon_attachment_id
      t.string :weapon_attachment_modification_options

      t.timestamps
    end
  end
end
