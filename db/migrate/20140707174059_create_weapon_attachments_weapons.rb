class CreateWeaponAttachmentsWeapons < ActiveRecord::Migration
  def change
    create_table :weapon_attachments_weapons do |t|
      t.references :weapon, index: true
      t.references :weapon_attachment, index: true
      t.timestamps
    end
  end
end
