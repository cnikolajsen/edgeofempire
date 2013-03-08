class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false, :default => ''
      t.string :email, :null => false, :default => ''
      t.string :password_hash, :null => false, :default => ''
      t.string :password_salt, :null => false, :default => ''
      t.string :first_name, :null => false, :default => ''
      t.string :last_name, :null => false, :default => ''
      t.string :city, :null => false, :default => ''
      t.string :state, :null => false, :default => ''
      t.string :postal_code, :null => false, :default => ''
      t.integer :country_id, :null => false, :default => 0
      t.boolean :enabled, :null => false, :default => true
      t.text :notes

      t.timestamps
    end

    add_index :users, :enabled, :unique => false
  end

  def self.down
    drop_table :users
  end
end
