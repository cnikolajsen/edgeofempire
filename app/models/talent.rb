class Talent < ActiveRecord::Base
  #attr_accessible :activation, :cost, :description, :name, :ranked, :specialization_id, :talent_type
  
  #belongs_to :talent_trees

  has_many :character_talents, :dependent => :destroy
  has_many :characters, :through => :character_talents

  default_scope { order('name ASC') }
end
