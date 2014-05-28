class AddSubspeciesToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :subspecies, :string
  end
end
