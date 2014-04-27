class CreateForcePowers < ActiveRecord::Migration
  def change
    create_table :force_powers do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
