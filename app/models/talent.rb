class Talent < ActiveRecord::Base
  has_many :character_talents, :dependent => :destroy
  has_many :characters, :through => :character_talents
  has_many :races, :through => :race_talents

  default_scope { order('name ASC') }
end
