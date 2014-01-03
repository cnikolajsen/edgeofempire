class CreateGearModels < ActiveRecord::Migration
  def change
    create_table :gear_models do |t|
      t.integer :gear_id
      t.string :name

      t.timestamps
    end
  end
end
