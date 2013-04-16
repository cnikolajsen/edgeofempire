class Talent < ActiveRecord::Base
  attr_accessible :activation, :cost, :description, :name, :ranked, :specialization_id, :talent_type
  
  has_and_belongs_to_many :talent_trees

  default_scope order('name ASC')
end
