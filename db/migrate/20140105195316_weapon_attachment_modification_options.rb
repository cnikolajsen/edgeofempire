class WeaponAttachmentModificationOptions < ActiveRecord::Migration
  def change
    create_table :weapon_attachment_modification_options do |t|
      t.integer :weapon_attachment_id
      t.integer :talent_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
