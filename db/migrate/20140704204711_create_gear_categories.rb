class CreateGearCategories < ActiveRecord::Migration
  def change
    create_table :gear_categories do |t|
      t.string :name

      t.timestamps
    end

    add_column :gears, :gear_category_id, :integer, index: true
  end
end
