class AddUserToAdventureLogs < ActiveRecord::Migration
  def change
    add_column :adventure_logs, :user_id, :integer
  end
end
