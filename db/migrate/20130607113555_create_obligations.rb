class CreateObligations < ActiveRecord::Migration
  def change
    create_table :obligations do |t|
      t.string :name
      t.text :description
      t.string :range

      t.timestamps
    end
  end
end
