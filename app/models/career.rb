class Career < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :talent_trees
end
