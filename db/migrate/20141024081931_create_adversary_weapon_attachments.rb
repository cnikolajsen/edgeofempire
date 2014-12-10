class CreateAdversaryWeaponAttachments < ActiveRecord::Migration
  def change
    create_table :adversary_weapon_attachments do |t|
      t.integer :adversary_weapon_id
      t.integer :weapon_attachment_id
      t.string :weapon_attachment_modification_options

      t.timestamps
    end
  end
end
