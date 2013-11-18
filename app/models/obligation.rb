class Obligation < ActiveRecord::Base
  #attr_accessible :description, :name, :range

  has_many :character_obligations
  has_many :characters, :through => :character_obligations

end
