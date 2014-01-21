class AddStatBonusToArmorAttachment < ActiveRecord::Migration
  def change
    add_column :armor_attachments, :stat_bonus, :string
  end
end
