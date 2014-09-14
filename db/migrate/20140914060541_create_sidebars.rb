class CreateSidebars < ActiveRecord::Migration
  def change
    create_table :sidebars do |t|
      t.string :title
      t.text :content
      t.string :slug

      t.timestamps
    end

    add_index "sidebars", ["slug"], name: "index_sidebars_on_slug", unique: true, using: :btree
    add_index "sidebars", ["title"], name: "index_sidebars_on_title", unique: true, using: :btree
  end
end
