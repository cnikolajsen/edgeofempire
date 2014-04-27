class AddSlugToForcePowers < ActiveRecord::Migration
  def change
    add_column :force_powers, :slug, :string

    add_index :force_powers, :slug, unique: true
  end
end
