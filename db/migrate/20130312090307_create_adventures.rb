class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :name
      t.text :description
      t.integer :campaign_id

      t.timestamps
    end
  end
end
