class AddCareerToObligations < ActiveRecord::Migration
  def change
    add_column :obligations, :career_id, :integer
  end
end
