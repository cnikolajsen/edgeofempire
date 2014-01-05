class CreateArmorModels < ActiveRecord::Migration
  def change
    create_table :armor_models do |t|
      t.integer :armor_id
      t.string :name

      t.timestamps
    end
  end
end
