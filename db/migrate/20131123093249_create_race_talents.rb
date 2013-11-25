class CreateRaceTalents < ActiveRecord::Migration
  def change
    create_table :race_talents do |t|
      t.integer :race_id
      t.integer :talent_id
      t.integer :ranks

      t.timestamps
    end
  end
end
