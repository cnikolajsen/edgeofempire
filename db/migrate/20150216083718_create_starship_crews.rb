class CreateStarshipCrews < ActiveRecord::Migration
  def change
    create_table :starship_crews do |t|
      t.references :starship, index: true
      t.string :description
      t.integer :qty

      t.timestamps
    end
  end
end
