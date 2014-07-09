class CreateAttachmentGroups < ActiveRecord::Migration
  def change
    create_table :attachment_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
