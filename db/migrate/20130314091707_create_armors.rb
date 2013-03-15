class CreateArmors < ActiveRecord::Migration
  def change
    create_table :armors do |t|
      t.string :name
      t.text :description
      t.integer :defense
      t.integer :soak
      t.integer :price

      t.timestamps
    end
  end
end
