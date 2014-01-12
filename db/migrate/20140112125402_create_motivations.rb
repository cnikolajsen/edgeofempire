class CreateMotivations < ActiveRecord::Migration
  def change
    create_table :motivations do |t|
      t.string :name
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
