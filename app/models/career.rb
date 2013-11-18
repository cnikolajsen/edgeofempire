class Career < ActiveRecord::Base
  #attr_accessible :description, :name, :career_skills_attributes

  has_many :talent_trees
  has_many :career_skills
  has_many :skills, :through => :career_skills
  accepts_nested_attributes_for :career_skills

  default_scope { order('name ASC') }

end
