class CreateGears < ActiveRecord::Migration
  def change
    create_table :gears do |t|
      t.string :name
      t.text :description
      t.integer :price

      t.timestamps
    end
  end
end
