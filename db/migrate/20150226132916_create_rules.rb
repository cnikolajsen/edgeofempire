class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :title
      t.text :content
      t.string :slug

      t.timestamps
    end

    add_index "rules", ["slug"], name: "index_rules_on_slug", unique: true, using: :btree
    add_index "rules", ["title"], name: "index_rules_on_title", unique: true, using: :btree
  end
end
