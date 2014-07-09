class CreateWeaponAttachmentsGroups < ActiveRecord::Migration
  def change
    create_table :weapon_attachments_groups do |t|
      t.integer :weapon_id
      t.integer :attachment_group_id

      t.timestamps
    end
  end
end
