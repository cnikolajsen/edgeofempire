class AddExternalImageUrlFields < ActiveRecord::Migration
  def change
    add_column :gears, :image_url, :string
    add_column :armors, :image_url, :string
    add_column :weapons, :image_url, :string
    add_column :careers, :image_url, :string
    add_column :characters, :image_url, :string
    add_column :races, :image_url, :string
  end
end
