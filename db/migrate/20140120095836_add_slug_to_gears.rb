class AddSlugToGears < ActiveRecord::Migration
  def change
    add_column :gears, :slug, :string
    add_column :armors, :slug, :string
    add_column :weapons, :slug, :string
    add_column :careers, :slug, :string
    add_column :races, :slug, :string
    add_column :skills, :slug, :string
    add_column :talent_trees, :slug, :string
    add_column :users, :slug, :string

    add_index :gears, :slug, unique: true
    add_index :armors, :slug, unique: true
    add_index :weapons, :slug, unique: true
    add_index :careers, :slug, unique: true
    add_index :races, :slug, unique: true
    add_index :skills, :slug, unique: true
    add_index :talent_trees, :slug, unique: true
    add_index :users, :slug, unique: true
  end
end
