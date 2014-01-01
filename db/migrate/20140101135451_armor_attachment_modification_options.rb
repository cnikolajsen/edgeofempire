class ArmorAttachmentModificationOptions < ActiveRecord::Migration
  def change
    create_table :armor_attachment_modification_options do |t|
      t.integer :armor_attachment_id
      t.integer :talent_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
