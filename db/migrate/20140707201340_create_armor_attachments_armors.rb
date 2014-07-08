class CreateArmorAttachmentsArmors < ActiveRecord::Migration
  def change
    create_table :armor_attachments_armors do |t|
      t.references :armor, index: true
      t.references :armor_attachment, index: true

      t.timestamps
    end
  end
end
