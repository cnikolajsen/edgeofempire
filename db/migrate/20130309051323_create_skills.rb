class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.text :description
      t.string :characteristic
      t.string :type

      t.timestamps
    end
  end
end
