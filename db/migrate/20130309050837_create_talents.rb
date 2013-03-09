class CreateTalents < ActiveRecord::Migration
  def change
    create_table :talents do |t|
      t.string :name
      t.text :description
      t.string :activation
      t.boolean :ranked
      t.integer :cost
      t.integer :specialization_id
      t.string :talent_type

      t.timestamps
    end
  end
end
