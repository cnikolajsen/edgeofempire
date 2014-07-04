class CreateArmorCategories < ActiveRecord::Migration
  def change
    create_table :armor_categories do |t|
      t.string :name

      t.timestamps
    end

    add_column :armors, :armor_category_id, :integer, index: true
  end
end
