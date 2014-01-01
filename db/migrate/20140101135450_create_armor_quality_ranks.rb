class CreateArmorQualityRanks < ActiveRecord::Migration
  def change
    create_table :armor_quality_ranks do |t|
      t.integer :armor_attachment_id
      t.integer :armor_quality_id
      t.integer :ranks

      t.timestamps
    end
  end
end

