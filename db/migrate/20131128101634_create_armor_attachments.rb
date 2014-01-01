class CreateArmorAttachments < ActiveRecord::Migration
  def change
    create_table :armor_attachments do |t|
      t.string :name
      t.text :description
      t.integer :hard_points
      t.integer :price

      t.timestamps
    end
  end
end
