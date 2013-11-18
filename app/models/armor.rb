class Armor < ActiveRecord::Base
  has_many :character_armors
  has_many :characters, :through => :character_armors

  default_scope { order('name ASC') }

end
