class AddBookIdToGears < ActiveRecord::Migration
  def change
    add_column :gears, :book_id, :integer

    add_index 'gears', ['book_id'], name: 'index_gears_on_book_id'
  end
end
