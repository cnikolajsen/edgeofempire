class Armor < ActiveRecord::Base
  attr_accessible :defense, :description, :name, :price, :soak
  
  has_many :character_armors
  has_many :characters, :through => :character_armors

  default_scope order('name ASC')

end
