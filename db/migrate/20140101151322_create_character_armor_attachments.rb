class CreateCharacterArmorAttachments < ActiveRecord::Migration
  def change
    create_table :character_armor_attachments do |t|
      t.integer :character_armor_id
      t.integer :armor_attachment_id
      t.integer :armor_attachment_modification_option_id

      t.timestamps
    end
  end
end
