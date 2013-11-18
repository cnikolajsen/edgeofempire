class Talent < ActiveRecord::Base
  #attr_accessible :activation, :cost, :description, :name, :ranked, :specialization_id, :talent_type
  
  #belongs_to :talent_trees

  default_scope { order('name ASC') }
end
