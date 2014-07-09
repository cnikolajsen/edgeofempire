class CreateArmorAttachmentAttachmentsGroups < ActiveRecord::Migration
  def change
    create_table :armor_attachment_attachments_groups do |t|
      t.integer :armor_attachment_id
      t.integer :attachment_group_id

      t.timestamps
    end
  end
end
