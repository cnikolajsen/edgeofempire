class CreateArmorQualities < ActiveRecord::Migration
  def change
    create_table :armor_qualities do |t|
      t.string :name
      t.string :trigger
      t.text :description

      t.timestamps
    end
  end
end
