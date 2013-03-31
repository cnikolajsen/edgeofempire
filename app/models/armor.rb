class Armor < ActiveRecord::Base
  attr_accessible :defense, :description, :name, :price, :soak
  
  has_many :character_armors
  has_many :armors, :through => :character_armors
  
end
