class Armor < ActiveRecord::Base
  has_many :character_armors
  has_many :characters, :through => :character_armors
  has_many :armor_models
  accepts_nested_attributes_for :armor_models, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

end
