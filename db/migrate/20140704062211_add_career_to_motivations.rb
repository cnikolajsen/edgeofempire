class AddCareerToMotivations < ActiveRecord::Migration
  def change
    add_column :motivations, :career_id, :integer
  end
end
