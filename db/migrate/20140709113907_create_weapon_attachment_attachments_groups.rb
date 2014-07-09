class CreateWeaponAttachmentAttachmentsGroups < ActiveRecord::Migration
  def change
    create_table :weapon_attachment_attachments_groups do |t|
      t.integer :weapon_attachment_id
      t.integer :attachment_group_id

      t.timestamps
    end
  end
end
