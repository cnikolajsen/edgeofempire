class Career < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :talent_trees

  default_scope order('name ASC')

end
