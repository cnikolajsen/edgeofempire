class CreateWeaponAttachmentQualityRanks < ActiveRecord::Migration
  def change
    create_table :weapon_attachment_quality_ranks do |t|
      t.integer :weapon_attachment_id
      t.integer :weapon_quality_id
      t.integer :ranks

      t.timestamps
    end
  end
end
